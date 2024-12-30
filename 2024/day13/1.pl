#!/usr/bin/env perl
use strict;
use warnings;

if ( @ARGV != 1 ) {
        print("./1.pl [filename]\nERROR: incorrect argument count\n");
        exit 1;
}

open( FH, '<', $ARGV[0] )
  or ( print("./1.pl [filename]\nERROR: incorrect filename\n"), exit 2 );

my @input = ();
my @temp  = ();
while (<FH>) {
        if ( $_ eq "\n" ) {
                push( @input, [@temp] );
                @temp = ();
        }
        else {
                my @shit = $_ =~ (/(\d.*), Y[+=](\d.*)/);
                push( @temp, \@shit );
        }
}
push( @input, [@temp] );

# https://stackoverflow.com/a/22281682
sub gcd {
        if ( $_[1] == 0 ) {
                return $_[0];
        }
        else {
                return gcd( $_[1], $_[0] % $_[1] );
        }
}

my $total = 0;
for my $i ( 0 .. @input - 1 ) {

        # print("i: $i\n");
        my $gcdx = gcd( $input[$i][0][0], $input[$i][1][0] );
        my $gcdy = gcd( $input[$i][0][1], $input[$i][1][1] );
        if (
                !(
                           ( $input[$i][2][0] % $gcdx == 0 )
                        && ( $input[$i][2][1] % $gcdy == 0 )
                )
          )
        {
                # print("impossible!\n");
                next;
        }

        my $min = 0;
        for my $j ( 1 .. 200 ) {
                for my $k ( 0 .. $j ) {
                        my $acoins = $j - $k;
                        my $bcoins = $k;
                        if (
                                (
                                        ( $input[$i][0][0] * $acoins ) +
                                        ( $input[$i][1][0] * $bcoins ) ==
                                        $input[$i][2][0]
                                )
                                && ( ( $input[$i][0][1] * $acoins ) +
                                        ( $input[$i][1][1] * $bcoins ) ==
                                        $input[$i][2][1] )
                          )
                        {
                                my $solution = ( $acoins * 3 ) + $bcoins;
                                if (       $min == 0
                                        || $solution < $min )
                                {
                                        $min = $solution;
                                }

                                # print(
                                #         "possible: a $acoins(",
                                #         $acoins * 3,
                                #         "), b $bcoins\n"
                                # );
                        }
                }
        }
        $total += $min;
}

print("$total\n");

close(FH);
