#!/usr/bin/perl

use strict;
use warnings;

use Paths;
use File::stat;

use Test::More;

# touch a non-existant file
{
    my $file = File->temp;
    ok unlink $file;
    ok !-e $file;

    $file->touch;
    ok -e $file;
}


# touch an existant file
# Network file systems can get out of sync, so this uses the relative times
# of the files rather than relying on time().
#
# Some filesystems don't store at the one second resolution, and you might
# hit a second boundry, so this has a delta.
{
    my $file = File->temp;
    ok -e $file;

    my $sleep_time = 5;

    my $orig_mtime = stat($file)->mtime;

    note "Sleeping for touch test";

    my $drift = time - $orig_mtime;
    sleep $sleep_time;

    $file->touch;
    my $new_mtime = stat($file)->mtime;
    cmp_ok abs($new_mtime - $orig_mtime - $sleep_time), "<=", 2
      or diag "old mtime: $orig_mtime, new_mtime: $new_mtime";
}


done_testing;
