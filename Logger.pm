package XS::Logger;

use strict;

require XSLoader;

our @ISA;
our $VERSION = '0.01';

XSLoader::load(__PACKAGE__);

#XSLoader::load( 'XS::Logger', $VERSION );

1;
