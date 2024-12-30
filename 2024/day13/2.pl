#!/usr/bin/env perl
use strict;
use warnings;
use POSIX qw/ceil/;
use POSIX qw/floor/;
use POSIX qw/abs/;

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

#sub shift_solution {
#        my $X   = $_[0];
#        my $Y   = $_[1];
#        my $A   = $_[2];
#        my $B   = $_[3];
#        my $CNT = $_[4];
#        $$X += $CNT * $B;
#        $$Y -= $CNT * $A;
#}

my $total = 0;
for my $i ( 0 .. @input - 1 ) {

        #$input[$i][2][0] += 10000000000000;
        #$input[$i][2][1] += 10000000000000;

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
                #print("impossible!\n");
                next;
        }
        if ( $gcdx != 1 ) {
                $input[$i][0][0] /= $gcdx;
                $input[$i][1][0] /= $gcdx;
                $input[$i][2][0] /= $gcdx;
        }
        if ( $gcdy != 1 ) {
                $input[$i][0][1] /= $gcdy;
                $input[$i][1][1] /= $gcdy;
                $input[$i][2][1] /= $gcdy;
        }

#        print(
#"xx: $xx xy: $xy cx: $input[$i][2][0]\nyx: $yx, yy: $yy, cy: $input[$i][2][1]\n\n"
#        );

        my $Ax = $input[$i][0][0];
        my $Bx = $input[$i][1][0];
        my $Cx = $input[$i][2][0];

        #        print(
        #"cx: $input[$i][2][0] gcdx $gcdx , gcdy $gcdy cy: $input[$i][2][1]\n"
        #        );
        #        print( "t >= ", ( -$xx * $Cx / $Bx ),
        #                ", t <= ", ( $xy * $Cx / $Ax ), "\n\n" );
        my $Ay = $input[$i][0][1];
        my $By = $input[$i][1][1];
        my $Cy = $input[$i][2][1];

        #my $sizex = abs( ceil( -$xx * $Cx / $Bx ) - floor( $xy * $Cx / $Ax ) );
        #my $sizey = abs( ceil( -$yx * $Cy / $By ) - floor( $yy * $Cy / $Ay ) );

        #my $sizey = @shity;
        #print("Cx: $Cx Cy: $Cy, sizex: $sizex, sizey: $sizey\n");

        print("x\n");

        #for my $t ( ceil( -$xx * $Cx / $Bx ) .. ceil( -$xx * $Cx / $Bx ) ) {

        for my $t ( ceil( -$xx * $Cx / $Bx ) .. floor( $xy * $Cx / $Ax ) ) {
                print( "x:", ( $t * $Bx ) + ( $xx * $Cx ),
                        " y:", ( $xy * $Cx ) - ( $t * $Ax ), "\n" );
        }
        print("y\n");

        #for my $t ( ceil( -$yx * $Cy / $By ) .. ceil( -$yx * $Cy / $By ) ) {

        for my $t ( ceil( -$yx * $Cy / $By ) .. floor( $yy * $Cy / $Ay ) ) {
                print( "x:", ( $t * $By ) + ( $yx * $Cy ),
                        " y:", ( $yy * $Cy ) - ( $t * $Ay ), "\n" );
        }

        print("\n\n");

        #print("xx $xx xy $xy\n");

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
