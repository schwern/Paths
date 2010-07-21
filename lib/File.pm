package File;

use strict;
use warnings;

use 5.010;

use Paths::Factory;
use Carp;

sub new {
    my($class, $path, %args) = @_;

    croak "File is undefined" if !defined $path;

    my $file = Paths::Factory->new($path, %args, is_file => 1);

    my $raw_file = $file->{file};
    croak "'$path' does not contain a file"
      if !defined $file or !ref $file or
         !defined $raw_file or !length $raw_file or $raw_file eq '..' or $raw_file eq '.';

    return $file;
}


sub file {
    return $_[0]->{file};
}


sub dir {
    return $_[0]->{dir};
}


sub volume {
    return $_[0]->{dir}->volume;
}


sub is_absolute {
    return $_[0]->{dir}->is_absolute;
}


use overload
  q[""] => sub { $_[0]->as_string },
  fallback => 1;

sub as_string {
    return $_[0]->{string} //= $_[0]->dir . $_[0]->{file};
}


sub temp {
    my $class = shift;

    require File::Temp;
    my($fh, $file) = File::Temp::tempfile( UNLINK => 1 );
    return $class->new($file);
}


sub open {
    my($self, $mode) = @_;

    $mode //= '<';

    state $mode_names = {
        "<"     => "reading",
        ">"     => "writing",
        ">>"    => "appending",
        "+<"    => "read/write",
        "+>"    => "write/read",
    };

    my $fh;
    unless( open $fh, $mode, $_[0]) {
        my $mode_name = $mode_names->{$mode} || $mode;
        croak "Could not open $_[0] for $mode_name: $!";
    }

    return $fh;
}

sub openw {
    return $_[0]->open(">");
}

sub openr {
    return $_[0]->open("<");
}

sub opena {
    return $_[0]->open(">>");
}


sub touch {
    my $file = shift;

    my $time = time;
    $file->opena;
    utime($time, $time, $file) or croak "Could not set time on $file: $!";

    return 1;
}

1;
