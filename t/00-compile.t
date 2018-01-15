# compile.t
#
# Ensure the module compiles.

use strict;
use Test::More;

# make sure the module compiles
BEGIN { use_ok('XS::Logger') }

# make sure holy() is in the current namespace
{
    no strict 'refs';

    is XS::Logger::helpers(), 0;

    is XS::Logger::xinfo(),  10,  "info";
    is XS::Logger::xwarn(),  20,  "warn";
    is XS::Logger::xdie(),   303, "die";
    is XS::Logger::xpanic(), 404, "panic";
}

done_testing;
