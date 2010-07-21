#!/usr/bin/perl

use strict;
use warnings;

use Paths;

use Test::More;


# Basic write, read and append
{
    my $file = File->temp;
    ok -w $file;
    ok my $fh = $file->openw, "openw";
    say $fh "Testing 123";
    close $fh;

    ok $fh = $file->openr, "openr";
    is join("", <$fh>), "Testing 123\n";

    ok $fh = $file->opena, "opena";
    say $fh "And more!";

    ok $fh = $file->open, "open default";
    is join("", <$fh>), "Testing 123\nAnd more!\n";
}    


# Try to open a file that doesn't exist for reading
{
    my $file = File->new("/i/do/not/exist");
    ok !-e $file;
    ok !eval { $file->openr };
    like $@, qr/^Could not open $file for reading: /;
}


done_testing;
