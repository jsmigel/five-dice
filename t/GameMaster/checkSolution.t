#!/usr/bin/perl -w

use Test::More;

use FiveDice::GameMaster;

my $gm = FiveDice::GameMaster->new();

my $game = { goal => 15, dice => [ 1, 2, 3, 4, 5 ] };

my @validSolutions = (
    { dice => [ 1, 2, 3, 4, 5 ], operations => [qw/ + + + + /] }
);

my $count = 0;
foreach my $solution ( @validSolutions ) {
    is ( $gm->validateSolution ( $game, $solution ), 1, sprintf ( "Validate solution %d", ++$count ) );
    is ( $gm->{error}, undef, "No errors" );
}

my @invalidSolutions = (
    { dice => [ 1, 2, 3, 4 ], operations => [qw/ + + + + /] },
    { dice => [ 1, 2, 3, 4, 5 ], operations => [qw/ + + + /] },
    { dice => [ 1, 2, 3, 4, 5 ], operations => [qw/ + + + k /] },
    { dice => [ 1, 2, 3, 4, 5 ], operations => [qw/ + + + - /] },
    { dice => [ 2, 2, 3, 4, 4 ], operations => [qw/ + + + + /] }
);

$count = 0;
foreach my $solution ( @invalidSolutions ) {
    is ( $gm->validateSolution ( $game, $solution ), 0, sprintf ( "Validate solution %d (expected failure)", ++$count ) );
    isnt ( $gm->{error}, undef, "Expected errors" );
}

done_testing();
