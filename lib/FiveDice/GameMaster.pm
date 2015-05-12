package FiveDice::GameMaster;
use strict; use warnings;

sub new {
    my $class = shift;
    $class = ref $class if ref $class;

    my $self = {
        @_
    };

    my @parameters = qw/ /;

    foreach my $required ( @parameters ) {
        unless ( defined ( $self->{$required} ) ) {
            return undef;
        }
    }

    bless $self, $class;

    return $self;
}

# Generate a puzzle
sub generateGame {
    my $self = shift;

    my $goal = int ( rand ( 6 ) ) + 1;
    $goal *= 10;
    $goal += int ( rand ( 6 ) ) + 1;

    my @dice;

    for ( my $i = 0; $i < 5; $i++ ) {
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

    return 0;
}

1;