# $Id: 1compile.t,v 1.2 2003/06/16 02:09:01 ian Exp $

# compile.t
#
# Ensure the module compiles.

use strict;
use Test::More;

use XS::Logger;

# make sure holy() is in the current namespace
{
    no strict 'refs';

    ok 1;

    {
        my $logger = XS::Logger->new( { x => 1, y => 2 } );
        isa_ok $logger, 'XS::Logger';
        is $logger->get_x(), 1, "get_x";
        is $logger->get_y(), 2, "get_y";

        undef $logger;    # trigger destroy
        is $logger, undef;
        $logger = XS::Logger->new( { x => 4 } );
        isa_ok $logger, 'XS::Logger';
        is $logger->get_x(), 4, "get_x";
        is $logger->get_y(), 0, "get_y";

        $logger = XS::Logger->new( { y => 42 } );
        isa_ok $logger, 'XS::Logger';
        is $logger->get_x(), 0,  "get_x";
        is $logger->get_y(), 42, "get_y";

        $logger = XS::Logger->new();
        isa_ok $logger, 'XS::Logger';
        is $logger->get_x(), 0, "get_x";
        is $logger->get_y(), 0, "get_y";

    }

}

done_testing;
__END__


             if(hv_exists(seen, SvPVX(keysv), SvCUR(keysv)))
                 continue;

             hv_store(seen, SvPVX(keysv), SvCUR(keysv), &PL_sv_undef, 0);

90:                s = hv_fetchs((HV *) SvRV(hv), "hv_fetchs", 0);
