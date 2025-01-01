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

        #        print(
        #"cx: $input[$i][2][0] gcdx $gcdx , gcdy $gcdy cy: $input[$i][2][1]\n"
        #        );
        #        print( "t >= ", ( -$xx * $Cx / $Bx ),
        #                ", t <= ", ( $xy * $Cx / $Ax ), "\n\n" );

        #
        #print("Cx: $Cx Cy: $Cy, sizex: $sizex, sizey: $sizey\n");

        #print("x\n");

        my $Ax = $input[$i][0][0];
        my $Bx = $input[$i][1][0];
        my $Cx = $input[$i][2][0];
        my $Ay = $input[$i][0][1];
        my $By = $input[$i][1][1];
        my $Cy = $input[$i][2][1];

        my $minx = ceil( -$xx * $Cx / $Bx );
        my $maxx = floor( $xy * $Cx / $Ax );
        my $miny = ceil( -$yx * $Cy / $By );
        my $maxy = floor( $yy * $Cy / $Ay );
        my $t    = $minx;
        my $j    = $miny;

        my $X_half = floor( ( $maxx - $minx ) / 2 );
        my $Y_half = floor( ( $maxy - $miny ) / 2 );

        my $Xx              = ( $t * $Bx ) + ( $xx * $Cx );
        my $Yx              = ( $j * $By ) + ( $yx * $Cy );
        my $Xy              = ( $xy * $Cx ) - ( $t * $Ax );
        my $Yy              = ( $yy * $Cy ) - ( $j * $Ay );
        my $base_next       = undef;
        my $base_cur        = undef;
        my $base_val        = undef;
        my $base_half       = undef;
        my $base_half_orig  = undef;
        my $other_cur       = undef;
        my $other_next      = undef;
        my $other_val       = undef;
        my $other_half      = undef;
        my $other_half_orig = undef;

        if ( $Xy > $Yy ) {
                $base_next       = \$Xx;
                $base_cur        = \$Xy;
                $base_val        = \$t;
                $base_half       = \$X_half;
                $base_half_orig  = $X_half;
                $other_cur       = \$Yy;
                $other_next      = \$Yx;
                $other_val       = \$j;
                $other_half      = \$Y_half;
                $other_half_orig = $Y_half;
        }
        else {
                $base_cur        = \$Yy;
                $base_next       = \$Yx;
                $base_val        = \$j;
                $base_half       = \$Y_half;
                $base_half_orig  = $Y_half;
                $other_cur       = \$Xy;
                $other_next      = \$Xx;
                $other_val       = \$t;
                $other_half_orig = $X_half;
        }

       # while (1) {
       #         $Xx = ( $t * $Bx ) + ( $xx * $Cx );
       #         $Xy = ( $xy * $Cx ) - ( $t * $Ax );
       #         $Yx = ( $j * $By ) + ( $yx * $Cy );
       #         $Yy = ( $yy * $Cy ) - ( $j * $Ay );
       #
       #         my $userword = <STDIN>;
       #
       #         # crunch $userword;
       #
       #         if ( $$base_half < 2 ) {
       #
       #                 # if ( $$other_half < 2 ) {
       #                 #         $$base_half  = $base_half_orig;
       #                 #         $$other_half = $other_half_orig;
       #                 # }
       #                 if (       $$base_cur == $$other_cur
       #                         && $$base_next == $$other_cur )
       #                 {
       #                         next;
       #                 }
       #                 ( $base_cur,  $base_next ) = ( $base_next, $base_cur );
       #                 ( $other_cur, $other_next ) =
       #                   ( $other_next, $other_cur );
       #                 ( $base_val,  $other_val ) = ( $other_val, $base_val );
       #                 ( $base_half, $other_half ) =
       #                   ( $other_half, $base_half );
       #         }
       #         elsif ( $$base_cur > $$other_cur ) {
       #                 $$base_val += $$base_half;
       #                 $$base_half = ceil( $$base_half / 2 );
       #
       #                 print("$$base_cur > $$other_cur\n");
       #                 print("Xx: $Xx Yx: $Yx\n");
       #                 print("Xy: $Xy Yy: $Yy, base_half: $$base_half\n");
       #         }
       #         elsif ( $$base_cur < $$other_cur ) {
       #                 $$base_val -= $$base_half;
       #                 $$base_half = ceil( $$base_half / 2 );
       #
       #                 # $j += $Y_half;
       #                 # $Y_half = ceil( $Y_half / 2 );
       #
       #                 print("$$base_cur < $$other_cur\n");
       #                 print("Xx: $Xx Yx: $Yx\n");
       #                 print("Xy: $Xy Yy: $Yy, base_half: $$base_half\n");
       #         }
       #
       # }

        #print( "Yx:", ( $j * $By ) + ( $yx * $Cy ),
        #        "\nYy:", ( $yy * $Cy ) - ( $j * $Ay ), "\n" );

        for my $t ( ceil( -$xx * $Cx / $Bx ) .. floor( $xy * $Cx / $Ax ) ) {

                # print( "x:", ( $t * $Bx ) + ( $xx * $Cx ),
                #         " y:", ( $xy * $Cx ) - ( $t * $Ax ), "\n" );
        }
        print("y\n");

        for my $t ( $miny .. $maxy ) {

                # print( "x:", ( $t * $By ) + ( $yx * $Cy ),
                #         " y:", ( $yy * $Cy ) - ( $t * $Ay ), "\n" );
        }

        print("\n\n");

}

print("$total\n");

close(FH);
