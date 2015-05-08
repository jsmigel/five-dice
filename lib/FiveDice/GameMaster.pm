package FiveDice::GameMaster;
use strict; use warnings;

sub new {
    my $class = shift;
    $class = ref $class if ref $class;

    my $self = {
        diceCount => 5,
        maxDieValue => 6,
        @_
    };

    my @parameters = qw/ diceCount maxDieValue /;

    foreach my $required ( @parameters ) {
        unless ( defined ( $self->{$required} ) ) {
            $self->{logger}->error ( "Required parameter '$required' is missing" );
            return undef;
        }
    }

    bless $self, $class;

    return $self;
}

# Validate a generated game - make sure we have the correct number of dice, and sane values
sub validateGame {
    my $self = shift;

    my $game = shift;

    delete ( $self->{error} );

    if ( $#{$game->{dice}} != ( $self->{diceCount}-1 ) ) {
        $self->{error} = sprintf ( "Incorrect number of dice (found %d, expected %d)", ( $#{$game->{dice}}+1 ), $self->{diceCount} );
        return 0;
    }

    foreach my $die ( @{$game->{dice}} ) {
        if ( $die < 1 || $die > $self->{maxDieValue} ) {
            $self->{error} = sprintf ( "Invalid dice value (found %d, expected 1-%d)", ( $die ), $self->{maxDieValue} );
        }
    }

    if ( $game->{goal} % 10 < 1 || $game->{goal} % 10 > 6 ) {
        $self->{error} = sprintf ( "Invalid goal: %d", $game->{goal} );
        return 0;
    }

    if ( int ( $game->{goal} / 10 ) < 1 || int ( $game->{goal} / 10 ) > 6 ) {
        $self->{error} = sprintf ( "Invalid goal: %d", $game->{goal} );
        return 0;
    }

    return 1;
}

# Generate a puzzle
sub generateGame {
    my $self = shift;

    my $goal = int ( rand ( 6 ) ) + 1;
    $goal *= 10;
    $goal += int ( rand ( 6 ) ) + 1;

    my @dice;

    for ( my $i = 0; $i < $self->{diceCount}; $i++ ) {
        push ( @dice, int ( rand ( 6 ) ) + 1 );
    }

    return { goal => $goal, dice => \@dice };
}

# Validate a solutions.  Checks the following
#   - Same number of dice in the game and solution
#   - Same dice values in game and solution (all dice used)
#   - Corret number of operators (#dice - 1)
#   - All valid operators
#   - Solution == goal
sub validateSolution {
    my $self = shift;

    my $game = shift;
    my $solution = shift;

    delete $self->{error};

    my $goal = $game->{goal};
    my @gameDice = @{$game->{dice}};
    my @solutionDice = @{$solution->{dice}};
    my @solutionOperations = @{$solution->{operations}};

    # Validate the number of dice against the game
    unless ( @gameDice == @solutionDice ) {
        $self->{error} = sprintf ( "Incorrect number of dice (found %d, expected %d)", scalar @solutionDice, scalar @gameDice );
        return 0;
    }

    # Validate the number of operations (should be 1 less than the number of game dice)
    unless ( @solutionOperations == ( @gameDice - 1 ) ) {
        $self->{error} = sprintf ( "Incorrect number of operations (found %d, expected %d)", scalar @solutionOperations, ( @gameDice + 1 ) );
        return 0;
    }

    # Implicity 'add' the first value
    unshift ( @solutionOperations, "+" );
    my $accumulator = 0;

    # Run operation of each die
    while ( my $nextDie = shift ( @solutionDice ) ) {
        my $operation = shift ( @solutionOperations );

        # Search for this die in the original game.  If it's not found, return an error.
        # If it is found, remove it from the game.
        my $found = 0;
        for ( my $i = 0; $i <= $#gameDice; $i++ ) {
            if ( $gameDice[$i] == $nextDie ) {
                splice ( @gameDice, $i, 1 );
                $found = 1;
                last;
            }
        }

        unless ( $found ) {
            $self->{error} = sprintf ( "Could not find value %d in original game dice", $nextDie );
            return 0;
        }

        if ( $operation eq "+" ) {
            $accumulator += $nextDie;
        }
        elsif ( $operation eq "-" ) {
            $accumulator -= $nextDie;
        }
        elsif ( $operation eq "*" ) {
            $accumulator *= $nextDie;
        }
        elsif ( $operation eq "/" ) {
            $accumulator /= $nextDie;
        }
        elsif ( $operation eq "^" ) {
            $accumulator **= $nextDie;
        }
        else {
            $self->{error} = sprintf ( "Unknown operator: %s", $operation );
            return 0;
        }
    }

    # If there are any unused game dice, this is not a valid solution
    if ( @gameDice != 0 ) {
        $self->{error} = sprintf ( "%d unused game dice found", scalar @gameDice );
        return 0;
    }

    # Check the result of the operations
    if ( $accumulator == $goal ) {
        return 1;
    }

    $self->{error} = sprintf ( "Solution does not match goal (got %.2f, expected %d)", $accumulator, $goal );
    return 0;
}

1;