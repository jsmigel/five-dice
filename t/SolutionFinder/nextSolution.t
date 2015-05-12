#!/usr/bin/perl -w

use Test::More;

use FiveDice::SolutionFinder;

my $game = { goal => 15, dice => [ 1, 2, 3, 4, 5 ], validOperators => [qw/ + - * \/ ^ /] };

my $finder = FiveDice::SolutionFinder->new ( game => $game );

my $count = 0;
while ( my $solution = $finder->nextSolution() ) {
    $count++;
}

is ( $count, 75000, "Exhausted all 75000 possibilities" );

done_testing();