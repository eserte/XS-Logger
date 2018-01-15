use strict;
use Test::More;

# make sure the module compiles
BEGIN { use_ok('XS::Logger') }

# make sure holy() is in the current namespace
{
    no strict 'refs';

    is XS::Logger::helpers(), 0;

    is( XS::Logger->info(),  1, "info" );
    is( XS::Logger->warn(),  2, "warn" );
    is( XS::Logger->error(), 3, "error" );
    is( XS::Logger->die(),   3, "die" );
    is( XS::Logger->panic(), 4, "panic" );
    is( XS::Logger->fatal(), 4, "fatal" );
    is( XS::Logger->debug(), 0, "debug" );
}

done_testing;
