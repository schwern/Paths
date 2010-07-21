package File;

use strict;
use warnings;

use 5.010;

use Carp;

sub new {
    my($class, $file, %args) = @_;

    state $type_handlers = {
        unix    => "new_from_unix",
        dos     => "new_from_dos",
        win32   => "new_from_dos",
        url     => "new_from_url",
    };

    my $type = $args{type} // 'unix';
    my $handler = $type_handlers->{$type} or
      croak "Unknown file type $type";

    return $class->$handler($file, %args);
}


sub new_from_unix {
    my($class, $path, %args) = @_;

    require File::Spec::Unix;
    my($vol, $dir, $file) = File::Spec::Unix->splitpath($path);
    my @dirs = grep { $_ ne '' } File::Spec::Unix->splitdir($dir);

    return bless {
        absolute => File::Spec::Unix->file_name_is_absolute($path),
        volume   => $vol,
        dirs     => \@dirs,
        file     => $file,
        original => $path,
    };
}


sub new_from_dos {
    my($class, $path, %args) = @_;

    require File::Spec::Win32;
    my($vol, $dir, $file) = File::Spec::Win32->splitpath($path);
    my @dirs = grep { $_ ne '' } File::Spec::Win32->splitdir($dir);

    return bless {
        absolute=> File::Spec::Win32->file_name_is_absolute($path),
        volume  => $vol,
        dirs    => \@dirs,
        file    => $file,
        original=> $path,
    };
}


sub new_from_url {
    my($class, $path, %args) = @_;

    require URI;
    my $url = URI->new($path);

    # Yep, this could be a Windows path.  Its a good first stab.
    my $obj = $class->new_from_unix($url->path);
    $obj->{original} = $path;

    return $obj;
}


sub file {
    return $_[0]->{file};
}


sub dir {
    my $self = shift;
    my $dir = '';
    $dir .= "/" if $self->{absolute};
    return $dir . join("/", @{ $self->{dirs} }) . "/";
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
    return $_[0]->{string} //= $_[0]->dir . $_[0]->file;
}


1;
