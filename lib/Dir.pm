package Dir;

use strict;
use warnings;

use 5.010;

use Paths::Factory;

use Carp;


sub new {
    my($class, $path, %args) = @_;
    return Paths::Factory->new($path, %args, is_file => 0);
}


sub volume {
    return $_[0]->{volume};
}

sub is_absolute {
    return $_[0]->{absolute};
}


use overload
  q[""] => sub { $_[0]->as_string },
  fallback => 1;

sub as_string {
    return $_[0]->{string} if defined $_[0]->{string};

    my $self = shift;
    my $dir = '';
    $dir .= "/" if $self->{absolute};
    return $self->{string} = $dir . join("/", @{ $self->{dirs} }) . "/";
}


sub temp {
    my $class = shift;

    require File::Temp;
    return $class->new( File::Temp::tempdir( CLEANUP => 1 ) );
}

1;
