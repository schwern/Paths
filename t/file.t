#!/usr/bin/perl

use strict;
use warnings;

use Paths;

use Test::More;

# Simple file
{
    my $file = File->new("/path/to/some/file");
    isa_ok $file, "File";
    is $file->file, "file";
    is $file->dir, "/path/to/some/";
    isa_ok $file->dir, "Dir";
    ok $file->is_absolute;
    ok !$file->volume;
    is $file, "/path/to/some/file";
}


# Windows file
{
    my $file = File->new('C:\\path\\to\\some\\file', type => "dos");
    is $file->file, "file";
    is $file->dir, "/path/to/some/";
    ok $file->is_absolute;
    is $file->volume, "C:";
    is $file, "/path/to/some/file";
}


# URL
{
    my $file = File->new('file:///path/to/some/file', type => "url");
    is $file->file, "file";
    is $file->dir, "/path/to/some/";
    ok $file->is_absolute;
    ok !$file->volume;
    is $file, "/path/to/some/file";    
}


done_testing;
