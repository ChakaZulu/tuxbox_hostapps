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
 * $Id: flashsign.cpp,v 1.3 2002/05/28 18:56:09 waldi Exp $
 */

#ifdef HAVE_CONFIG_H
#include <config.h>
#endif

#include <fstream>
#include <iostream>
#include <map>
#include <sstream>
#include <stdexcept>
#include <string>

#include <getopt.h>

#include <libcrypto++/rand.hpp>

#include <libflashimage/flashimage.hpp>
#include <libflashimage/flashimagecramfs.hpp>

#define PROGRAM_NAME "flashsign"

#define AUTHORS "Bastian Blank"

const char * program_name;

static struct option long_options [] =
{
  { "image", required_argument, 0, 'i' },
  { "privatekey", required_argument, 0, 'k' },
  { "size", required_argument, 0, 's' },
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
      << "  -i, --image=FILE            image file\n"
      << "  -k, --privatekey=FILE       private key for sign\n"
      << "  -s, --size=SIZE             size of output file in kb\n"
      << "      --help                  display this help and exit\n"
      << "      --version               output version information and exit\n";

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

    c = getopt_long (argc, argv, "i:k:o:s:", long_options, &option_index);

    if ( c == -1 )
      break;
    switch ( c )
    {
      case 'i':
        options.insert ( std::pair < std::string, std::string > ( "image", optarg ) );
        break;
      case 'k':
        options.insert ( std::pair < std::string, std::string > ( "privatekey", optarg ) );
        break;
      case 's':
        options.insert ( std::pair < std::string, std::string > ( "size", optarg ) );
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

int main ( int argc, char ** argv )
{
  program_name = argv[0];

  std::map < std::string, std::string > options = parse_options ( argc, argv );
  
  if ( options["image"] == "" )
  {
    std::cerr << program_name << ": need a image file!\n";
    usage ( 1 );
  }

  if ( options["size"] == "" )
  {
    std::cerr << program_name << ": need a size for output image file!\n";
    usage ( 1 );
  }

  if ( options["privatekey"] == "" )
  {
    std::cerr << program_name << ": need a privatekey file!\n";
    usage ( 1 );
  }

  Crypto::rand::load_file ( "/dev/urandom", 128 );

  std::fstream image_in ( options["image"].c_str (), std::ios::in | std::ios::out );
  char * buf = NULL;

  try
  {
    image_in.seekg ( 0, std::ios::end );
    int size = image_in.tellg ();
    int endsize = atoi ( options["size"].c_str () ) * 1024;
    int padsize = endsize - size;

    if ( size % 4096 )
      throw std::runtime_error ( "image not alligned" );

    if ( endsize % 4096 )
      throw std::runtime_error ( "size not alligned" );

    if ( size - 4096 > endsize )
      throw std::runtime_error ( "image too large" );

    buf = new char[4096];
    memset ( buf, 0, 4096 );

    int pad = padsize / 4096;

    image_in.seekp ( 0, std::ios::end );
    while ( pad )
    {
      image_in.write ( buf, 4096 );
      pad--;
    }

    FlashImage::FlashImageCramFS fs ( image_in );
    FlashImage::FlashImage image ( fs );

    std::ifstream privatekey_in ( options["privatekey"].c_str (), std::ios::in );
    Crypto::evp::key::privatekey key;
    key.read ( privatekey_in );

    if ( image.get_control_field ( "Digest" ) == "MD5" )
      fs.sign ( key, Crypto::evp::md::md5 () );
    else if ( image.get_control_field ( "Digest" ) == "SHA1" )
      fs.sign ( key, Crypto::evp::md::sha1 () );
    else if ( image.get_control_field ( "Digest" ) == "RIPEMD160" )
      fs.sign ( key, Crypto::evp::md::ripemd160 () );
  }

  catch ( std::runtime_error & except )
  {
    std::cout << "exception: " << except.what () << std::endl;
  }

  image_in.close ();
  delete buf;

  return 0;
}

