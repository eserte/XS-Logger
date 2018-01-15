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
        my $logger = XS::Logger->new( 1, 2 );
        isa_ok $logger, 'XS::Logger';

        #is $logger->get_x(), 1, "get_x";

        undef $logger;    # trigger destroy
        is $logger, undef;
        $logger = XS::Logger->new( 4, 5 );
        isa_ok $logger, 'XS::Logger';

        #is $logger->get_x(), 4, "get_x";
    }

}

done_testing;
__END__

SV*
xlog_get_x(self)
    SV* self
PREINIT:
	MyLogger* mylogger;
CODE:
{
	mylogger = INT2PTR(MyLogger*, SvIV(SvRV(self)));
	RETVAL = newSViv( mylogger->x );
}
OUTPUT:
	RETVAL
