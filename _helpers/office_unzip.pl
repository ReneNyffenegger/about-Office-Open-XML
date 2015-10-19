use warnings;
use strict;


use Archive::Extract;
use File::Copy;
use File::Basename;
use File::Find;
use XML::Tidy;

use open ':encoding(utf8)';
my $office_file = shift;
my $dest_dir    = shift;

my $file_base   = basename($office_file) . ".zip";

copy($office_file, $file_base);

die "$office_file not found" unless -f $office_file;
die "$dest_dir already exists"   if -e $dest_dir;

my $archive = new Archive::Extract(archive => $file_base);
$archive->extract (to => $dest_dir) or die "Could not extract $office_file to $dest_dir!";


find(sub {

  my $file = $_;
  return unless -f $file;

  my $xml_tidy = new XML::Tidy (filename => $file);
  $xml_tidy -> tidy();
  $xml_tidy -> write();

# XML Tidy doesn't seem to write in utf8...
#

  my $enc = 'latin1';
  open my $IN,  "<:encoding($enc)", $file        or die $!;
  open my $OUT, '>:utf8',          "$file.utf8"  or die $!;
  print $OUT $_ while <$IN>;
  close $OUT;

   unlink $file;
   move "$file.utf8", $file;

}, $dest_dir);

unlink $file_base;
