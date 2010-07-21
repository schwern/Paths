package Paths::Factory;

use strict;
use warnings;

use 5.010;

use Carp;


sub new {
    my($class, $path, %args) = @_;

    state $type_handlers = {
        unix    => "new_from_unix",
        dos     => "new_from_dos",
        win32   => "new_from_dos",
        url     => "new_from_url",
    };

    my $type = $args{type} // 'unix';
    my $handler = $type_handlers->{$type} or
      croak "Unknown file type $type";

    return $class->$handler($path, %args);
}


sub new_from_unix {
    my($class, $path, %args) = @_;

    require File::Spec::Unix;
    my($vol, $dirs, $file) = File::Spec::Unix->splitpath($path, !$args{is_file});
    my @dirs = grep { $_ ne '' } File::Spec::Unix->splitdir($dirs);

    my $dir_obj = bless {
        absolute => File::Spec::Unix->file_name_is_absolute($path),
        volume   => $vol,
        dirs     => \@dirs,
    }, "Dir";

    if( $args{is_file} ) {
        return bless {
            file        => $file,
            dir         => $dir_obj
        }, "File";
    }
    else {
        return $dir_obj;
    }
}


sub new_from_dos {
    my($class, $path, %args) = @_;

    require File::Spec::Win32;
    my($vol, $dirs, $file) = File::Spec::Win32->splitpath($path, !$args{is_file});
    my @dirs = grep { $_ ne '' } File::Spec::Win32->splitdir($dirs);

    my $dir_obj = bless {
        absolute => File::Spec::Win32->file_name_is_absolute($path),
        volume   => $vol,
        dirs     => \@dirs,
    }, "Dir";

    if( $args{is_file} ) {
        return bless {
            file        => $file,
            dir         => $dir_obj
        }, "File";
    }
    else {
        return $dir_obj;
    }
}


sub new_from_url {
    my($class, $path, %args) = @_;

    require URI;
    my $url = URI->new($path);

    # Yep, this could be a Windows path.  Its a good first stab.
    my $obj = $class->new_from_unix($url->path, %args);
    $obj->{original} = $path;

    return $obj;
}

1;
