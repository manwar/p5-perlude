#! /usr/bin/perl
use strict;
use warnings;
use Lazyness ':all';
use Test::More 'no_plan';

my ( @input, $got, $expected );
# 
# @input    = qw/ test toto tata tutu et le reste /;
# $got      = [fold takeWhile { /^t/ } sub { shift @input }];
# $expected = [qw/ test toto tata tutu /];
# 
# is_deeply( $got, $expected, "takeWhile works");

# sub begins_with_t ($) { takeWhile { /^t/ } shift }
# my @t = qw/ toto tata aha /;
# print "$_\n" for fold begins_with_t sub { shift @t }

my $fold_ok = is
( fold( sub { undef } )
, 0 
, "fold works" );

unless ( $fold_ok ) {
    diag("fold failed so every other tests will fail too");
    exit;
}

sub test_it {
    my ( $f, $input, $expected, $desc ) = @_;
    my $got = [fold $f->( sub { shift @$input } ) ];
    is_deeply( $got, $expected, $desc );
}

for my $test (

    [ sub { takeWhile { /^t/ } shift }
    , [qw/ toto tata haha got /]
    , [qw/ toto tata /]
    , "takeWhile ok"
    ],

    [ sub { take 2, shift }
    , [qw/ foo bar pan bing /]
    , [qw/ foo bar /]
    , "take ok"
    ],

    [ sub { filter { /a/ } shift }
    , [qw/ foo bar pan bing /]
    , [qw/ bar pan /]
    , "filter ok"
    ],

) { test_it @$test }


@input = qw/ foo bar test /;
sub eat { fold take shift, sub { shift @input } };

{
    my $take_test = 1;
    for my $takes
    ( [ [qw/ foo bar /] , [eat 2]  ]
    , [ [qw/ test /]    , [eat 10] ]
    , [ []              , [eat 10] ]
    ) { my ( $expected, $got ) = @$takes;
	is_deeply ( $got, $expected , "take test $take_test ok" );
	$take_test++;
    }
}

sub take2ones { take 2, sub { 1 } }

$got = [ fold mapM { $_ + 1 } take2ones ];
$expected = [ 2, 2 ];
is_deeply( $got, $expected, 'mapM works');

my $count = 0;
$got = mapM_ { $count+=$_ } take2ones;
is( $got  , 0, 'mapM_ returns nothing');
is( $count, 2, 'mapM_ did things');

($got) = fold drop 2, do {
    my @a = qw/ a b c d e f /;
    sub { shift @a }
};
is( $got, 'c', 'drop works' );

($got) = fold drop 2, do {
    my @a = qw/ /;
    sub { shift @a }
};
is( $got, undef, 'drop works again' );










# take 3, cycle 1, 2;
