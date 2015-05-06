#!/usr/bin/perl -w

use Test::More;

use FiveDice::GameMaster;

my $gm = FiveDice::GameMaster->new();

my $game = { goal => 5, dice => [ 1, 1, 1, 1, 1 ] };

my @validGames = (
    { goal => 11, dice => [ 1, 1, 1, 1, 1 ] },
    { goal => 16, dice => [ 1, 1, 1, 1, 1 ] },
    { goal => 61, dice => [ 1, 1, 1, 1, 1 ] },
    { goal => 66, dice => [ 1, 1, 1, 1, 1 ] },

    { goal => 11, dice => [ 1, 1, 1, 1, 1 ] },
    { goal => 11, dice => [ 6, 6, 6, 6, 6 ] },
);

foreach my $game ( @validGames ) {
    is ( $gm->validateGame ( $game ), 1, "Validate basic puzzle" );
    is ( $gm->{error}, undef, "No errors" );
}

my @invalidGames = (
    { goal => 1,  dice => [ 1, 1, 1, 1, 1 ] },
    { goal => 10, dice => [ 1, 1, 1, 1, 1 ] },

    { goal => 67, dice => [ 1, 1, 1, 1, 1 ] },
    { goal => 71, dice => [ 1, 1, 1, 1, 1 ] },

    { goal => 11, dice => [ 1, 1 ] },

    { goal => 71, dice => [ 1, 1, 1, 1, 7 ] },
    { goal => 71, dice => [ 1, 1, 1, 1, 0 ] },
);

foreach my $game ( @invalidGames ) {
    is ( $gm->validateGame ( $game ), 0, "Validate basic puzzle (expected failure)" );
    isnt ( $gm->{error}, undef, "Expected errors" );
}

done_testing();
