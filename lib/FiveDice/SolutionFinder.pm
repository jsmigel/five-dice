package FiveDice::SolutionFinder;
use strict; use warnings;

use Algorithm::Combinatorics qw(permutations variations_with_repetition);

sub new {
    my $class = shift;
    $class = ref $class if ref $class;

    my $self = {
        validOperators => [qw/ + - * \/ ^ /],
        @_
    };

    my @parameters = qw/ game validOperators/;

    foreach my $required ( @parameters ) {
        unless ( defined ( $self->{$required} ) ) {
            return undef;
        }
    }

    bless $self, $class;

    return $self;
}

sub nextSolution {
    my $self = shift;

    unless ( defined ( $self->{operationIterator} ) ) {
        $self->{operationIterator} = variations_with_repetition ( $self->{validOperators}, $#{$self->{game}->{dice}} );
        $self->{solutionOperators} = $self->{operationIterator}->next();
    }

    unless ( defined ( $self->{diceIterator} ) ) {
        $self->{diceIterator} = permutations ( $self->{game}->{dice} );
    }

    my $solutionDice = $self->{diceIterator}->next();

    unless ( defined ( $solutionDice ) ) {
        $self->{solutionOperators} = $self->{operationIterator}->next();
        unless ( defined ( $self->{solutionOperators} ) ) {
            return undef;
        }
        $self->{diceIterator} = permutations ( $self->{game}->{dice} );
        $solutionDice = $self->{diceIterator}->next();
    }

    return { operations => $self->{solutionOperators}, dice => $solutionDice };
}

1;