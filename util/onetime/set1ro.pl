#!/usr/bin/perl

=head1 Name

set1ro.pl

=head1 Description

Cleans up mp3 track and artist names moving them to a new area.
Handles duplicates in target area by choosing the largest file
and moving duplicates to a different folder.

Ignores files in the 'incomplete' folder.
Substitutes 'unknown' for missing artist or track info.
Repairs the annoying case where a dash is part of the artist name and it gets chopped of and pre-pended to the track name.
Identifies and preserves cases where the song or folder name begins with a track #.

=cut

use File::Find;
use Getopt::Long;
use strict;

my $tioat = 0;    #-- this is only a test

GetOptions( 't' => \$tioat );

find(
	sub {

		my $path = $File::Find::dir;
		my $file = $_;

		my $track_no;

		#-- skip undesirables
		return if $file eq '.';
		return if $file eq '..';
		return if $file eq 'incomplete';
		return if $path eq './incomplete';

		#-- Check if track # is part of the name
		( $file, $track_no ) = process_track_number($file);

		#-- split on the artist/track delimeter
		my (@bits) = split / - /, $file;

		my $song = pop @bits;
		my $artist = join '-', @bits;    #-- repair when delimiter in artist

		#-- account for missing info
		$song = 'unknown.mp3' if $song eq '.mp3';
		$artist = 'unknown' unless $artist;

		print "Found '$song'\tby\t'$artist'\n";

		# $song =~ s/(\W)/\\$1/g;
		# $artist =~ s/(\W)/\\$1/g;
		# $file =~ s/(\W)/\\$1/g;

		my $new_dir  = "../reorg/$artist";
		my $new_file = "$track_no $artist - $song";  #-- .mp3 is still tacked on

		if ($tioat) {
			print "---- This is only a test ----\n";
			return;
		}

		mkdir $new_dir unless -d $new_dir;

		my $dest_file = "$new_dir/$new_file";

		print "Writing to : $dest_file\n";

		my $rc;

		if ( -f $dest_file ) {

			#--
			print "**** FILE EXISTS ****\n";
			my $size      = ( stat($file) )[7];
			my $dest_size = ( stat($dest_file) )[7];

			if ( $dest_size > $size ) {
				print
				  "**** Keeping destination file: $dest_size > $size ****\n";
				$rc = rename( $file, "../dupes/$file" . time() . ".mp3" );
				warn "WARN: $!\n" unless $rc;

			}
			else {
				print
"**** Overwriting destination file: $dest_size < $size ****\n";
				$rc = rename( $file, $dest_file );
				warn "WARN: $!\n" unless $rc;

			}

		}
		else {
			$rc = rename( $file, $dest_file );
			warn "WARN: $!\n" unless $rc;
		}

	},
	'.'
);

sub process_track_number {
	my $original_name = shift or die;
	my $num;
	my $name = $original_name;

	if ( $name =~ s/^\d\d\d\.// ) {

		#-- prob a playlist #
		return ( $name, '' );
	}

	if ( $num < 60 ) {
		return ( $name, $num );
	}
	elsif ( $name =~ /^(\d\d)/ ) {
		$num = $1;

	} else {                            #- probably a playlist #
		return ( $name, '' );

	}

}

