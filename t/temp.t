#!/usr/bin/perl

use strict;
use warnings;

use Paths;

use Test::More;


# Tempfile
{
    my $file = File->temp;

    ok -e $file,        "temp file exists";
    ok -w $file,        "  is writable";
}


# Tempdir
{
    my $dir = Dir->temp;
    ok -d $dir,         "temp dir exists";
    ok -w $dir,         "  is writable";
}


done_testing;
