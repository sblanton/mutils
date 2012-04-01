#!/usr/bin/perl

use MUtils;
use File::Find;
use Getopt::Long;

my $tioat = 0;  #-- this is only a test

GetOptions( 't' => \$tioat );

find( sub{

 my $path = $File::Find::dir;
 my $file = $_;

 return unless -f $_;

 #-- skip undesirables
 return if $file eq '.';
 return if $file eq '..';
 return if $file eq 'incomplete';
 return if $path eq './incomplete';


 my ($artist, $song, $new_file) = clean_file_name($file);
 my $new_root_dir = '../../reorg';
 next unless -d $new_root_dir;

 my $new_dir = "$new_root_dir/$artist";

 if ( $tioat ) {
  print "---- This is only a test ----\n";
  return;
 }

 mkdir $new_dir unless -d $new_dir;

 move_if_larger($file, $new_dir, $new_file);


 }, '.');
