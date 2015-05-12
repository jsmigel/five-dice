#!/usr/bin/perl -w

use Test::More;

use FiveDice::GameMaster;

my $gm = FiveDice::GameMaster->new();

sub validate {
    my $game = shift;

    if ( $#{$game->{dice}} != ( $self->{diceCount}-1 ) ) {
        return 0;
    }

    foreach my $die ( @{$game->{dice}} ) {
        if ( $die < 1 || $die > $self->{maxDieValue} ) {
            return 0;
        }
    }

    if ( $game->{goal} % 10 < 1 || $game->{goal} % 10 > 6 ) {
        return 0;
    }

    if ( int ( $game->{goal} / 10 ) < 1 || int ( $game->{goal} / 10 ) > 6 ) {
        return 0;
    }

    return 1;
}

for ( my $i = 0; $i < 500; $i++ ) {
    my $game = $gm->generateGame();

    my $goal = $game->{goal};

    ok ( $goal % 10 >= 1 && $goal % 10 <= 6, "Second goal die is between 1-6" );
    ok ( int ( $game->{goal} / 10 ) >=1 && int ( $game->{goal} / 10 ) <= 6, "Most significant die is 10, 20, 30, 40, 50, or 60" );

    my $dice = $game->{dice};

    ok ( @$dice == 5, "5 dice rolled" );

    foreach my $die ( @$dice ) {
        ok ( $die >= 1 && $die <= 6, "Individual die values are between 1-6" );
    }

    is_deeply ( $game->{validOperators}, [qw/ + - * \/ ^ /] );
}

done_testing();
