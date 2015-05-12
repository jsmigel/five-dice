#!/usr/bin/perl -w
use strict; use warnings;

use Test::More;

use FiveDice::Formatter;

my $formatter = FiveDice::Formatter->new();

my $solution = { dice => [ 5, 3, 2, 1, 6, 4, 1 ], operations => [qw/ * + + - ^ - /]};

is ( $formatter->formatSolution ( $solution ), "5*3+2+1-6^4-1" );

is_deeply ( $solution, { dice => [ 5, 3, 2, 1, 6, 4, 1 ], operations => [qw/ * + + - ^ - /]} );

$solution = { dice => [ 2, 3, [ 4, [ 7, 9 ], 6 ], 1 ], operations =>[qw/ + - ^ \/ + * / ]};

is ( $formatter->formatSolution ( $solution ), "2+3-(4^(7/9)+6)*1" );

is_deeply ( $solution, { dice => [ 2, 3, [ 4, [ 7, 9 ], 6 ], 1 ], operations =>[qw/ + - ^ \/ + * / ]} );

done_testing();