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

sub validate {
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

1;