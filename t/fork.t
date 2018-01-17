use strict;
use Test::More;

# make sure the module compiles
BEGIN { use_ok('XS::Logger') }

{
    my $logger = XS::Logger->new( {} );

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
