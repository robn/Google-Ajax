#!perl -T

use Test::More tests => 1;

BEGIN {
    use_ok( 'Google::Ajax' );
}

diag( "Testing Google::Ajax $Google::Ajax::VERSION, Perl $], $^X" );
