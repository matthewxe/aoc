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
        my $A = $_[0];
        my $B = $_[1];
        my $X = $_[2];
        my $Y = $_[3];
        if ( $B == 0 ) {
                return $A;
        }
        else {
                return gcd( $B, $A % $B );
        }
}

#  https://cp-algorithms.com/algebra/extended-euclid-algorithm.html
sub extended_gcd {
        my $A = $_[0];
        my $B = $_[1];
        my $X = $_[2];
        my $Y = $_[3];
        if ( $B == 0 ) {
                $$X = 1;
                $$Y = 0;
                return $A;
        }
        my $x1 = undef;
        my $y1 = undef;
        my $D  = extended_gcd( $B, $A % $B, \$x1, \$y1 );
        $$X = $y1;
        $$Y = $x1 - $y1 * int( $A / $B );
        return $D;
}

sub shift_solutinon {
        my $X   = $_[0];
        my $Y   = $_[1];
        my $A   = $_[2];
        my $B   = $_[3];
        my $CNT = $_[4];
        $$X += $CNT * $B;
        $$Y -= $CNT * $A;
}

my $total = 0;
for my $i ( 0 .. @input - 1 ) {

        $input[$i][2][0] += 10000000000000;
        $input[$i][2][1] += 10000000000000;

        my $xx = undef;
        my $xy = undef;
        my $yx = undef;
        my $yy = undef;
        my $gcdx =
          extended_gcd( $input[$i][0][0], $input[$i][1][0], \$xx, \$xy );
        my $gcdy =
          extended_gcd( $input[$i][0][1], $input[$i][1][1], \$yx, \$yy );

        if (
                !(
                           ( $input[$i][2][0] % $gcdx == 0 )
                        && ( $input[$i][2][1] % $gcdy == 0 )
                )
          )
        {
                print("impossible!\n");
                next;
        }

        print(
"xx: $xx xy: $xy cx: $input[$i][2][0]\nyx: $yx, yy: $yy, cy: $input[$i][2][1]\n\n"
        );

        my $A = $input[$i][0][0];
        my $B = $input[$i][1][0];
        my $C = $input[$i][2][0];

        my $K = 10000000000;

        #my $K = 11;
        #my $X = $xx + ( $K * ( $B / $gcdx ) );
        #my $Y = $xy - ( $K * ( $A / $gcdx ) );

        #print("x: $X, y: $Y\n");

    shift_solution($xx, xy, $A, $B, (1 - $xx) / $B);
    if ($xx < 1)
    {
    shift_solution($xx, xy, $A, $B, 1);
    }
    if (x > maxx)
        return 0;
    int lx1 = x;

    shift_solution(x, y, a, b, (maxx - x) / b);
    if (x > maxx)
        shift_solution(x, y, a, b, -sign_b);
    int rx1 = x;

    shift_solution(x, y, a, b, -(miny - y) / a);
    if (y < miny)
        shift_solution(x, y, a, b, -sign_a);
    if (y > maxy)
        return 0;
    int lx2 = x;

    shift_solution(x, y, a, b, -(maxy - y) / a);
    if (y > maxy)
        shift_solution(x, y, a, b, sign_a);
    int rx2 = x;

    if (lx2 > rx2)
        swap(lx2, rx2);
    int lx = max(lx1, lx2);
    int rx = min(rx1, rx2);

        #my $min = 0;
        #for my $j ( 1 .. 10000000000000 ) {
        #        for my $k ( 0 .. $j ) {
        #                my $acoins = $k;
        #                my $bcoins = $j - $k;
        #
        #                print("$acoins $bcoins\n");
        #                if (
        #                        (
        #                                ( $input[$i][0][0] * $acoins ) +
        #                                ( $input[$i][1][0] * $bcoins ) ==
        #                                $input[$i][2][0]
        #                        )
        #                        && ( ( $input[$i][0][1] * $acoins ) +
        #                                ( $input[$i][1][1] * $bcoins ) ==
        #                                $input[$i][2][1] )
        #                  )
        #                {
        #                        my $solution = ( $acoins * 3 ) + $bcoins;
        #                        if (       $min == 0
        #                                || $solution < $min )
        #                        {
        #                                $min = $solution;
        #                        }
        #                }
        #        }
        #}
        #$total += $min;
}

print("$total\n");

close(FH);
