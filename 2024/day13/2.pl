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

my $total = 0;
for my $i ( 0 .. @input - 1 ) {

        $input[$i][2][0] += 10000000000000;
        $input[$i][2][1] += 10000000000000;
        my $A0 = $input[$i][0][0];
        my $B0 = $input[$i][1][0];
        my $C0 = $input[$i][2][0];
        my $A1 = $input[$i][0][1];
        my $B1 = $input[$i][1][1];
        my $C1 = $input[$i][2][1];
        my $y =
          ( ( $A0 * $C1 ) - ( $A1 * $C0 ) ) / ( ( $A0 * $B1 ) - ( $A1 * $B0 ) );
        my $x = ( $C0 - ( $B0 * $y ) ) / $A0;

        #print("$A0 x + $B0 y = $C0\n");
        #print("$A1 x + $B1 y = $C1\n");
        #print("x: $x y: $y\n");
        if ( int($x) == $x && int($y) == $y ) {
                $total += ( $x * 3 ) + $y;

                #print("passed!\n");
        }
}

print("$total\n");

close(FH);
