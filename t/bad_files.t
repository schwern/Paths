#!/usr/bin/perl

use strict;
use warnings;

use 5.010;

use File;

use Test::More;

# Try some bad files
{
    my @Bad_Files = (
        "/path/to/a/dir/",
        "/",
        ".",
        "",
        "./foo/.",
        "..",
        "foo/..",
    );

    for my $file (@Bad_Files) {
        ok !eval { File->new($file); 1 }, "bad file: $file";
        like $@, qr/^'\Q$file\E' does not contain a file /;
    }
}


# What about undef?
{
    ok !eval { File->new( undef ); 1 };
    like $@, qr/^File is undefined /;
}


done_testing;
