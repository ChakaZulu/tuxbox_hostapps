#!/usr/bin/perl
use strict;
use warnings;

use Getopt::Long;
use IO::File;
use Pod::Usage;

my $image;
my $operation;
my %parts = ();

GetOptions
(
  'help' => sub { pod2usage ( 1 ); },
  'image|i=s' => \$image,
  'operation|oper|o=s' => \$operation,
  'part|p=s' => \%parts,
);

my %partdef =
(
  0 => [ "ppcboot", 0, 0x20000 ],
  1 => [ "root", 0x20000, 0x6a0000 ],
  2 => [ "var", 0x6c0000, 0x100000 ],
);

sub part_read
{
  my $in = shift;
  my $file = shift;
  my $begin = shift;
  my $size = shift;

  my $out = IO::File -> new ( $file, O_CREAT | O_EXCL | O_WRONLY ) or die $!;

  my $buf;

  my $temp = $size;
  while ( $temp > 4096 )
  {
    $in -> sysread ( $buf, 4096 );
    $out -> syswrite ( $buf, 4096 );
    $temp -= 4096;
  }

  $in -> sysread ( $buf, $temp );
  $out -> syswrite ( $buf, $temp );
}

sub part_write
{
  my $out = shift;
  my $file = shift;
  my $begin = shift;
  my $size = shift;

  my $in = IO::File -> new ( $file, O_RDONLY ) or die $!;

  $in -> seek ( 0, SEEK_END ) or die $!;
  my $insize = $in -> tell () or die $!;
  $in -> seek ( 0, SEEK_SET ) or die $!;
  $out -> seek ( $begin, SEEK_SET ) or die $!;

  my $buf;

  my $temp = $insize;
  while ( $temp > 4096 )
  {
    $in -> sysread ( $buf, 4096 );
    $out -> syswrite ( $buf, 4096 );
    $temp -= 4096;
  }

  $in -> sysread ( $buf, $temp );
  $out -> syswrite ( $buf, $temp );

  if ( $insize < $size )
  {
    part_write_zero ( $out, $begin + $insize, $size - $insize );
  }
}

sub part_write_zero
{
  my $out = shift;
  my $begin = shift;
  my $size = shift;

  $out -> seek ( $begin, SEEK_SET );

  my $buf = "\0"x$size;
  $out -> syswrite ( $buf, $size );
}

if ( not defined ( $operation ) )
{
  pod2usage ( 1 );
  die "don't know what to do";
}
elsif ( $operation eq "build" )
{
  my $out = IO::File -> new ( $image, O_CREAT | O_EXCL | O_WRONLY ) or die $!;

  foreach ( sort ( keys ( %partdef ) ) )
  {
    if ( defined ( $parts { $partdef { $_ } -> [0] } ) )
    {
      part_write ( $out, $parts { $partdef { $_ } -> [0] }, $partdef { $_ } -> [1], $partdef { $_ } -> [2] );
    }
    else
    {
      part_write_zero ( $out, $partdef { $_ } -> [1], $partdef { $_ } -> [2] );
    }
  }
}
elsif ( $operation eq "replace" )
{
  my $out = IO::File -> new ( $image, O_WRONLY ) or die $!;

  foreach ( sort ( keys ( %partdef ) ) )
  {
    if ( defined ( $parts { $partdef { $_ } -> [0] } ) )
    {
      part_write ( $out, $parts { $partdef { $_ } -> [0] }, $partdef { $_ } -> [1], $partdef { $_ } -> [2] );
    }
  }
}
elsif ( $operation eq "extract" )
{
  my $in = IO::File -> new ( $image, O_RDONLY ) or die $!;

  foreach ( sort ( keys ( %partdef ) ) )
  {
    if ( defined ( $parts { $partdef { $_ } -> [0] } ) )
    {
      part_read ( $in, $parts { $partdef { $_ } -> [0] }, $partdef { $_ } -> [1], $partdef { $_ } -> [2] );
    }
  }
}
elsif ( $operation eq "print" )
{
  my ( $name, $begin, $end, $size );

  format STDOUT_TOP =
name       : begin    - end      (size)
.
  format STDOUT =
@<<<<<<<<<<: 0x^>>>>> - 0x^>>>>> (0x^>>>>>)
$name,         $begin,    $end,     $size
.

  foreach ( sort ( keys ( %partdef ) ) )
  {
    $name = $partdef { $_ } -> [0];
    $begin = sprintf ( "%06x", $partdef { $_ } -> [1] );
    $end = sprintf ( "%06x", $partdef { $_ } -> [1] + $partdef { $_ } -> [2] );
    $size = sprintf ( "%06x", $partdef { $_ } -> [2] );
    write;
  }
}
else
{
  die "don't know what to do";
}

__END__

=head1 NAME

flashmanage

=head1 SYNOPSIS

flashmanage [OPTIONS]

  -i, --image FILE      image file
  -o, --operation ARG   what to do (build, extract, replace, print)
  -p, --part NAME=FILE  partition files
      --help            brief help message

example: flashimage -i flashimage.img -o replace -p root=root.img

=cut
