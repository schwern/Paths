#!/usr/bin/perl -w

use strict;
use warnings;

use 5.010;

use lib 'inc';
use MyBuild;

my $builder = MyBuild->new(
    module_name => 'Paths',
    license     => 'perl',
    dist_author => 'Michael G Schwern <schwern@pobox.com>',
    dist_version => "v0.0.1",

    requires => {
        'perl'               => '5.10.0',
    },
    build_requires => {
        'Test::More'         => '0.88',
    },
    configure_requires => {
        "Module::Build"      => '0.36',
    },

    meta_merge => {
        resources => {
            repository  => 'http://github.com/schwern/Paths/tree/master',
            bugtracker  => 'http://github.com/schwern/Paths/issues',
        },
    },

    recursive_test_files => 1,

    create_readme       => 1,
    create_license      => 1,
);

$builder->create_build_script();
