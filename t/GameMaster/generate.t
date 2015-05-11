#!/usr/bin/perl -w

use Test::More;

use FiveDice::GameMaster;

my $gm = FiveDice::GameMaster->new();

for ( my $i = 0; $i < 500; $i++ ) {
    is ( $gm-> validateGame ( $gm->generateGame() ), 1, "Game validation $i" );
    is ( $gm->{error}, undef );
}

done_testing();
