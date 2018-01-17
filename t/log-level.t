use strict;
use Test::More;

# make sure the module compiles
BEGIN { use_ok('XS::Logger') }

# make sure holy() is in the current namespace
{
    no strict 'refs';

    {
        #our $XS::Logger::PATH_FILE = "/fdsfdsfsdfsd"; # // default_value

        is( XS::Logger::info(),                       1, "info" );
        is( XS::Logger::info("a simple information"), 1, "info" );
        is( XS::Logger::info( "something to eat - %s %s", "cherry", "pie" ), 1, "info" );

        is( XS::Logger::loggers(), 5, "log disable level" );

        is( XS::Logger::info(),  1, "info" );
        is( XS::Logger::warn(),  2, "warn" );
        is( XS::Logger::error(), 3, "error" );
        is( XS::Logger::die(),   3, "die" );
        is( XS::Logger::panic(), 4, "panic" );
        is( XS::Logger::fatal(), 4, "fatal" );
        is( XS::Logger::debug(), 0, "debug" );
    }

    my $logger = XS::Logger->new( { path => "/ddwdewf" } );

    is( $logger->info(),  1, "info" );
    is( $logger->warn(),  2, "warn" );
    is( $logger->error(), 3, "error" );
    is( $logger->die(),   3, "die" );
    is( $logger->panic(), 4, "panic" );
    is( $logger->fatal(), 4, "fatal" );
    is( $logger->debug(), 0, "debug" );

}

{
    my $logger = XS::Logger->new;

    is( $logger->info("one info"), 1, "info" );
    is( $logger->warn( "a warning with integer '%d'", 42 ), 2, "warn" );
    is( $logger->error("one error"),       3, "error" );
    is( $logger->die("this is a die"),     3, "die" );
    is( $logger->panic("this is a panic"), 4, "panic" );
    is( $logger->fatal("this is fatal"),   4, "fatal" );
    is( $logger->debug( "my debug message %s", "whatever" ), 0, "debug" );

    is( $logger->info( "one %d two %d three %d", 1, 2, 3 ), 1, "%d works" );
    is( $logger->info( "d %d, s %s, d %d, s %s", -42, "banana", 404, "apple" ), 1, "mix of %d and %s" );

    is( $logger->info( "decimal '%f' <-- ", 1.56789 ), 1, "%f works --- not working for now" );

    foreach my $max ( 1 .. 10 ) {
        is( $logger->debug( "$max + 1 parameters " . ( "%d, " x $max ), ( 1 .. $max ) ), 0, "should not fail with $max + 1 argument" );
    }

    foreach my $max ( 11 .. 15 ) {
        my $ok = eval { $logger->debug( "$max parameters " . ( "%d, " x $max ), 1 .. $max ); 1 } || 0;
        my $error = $@;
        is( $ok, 0, "dies with $max +1 argument" );
        like $error, qr{^Too many args to the caller};
    }

    is( $logger->info(1234), 1, "info using an integer instead of format 1234" );

}

done_testing;
__END__

1192-generally want to use the C<SvUPGRADE> macro wrapper, which checks the type
1193:before calling C<sv_upgrade>, and hence does not croak.  See also

TODO:
- optimize sprintf when no argument
- use c open / printf
- use text file
- use GV for global filename
- add colors
