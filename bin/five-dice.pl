#!/usr/bin/perl -w
use strict; use warnings;

use FiveDice::GameMaster;
use FiveDice::SolutionFinder;

my $gm = FiveDice::GameMaster->new();

while ( my $line = <STDIN> ) {
    my $game;

    if ( $line =~ /^$/ ) {
        $game = $gm->generateGame();
        printf ( "[%d] %d %d %d %d %d\n", $game->{goal}, @{$game->{dice}} );
    }
    elsif ( $line =~ /^\[(\d+)\] (\d+) (\d+) (\d+) (\d+) (\d+)$/ ) {
        $game = { goal => $1, dice => [ $2, $3, $4, $5, $6 ] };
        unless ( $gm->validateGame ( $game ) ) {
            print $gm->{error} . "\n";
            next;
        }
    }
    else {
        print "Unrecognized game format\n\n";
        next;
    }

    my $solver = FiveDice::SolutionFinder->new ( game => $game );

    my $guesses = 0;
    my $solutions = 0;

    while ( my $solution = $solver->nextSolution() ) {
        if ( $solutions == 0 ) {
            $guesses++;
        }

        if ( $gm->validateSolution ( $game, $solution ) ) {
            my @solutionDice = @{$solution->{dice}};
            my @solutionOperations = @{$solution->{operations}};
            my $goal = $game->{goal};

            my @tmp = (
                $solutionDice[0],
                $solutionOperations[0],
                $solutionDice[1],
                $solutionOperations[1],
                $solutionDice[2],
                $solutionOperations[2],
                $solutionDice[3],
                $solutionOperations[3],
                $solutionDice[4],
                $goal
                 );
            printf ( "\t%d%s%d%s%d%s%d%s%d=%d\n", @tmp );
            $solutions++;
        }
    }

    printf "First solution found after %d guesses.  There are %d solutions.\n\n", $guesses, $solutions;
}