#!/usr/bin/perl -w
use strict; use warnings;

use Test::More;

use FiveDice::Formatter;

my $formatter = FiveDice::Formatter->new();

is ( $formatter->formatGame ( { goal => 23, dice => [ 1, 2, 3 ] } ), "[23] 1 2 3", "Check game format" );

done_testing();
