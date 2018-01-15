# $Id: 1compile.t,v 1.2 2003/06/16 02:09:01 ian Exp $

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

    is XS::Logger::info(),  10,  "info";
    is XS::Logger::warn(),  20,  "warn";
    is XS::Logger::die(),   303, "die";
    is XS::Logger::panic(), 404, "panic";
}

done_testing;
