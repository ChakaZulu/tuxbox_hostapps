/*
 * flashcheck.cpp
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
 * $Id: flashcheck.cpp,v 1.1 2002/05/29 14:12:39 waldi Exp $
 */

#ifdef HAVE_CONFIG_H
#include <config.h>
#endif

#include <fstream>
#include <iostream>
#include <stdexcept>
#include <string>

#include <getopt.h>

#include <libflashimage/flashimage.hpp>
#include <libflashimage/flashimagecramfs.hpp>

#define PROGRAM_NAME "flashcheck"

#define AUTHORS "Bastian Blank"

const char * program_name;

static struct option long_options [] =
{
  { "image", required_argument, 0, 'i' },
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
      << "Usage: " << program_name << " [OPTION]... FILE\n\n"
      << "Check a signed flash image\n\n"
      << "      --help                  display this help and exit\n"
      << "      --version               output version information and exit\n";

  exit ( status );
}

int main ( int argc, char ** argv )
{
  program_name = argv[0];

  {
    char c;
    int option_index;
    std::map < std::string, std::string > options;

    while ( 1 )
    {
      option_index = 0;

      c = getopt_long (argc, argv, "", long_options, &option_index);

      if ( c == -1 )
        break;
      switch ( c )
      {
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
  }

  if ( argc == 1 )
  {
    std::cerr << program_name << ": need a image file!\n";
    usage ( 1 );
  }

  std::fstream image_in ( argv[1], std::ios::in );

  try
  {
    image_in.seekg ( 0, std::ios::end );
    int size = image_in.tellg ();

    if ( size % 4096 )
      throw std::runtime_error ( "image not alligned" );

    FlashImage::FlashImageCramFS fs ( image_in );
    FlashImage::FlashImage image ( fs );

    fs.file ( "control", std::cout );

    if ( image.verify_image () )
      std::cout << "image verification successfull" << std::endl;
    else
      std::cout << "image verification failed" << std::endl;
  }

  catch ( std::runtime_error & except )
  {
    std::cout << "exception: " << except.what () << std::endl;
  }

  image_in.close ();

  return 0;
}

