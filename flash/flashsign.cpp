/*
 * flashsign.cpp
 *
 * Copyright (C) 2002 Bastian Blank <waldi@tuxbox.org>
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
 *
 * $Id: flashsign.cpp,v 1.1 2002/03/10 18:10:25 waldi Exp $
 */

#ifndef _GNU_SOURCE
#define _GNU_SOURCE
#endif

#ifdef HAVE_CONFIG_H
#include <config.h>
#endif

#include <fstream>
#include <iostream>
#include <map>
#include <sstream>
#include <string>

#include <getopt.h>
#include <sys/time.h>
#include <time.h>

#include <openssl/bio.h>
#include <openssl/pem.h>
#include <openssl/x509.h>

#define PROGRAM_NAME "flashsign"

#define AUTHORS "Bastian Blank"

const char * program_name;

static struct option long_options [] =
{
  { "certificate", required_argument, 0, 'c' },
  { "flash", required_argument, 0, 'f' },
  { "privatekey", required_argument, 0, 'k' },
  { "status", required_argument, 0, 's' },
  { "help", no_argument, 0, 250 },
  { "version", no_argument, 0, 251 },
  { 0, 0, 0, 0 }
};

void usage ( int status )
{
  if ( status != 0 )
    std::cerr << "Try `" << program_name << " --help' for more information.\n";
  else
    std::cout
      << "Usage: " << program_name << " [OPTIONS]\n\n"
      << "Sign a flash image\n\n"
      << "  -c, --certificate=FILE      certificate to sign\n"
      << "  -f, --flash=FILE            flash file for sign\n"
      << "  -k, --privatekey=FILE       private key to sign\n"
      << "  -s, --status=FILE           status file for flash\n"
      << "      --help                  display this help and exit\n"
      << "      --version               output version information and exit\n\n"
      << "The status file looks like the follow:\n"
      << "  Format: 1.0                                         (required)\n"
      << "  Date: <RFC822 compliant date>                       (optional)\n"
      << "  Maintainer: <RFC822 compilant name and email>       (required)\n"
      << "  Version: <version of flash>                         (required)\n";

  exit ( status );
}

std::map < std::string, std::string > parse_options ( int argc, char ** argv )
{
  char c;
  int option_index;
  std::map < std::string, std::string > options;

  while ( 1 )
  {
    option_index = 0;

    c = getopt_long (argc, argv, "c:f:k:s:", long_options, &option_index);

    if ( c == -1 )
      break;
    switch ( c )
    {
      case 'c':
        options.insert ( std::pair < std::string, std::string > ( "certificate", optarg ) );
        break;
      case 'f':
        options.insert ( std::pair < std::string, std::string > ( "flash", optarg ) );
        break;
      case 'k':
        options.insert ( std::pair < std::string, std::string > ( "privatekey", optarg ) );
        break;
      case 's':
        options.insert ( std::pair < std::string, std::string > ( "status", optarg ) );
        break;
      case 250:
        usage ( EXIT_SUCCESS );
        break;
      case 251:
        std::cout 
          << PROGRAM_NAME " (" PACKAGE ") " VERSION "\n"
          << "Written by " AUTHORS ".\n\n"
          << "This is free software; see the source for copying conditions.  There is NO\n"
          << "warranty; not even for MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.\n";
        exit ( EXIT_SUCCESS );
        break;
      default:
        usage (1);
    }
  }

  return options;
}

std::map < std::string, std::string > parse_status ( std::istream & stream )
{
  std::map < std::string, std::string > fields;
  std::string field;
  std::string data;

  while ( ! stream.fail () )
  {
    std::getline ( stream, field, ':' );

    if ( field == "" )
      break;

    std::getline ( stream, data, ' ' );
    std::getline ( stream, data );

    if ( data == "" )
      break;

    fields.insert ( std::pair < std::string, std::string > ( field, data ) );
  }

  return fields;
}

std::string digest ( std::istream & stream )
{
  EVP_MD_CTX ctx;
  unsigned char buf[1024];
  unsigned int s;

  EVP_DigestInit ( &ctx, EVP_sha1 () );

  while ( ! stream.fail () )
  {
    stream.read ( reinterpret_cast < char * > ( buf ), 1024 );
    EVP_DigestUpdate ( &ctx, buf, stream.gcount () );
  }

  EVP_DigestFinal ( &ctx, buf, &s );

  return std::string ( reinterpret_cast < char * > ( buf ), s );
}

std::string sign ( std::istream & stream, EVP_PKEY * key )
{
  EVP_MD_CTX ctx;
  unsigned char buf[1024];
  unsigned int s;

  EVP_DigestInit ( &ctx, EVP_sha1 () );

  while ( ! stream.fail () )
  {
    stream.read ( reinterpret_cast < char * > ( buf ), 1024 );
    EVP_DigestUpdate ( &ctx, buf, stream.gcount () );
  }

  EVP_SignFinal ( &ctx, buf, &s, key );

  return std::string ( reinterpret_cast < char * > ( buf ), s );
}

std::string date ()
{
  char buf[256];
  timeval time;
  int ret;

  gettimeofday ( &time, NULL );
  ret = strftime ( buf, 255, "%a, %_d %b %Y %H:%M:%S %z", localtime ( &time.tv_sec ) );

  return std::string ( buf, ret );
}

int main ( int argc, char ** argv )
{
  program_name = argv[0];

  std::map < std::string, std::string > options = parse_options ( argc, argv );
  
  if ( options["flash"] == "" )
  {
    std::cerr << program_name << ": need a flash file!\n";
    usage ( 1 );
  }

  if ( options["status"] == "" )
  {
    std::cerr << program_name << ": need a status file!\n";
    usage ( 1 );
  }

  if ( options["certificate"] == "" || options["privatekey"] == "" )
    std::cerr << "don't append a signature, i hope you know what you do!" << std::endl;

  std::fstream status_stream ( options["status"].c_str (), std::ios::in );

  std::map < std::string, std::string > status = parse_status ( status_stream );

  if ( status["Format"] < "1.0" || status["Format"] > "1.0" )
  {
    std::cerr << "can't recognize format of status file (" << status["Format"] << ")" << std::endl;
    return 2;
  }

  if ( status["Date"] == "" )
    status["Date"] = date ();

  if ( status["Maintainer"] == "" )
  {
    std::cerr << "you must define a maintainer!" << std::endl;
    return 2;
  }

  if ( status["Version"] == "" )
  {
    std::cerr << "you must define a version!" << std::endl;
    return 2;
  }

  std::fstream flash_stream ( options["flash"].c_str (), std::ios::in );

  status["Digest"] = "SHA1";

  {
    BIO * bio = BIO_new ( BIO_s_mem () );
    BIO * bio_base64 = BIO_new ( BIO_f_base64 () );
    BIO_push ( bio_base64, bio );
    BUF_MEM * mem_buf;
    BIO_get_mem_ptr ( bio, &mem_buf );

    std::string flash_digest = digest ( flash_stream );
    BIO_write ( bio_base64, flash_digest.data (), flash_digest.length () );
    BIO_flush ( bio_base64 );

    status["Hash-Flash"] = std::string ( mem_buf -> data, mem_buf -> length - 1 );

    BIO_free_all ( bio_base64 );
  }

  std::stringstream status_out;

  status_out
    << "Format: " << status["Format"] << "\n"
    << "Date: " << status["Date"] << "\n"
    << "Version: " << status["Version"] << "\n"
    << "Maintainer: " << status["Maintainer"] << "\n";

  if ( options["certificate"] != "" && options["privatekey"] != "" )
  {
    BIO * bio = BIO_new_file ( options["certificate"].c_str (), "r" );
    
    if ( ! bio )
      abort ();

    X509 * cert = PEM_read_bio_X509 ( bio, NULL, NULL, NULL );
    char * buf = X509_NAME_oneline ( X509_get_subject_name ( cert ), NULL, 0 );
    status_out
      << "Signer: " << std::string ( buf ) << "\n";
    free ( buf );
    BIO_free_all ( bio );
  }

  status_out
    << "Digest: " << status["Digest"] << "\n"
    << "Hash-Flash: " << status["Hash-Flash"] << "\n" << std::endl;

  if ( options["certificate"] != "" && options["privatekey"] != "" )
  {
    BIO * bio = BIO_new_file ( options["privatekey"].c_str (), "r" );
    
    if ( ! bio )
      abort ();

    EVP_PKEY * key = PEM_read_bio_PrivateKey ( bio, NULL, NULL, NULL );

    BIO * mem = BIO_new ( BIO_s_mem () );
    BIO * mem_base64 = BIO_new ( BIO_f_base64 () );
    BIO_push ( mem_base64, mem );
    BUF_MEM * mem_buf;
    BIO_get_mem_ptr ( mem, &mem_buf );

    std::string status_signature = sign ( status_out, key );
    BIO_write ( mem_base64, status_signature.data (), status_signature.length () );
    BIO_flush ( mem_base64 );

    std::cout
      << status_out.str ()
      << "-----BEGIN SIGNATURE-----\n"
      << "Digest: SHA1\n\n"
      << std::string ( mem_buf -> data, mem_buf -> length )
      << "-----END SIGNATURE-----\n";

    std::fstream cert ( options["certificate"].c_str (), std::ios::in );
    std::string buf;

    while ( ! cert.fail () )
    {
      getline ( cert, buf );
      std::cout << buf << "\n";
    }

    BIO_free_all ( mem_base64 );
    BIO_free_all ( bio );
  }
  else
    std::cout
      << status_out.str ();

  return 0;
}

