package MUtils::File::Repair;

use Moose;

has file_list => (
 traits => ['Array'],
 is => 'rw',
 isa => 'ArrayRef[Str]',
 default => sub { [] },
 handles => {
  file_list_all => 'elements',
  file_list_add => 'push',
 }
);

has dupe_regexp => (
 traits => ['Array'],
 is => 'rw',
 isa => 'ArrayRef[Str]',
 default => sub { 
  my @p = (
   '\s*\(\s*\d+\s*\)\s*' 
  )
  
  my @r = map { qr/$_/ };

  return \@r;
    
  },
 handles => {
  dupe_regexp_all => 'elements',
  dupe_regexp_add => 'push',
 }
);

sub dupes_by_file_name {
 my $s = shift;

 foreach my $file_name ( $s->file_list_all ) {
  
 }

}

no Moose;
1;

