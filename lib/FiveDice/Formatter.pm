package FiveDice::Formatter;
use strict; use warnings;

sub new {
    my $class = shift;
    $class = ref $class if ref $class;

    my $self = {
        @_
    };

    my @parameters = qw/  /;

    foreach my $required ( @parameters ) {
        unless ( defined ( $self->{$required} ) ) {
            return undef;
        }
    }

    bless $self, $class;

    return $self;
}

sub formatGame {
    my $self = shift;
    my $game = shift;

    return sprintf ( "[%d] %s", $game->{goal}, join ( " ", @{$game->{dice}} ) );
}

# This is a recursive sub
# Operations are applied to dice as they are read
# off the arrays in lock-step.
#
# Operators are treated as a FIFO and removed.
#
# If a value is read from the 'dice' array, and that
# value is an array, then open a parenthesis, and recurse,
# using the same stack of operators.
sub formatSolution {
    my $self = shift;
    my $solution = shift;
    my $operationCounter = shift;

    unless ( defined ( $operationCounter ) ) {
        $$operationCounter = 0;
    }

    my $dice = $solution->{dice};
    my $operations = $solution->{operations};

    my $retval;

    my $first = 1;

    foreach my $die ( @$dice ) {
        unless ( $first ) {
            if ( $$operationCounter <= $#$operations ) {
                $retval .= ${$operations}[$$operationCounter++];
            }
            else {
                $retval .= "???";
            }
        }
        if ( ref $die eq "ARRAY" ) {
            $retval .= "(";
            $retval .= $self->formatSolution ( { dice => $die, operations => $solution->{operations} }, $operationCounter );
            $retval .= ")";
        }
        else {
            $retval .= $die;
        }
        $first = 0;
    }

    return $retval;
}

1;