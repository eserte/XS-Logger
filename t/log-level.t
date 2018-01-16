use strict;
use Test::More;

# make sure the module compiles
BEGIN { use_ok('XS::Logger') }

# make sure holy() is in the current namespace
{
    no strict 'refs';

    is( XS::Logger->loggers(), 5, "log disable level" );

    is( XS::Logger->info(),  1, "info" );
    is( XS::Logger->warn(),  2, "warn" );
    is( XS::Logger->error(), 3, "error" );
    is( XS::Logger->die(),   3, "die" );
    is( XS::Logger->panic(), 4, "panic" );
    is( XS::Logger->fatal(), 4, "fatal" );
    is( XS::Logger->debug(), 0, "debug" );

    my $logger = XS::Logger->new;

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

}

done_testing;
