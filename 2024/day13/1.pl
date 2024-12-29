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

my $i = 0;
while ( $i < 4 ) {
        my $j = 0;
        print("i: $i\n");
        while ( $j < 3 ) {
                print("X: $input[$i][$j][0] Y: $input[$i][$j][1] \n");
                $j++;
        }
        $i++;
}

# print("@input\n");
#
# print("$input[0][0][1]\n");
# for (@input) {
#         my @shi = $_;
#
#         print( $shi[0][0][1] )

# print("A X: $_[0][0] Y: $_[0][1]\n");
# print("B X: $_[1][0] Y: $_[1][1]\n");
# print("P X: $_[2][0] Y: $_[2][1]\n");
# }

close(FH);
