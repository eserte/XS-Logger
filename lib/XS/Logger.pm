package XS::Logger;

use strict;
use warnings;

# ABSTRACT: a basic logger implemented in XS

use XSLoader ();

XSLoader::load(__PACKAGE__);

1;

__END__

=pod

=encoding utf8

=head1 NAME

XS::Logger - basic logger using XS

=head1 SYNOPSIS

    use XS::Logger;

    # simple mode

    $XS::Logger::PATH_FILE = "/var/log/xslogger.log"; # default file path

    XS::Logger::info( "something to log" );
    XS::Logger::warn( "something to warn" );
    XS::Logger::error( "something to warn" );

    XS::Logger::die( "something to log & die" );
    XS::Logger::panic( "something to log & panic" );
    XS::Logger::fatal( "something to log & fatal" );
    XS::Logger::debug( "something to debug" );

    # object oriented mode

    my $log = XS::Logger->new( { color => 1, path => q{/var/log/xslogger.log} } );

    $log->info(); # one empty line
    $log->info( "something to log" );
    $log->info( "a number %d", 42 );
    $log->info( "a string '%s'", "banana" );

    $log->warn( ... );
    $log->error( ... );
    $log->die( ... );
    $log->panic( ... );
    $log->fatal( ... );
    $log->debug( ... );


=head1 DESCRIPTION

XS::Logger provides a light and friendly logger for your application.

=head1 Usage


=head1 LICENSE
