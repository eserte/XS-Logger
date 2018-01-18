#!/bin/env perl

use strict;
use warnings;

use Test2::Bundle::Extended;
use Test2::Tools::Explain;
use Test2::Plugin::NoWarnings;

use Capture::Tiny ':all';
use File::Slurp qw{read_file};

use File::Temp;

use XS::Logger ();

use FindBin;
use lib "$FindBin::Bin/lib";

use Test::XSLogger qw{:all};

my $log = XS::Logger->new();
is $log->get_level, 0, "default level is 0";

$log = XS::Logger->new( { level => 1 } );
is $log->get_level, 1, "can set the log level to a custom value";

is XS::Logger::DEBUG_LOG_LEVEL(), 0, "debug level is 0";
is XS::Logger::INFO_LOG_LEVEL(),  1, "info level is 1";
is XS::Logger::WARN_LOG_LEVEL(),  2, "warn level is 2";
is XS::Logger::ERROR_LOG_LEVEL(), 3, "error level is 3";
is XS::Logger::FATAL_LOG_LEVEL(), 4, "fatal level is 4";

done_testing;
