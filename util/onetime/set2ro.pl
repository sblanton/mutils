#!/usr/bin/perl

use MUtils;

my $rc = opendir($fh_set_dir,'.');
my @artist_dirs = readdir($fh_set_dir);
closedir $fh_set_dir;

@artist_dirs = grep !/^(\.|\.\.)$/, @artist_dirs;
  
foreach my $artist_dir ( @artist_dirs ) {

 next unless -d $artist_dir;

 print "Processing |$artist_dir|...\n";

 chdir $artist_dir or warn "***** COULDN'T CHDIR TO $artist_dir : $!";

 {
  my $fh_artist_dir;

  opendir( $fh_artist_dir, '.');
  my @radio_dirs = readdir($fh_artist_dir);
  closedir $fh_artist_dir;

  @radio_dirs = grep !/^(\.|\.\.)$/, @radio_dirs;

  foreach my $radio_dir ( @radio_dirs ) {
   next unless -d $radio_dir;

   print "-----> Processing |$radio_dir|...\n";
   chdir $radio_dir or warn "*****\t***** COULDN'T CHDIR TO $radio_dir : $!";
   {
    opendir($fh_files, '.');
    my @files = readdir($fh_files);
    closedir $fh_files;

    @files = grep !/^(\.|\.\.)$/, @files;

    foreach my $file (@files){
     move_if_larger($file, '..', $file);
    }

   }
   chdir '..';

   rmdir $radio_dir or warn "*****\t***** COULDN'T RMDIR FOR $radio_dir : $!";
  }

 }

 chdir '..';

}
