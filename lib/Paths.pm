package Paths;

use strict;
use warnings;

use 5.010;

use File;
use Dir;


=head1 NAME

Paths - Grand Unified File and Directory objects

=head1 SYNOPSIS

    use Paths;

    my $file = File->new("/path/to/some/file");
    my $dir  = Dir->new("/path/to/some/dir/");

=head1 DESCRIPTION

Paths loads the File and Dir class which encapsulates just about
everything you might want to do with a file or directory.

=cut

1;
