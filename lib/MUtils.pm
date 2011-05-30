
package MUtils;

BEGIN {
    use Exporter;
    @ISA    = qw( Exporter );
    @EXPORT = qw(
      &clean_file_name
      &move_if_larger
    );

}

use Carp qw(cluck confess);
use strict;

sub clean_file_name {
    my $file = shift or die "wrong args";

    #-- split on the artist/track delimeter
    my (@bits) = split / - /, $file;

    my $song = pop @bits;
    my $artist = join '-', @bits;    #-- repair when delimiter in artist

    #-- account for missing info
    $song = 'unknown.mp3' if $song eq '.mp3';
    $artist = 'misc' unless $artist;

    $song =~ s/^\`//;
    $song =~ s/\`$//;

    my $new_file = "$artist - $song";
    return ( $artist, $song, $new_file );

}

sub move_if_larger {

    my $source_file = shift or die "wrong args";
    my $dest_dir    = shift or die "wrong args";
    my $dest_file   = shift or die "wrong args";

    mkdir $dest_dir unless -d $dest_dir;

    my $full_dest_file = "$dest_dir/$dest_file";

    if ( -f $full_dest_file ) {

        #--
        print "**** FILE EXISTS ****\n";
        my $size      = ( stat($source_file) )[7];
        my $dest_size = ( stat($full_dest_file) )[7];

        if ( $dest_size > $size ) {
            print "**** Keeping destination file: $dest_size > $size ****\n";

            mkdir '../dupes' unless -d '../dupes';

            rename( $source_file, "../dupes/$dest_file" . time() . ".mp3" )
              or cluck("WARN: $!\n");

        }
        else {
            print "Destination file is| $full_dest_file\n";
            print
              "**** Overwriting destination file: $dest_size < $size ****\n";
            rename( $source_file, $full_dest_file )
              or cluck("WARN: $!\n");

        }

    }
    else {
        print "Destination file is| $full_dest_file\n";
        rename( $source_file, $full_dest_file )
          or cluck("WARN: $!\n");

    }

}

1;

