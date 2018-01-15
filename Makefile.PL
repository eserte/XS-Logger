#!/bin/env perl

use ExtUtils::MakeMaker;

WriteMakefile(
    'NAME'         => 'XS::Logger'                            ,
    'VERSION_FROM' => 'Logger.pm'                               ,
    'PREREQ_PM'    => { 'Test::More'      => 0 ,
	                    'Test::Exception' => 0 }              ,

     AUTHOR     => 'Nicolas R. <atoomic@cpan.org>',
    'LIBS'         => ['']                                    ,
    'DEFINE'       => ''                                      ,
    'INC'          => '-I.'
);
