#!/usr/bin/perl -w
use strict; use warnings;

use FiveDice::GameMaster;
use FiveDice::SolutionFinder;
use FiveDice::Formatter;

my $gm = FiveDice::GameMaster->new();

my $formatter = FiveDice::Formatter->new();

while ( my $line = <STDIN> ) {
    my $game;

    if ( $line =~ /^$/ ) {
        $game = $gm->generateGame();
        print $formatter->formatGame ( $game ) . "\n";
    }
    elsif ( $line =~ /^\[(\d+)\] (\d+) (\d+) (\d+) (\d+) (\d+)$/ ) {
        $game = { goal => $1, dice => [ $2, $3, $4, $5, $6 ] };
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
            print "\t" . $formatter->formatSolution ( $solution ) . "\n";
            $solutions++;
        }
    }

    printf "First solution found after %d guesses.  There are %d solutions.\n\n", $guesses, $solutions;
}