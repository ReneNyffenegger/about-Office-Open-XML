#!/usr/bin/perl
use warnings;
use strict;
use File::Find;
use File::Spec::Functions qw(tmpdir abs2rel);

use Archive::Zip qw(:ERROR_CODES :CONSTANTS);

my $src_dir = shift;
my $suffix  = shift or die;
die unless -d $src_dir;
die unless $suffix eq 'xlsx' or $suffix eq 'docx';

my $office_file = "$src_dir.$suffix";

my $zip = new Archive::Zip;

$zip -> addTree($src_dir);
$zip -> writeToFileNamed($office_file) == AZ_OK or die "Could not write $office_file";

system("$office_file");
