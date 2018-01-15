#!/bin/env perl

use strict;
use warnings;
BEGIN { require 5.014; }

use ExtUtils::MakeMaker;

WriteMakefile(
    'NAME'         => 'XS::Logger',
    'ABSTRACT'     => "Simple logger implemented in XS",
    'VERSION_FROM' => 'Logger.pm'                               ,
    'PREREQ_PM'    => { '
    					Test::More'      => 0 ,
	                    'Test::Exception' => 0
	},
    'AUTHOR'     => 'Nicolas R. <atoomic@cpan.org>',
#    'LIBS'         => ['']                                    ,
#    'DEFINE'       => ''                                      ,
    'INC'          => '-I.'
);
