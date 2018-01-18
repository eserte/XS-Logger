#!/bin/env perl

use strict;
use warnings;

use Test2::Bundle::Extended;
use Test2::Tools::Explain;
use Test2::Plugin::NoWarnings;

use XS::Logger;

{
    my $logger = XS::Logger->new();

    $logger->info("1.before fork...");
    if ( my $pid = fork() ) {
        waitpid( $pid, 0 );
        ok $logger->info("3. back to parent");
    }
    else {
        $logger->info("2. from kid");
        exit;
    }
}

done_testing;
