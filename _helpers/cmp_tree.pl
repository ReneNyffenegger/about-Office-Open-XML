use warnings;
use strict;

use File::Find;
use List::Compare;

my $dir_1 = shift or die;
my $dir_2 = shift or die;


my @files_1 = find_files($dir_1);
my @files_2 = find_files($dir_2);

my $cmp = new List::Compare(\@files_1, \@files_2);

my @only_in_dir_1 = $cmp->get_unique;
my @only_in_dir_2 = $cmp->get_complement;
my @common        = $cmp->get_intersection;

print_only_in($dir_1, @only_in_dir_1);
print_only_in($dir_2, @only_in_dir_2);

print "\n";
for my $file (@common) {
  print "gvim -d $dir_1\\$file $dir_2\\$file\n";
}

sub find_files { # {{{

  my $dir       = shift;
  my $files_ref = shift;

  find(sub {

      return unless -f $_;

     (my $file = $File::Find::name) =~ s/$dir//;
      push @{$files_ref}, $file;

  }, $dir);

  return @$files_ref;

} # }}}

sub print_only_in { # {{{

  my $dir         = shift;
  my @only_in_dir = @_;

  if (@only_in_dir) {
    print "\nOnly in $dir\n  ";
    print join "\n  ", @only_in_dir; 
    print "\n";
  }

} # }}}

