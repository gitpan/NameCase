#!/usr/bin/perl -w

=pod

Test script for Text::NameCase.pm

Copyright (c) Mark Summerfield 1998/9. All Rights Reserved. This program is
free software; you can redistribute it and/or modify it under the same terms
as Perl itself.

=cut

require 5.004 ;

use strict ;
use integer ;

use Text::NameCase qw( NameCase nc ) ;

my $debugging = 0 ;

# Set up data for the tests.
my @proper_names = (
    "Keith",            "Leigh-Williams",       "McCarthy",
	"O'Callaghan",      "St. John",             "von Streit",
	"van Dyke",         "ap Llwyd Dafydd",      
    #"al Fayd", -- could be Al as in Gore
    "el Grecco",        #"ben Gurion", # Can't use -- could be Ben as in Benjamin.
    "da Vinci",
    "di Caprio",        "du Pont",              "de Legate",
    "del Crond",        "der Sind",             "van der Post",
    "von Trapp",        "la Poisson",           "le Figaro",
	) ;

# Set up some module globals.
my @uppercase_names = map { uc } @proper_names ;
my @names = @uppercase_names ;
my @result ;
my $name ;
my $fixed_name ;

$" = ", " ;

# Print the original.
print "\tOriginal:\n@uppercase_names.\n" if $debugging ;

# Test an array without changing the array's contents; print the first result.
@result = NameCase( @names ) ;
print "\tResult:\n@result.\n" if $debugging ;
print "\nArray assignment with source array passed by copy..." ;
print ( &eq_array( \@names, \@uppercase_names ) ? "OK" : "Failed\a" ) ;
print ". Fixed..." ;
print ( &eq_array( \@result, \@proper_names ) ? "OK\n" : "Failed\a\n" ) ;

# Test an array without changing the array's contents;
# but pass the array by reference.
@result = () ;
@result = NameCase( \@names ) ;
print "Array assignment with source array passed by reference..." ;
print ( &eq_array( \@names, \@uppercase_names ) ? "OK" : "Failed\a" ) ;
print ". Fixed..." ;
print ( &eq_array( \@result, \@proper_names ) ? "OK\n" : "Failed\a\n" ) ;

# Test an array in-place.
NameCase( \@names ) ;
print "In-place with source array passed by reference...OK. Fixed..." ;
print ( &eq_array( \@names, \@proper_names ) ? "OK\n" : "Failed\a\n" ) ;

# Test a scalar in-place.
$name = $uppercase_names[1] ;
NameCase( \$name ) ;
print "In-place scalar (null operation)..." ;
print ( $name eq $uppercase_names[1] ? "OK\n" : "Failed\a\n" ) ;

# Test a scalar.
$name = $uppercase_names[1] ;
$fixed_name = NameCase( $name ) ;
print "Scalar..." ;
print ( $fixed_name eq $proper_names[1] ? "OK\n" : "Failed\a\n" ) ;

# Test a literal scalar.
$fixed_name = NameCase( "john mcvey" ) ;
print "Literal scalar..." ;
print ( $fixed_name eq "John McVey" ? "OK\n" : "Failed\a\n" ) ;

# Test a literal array.
@result = NameCase( "nancy", "drew" ) ;
print "Literal array..." ;
print ( &eq_array( \@result, [ "Nancy", "Drew" ] ) ? "OK\n" : "Failed\a\n" ) ;

# Test a scalar.
$name = $uppercase_names[1] ;
$fixed_name = nc $name ;
print "Scalar as list operator..." ;
print ( $fixed_name eq $proper_names[1] ? "OK\n" : "Failed\a\n" ) ;

# Test a literal scalar.
$fixed_name = nc "john mcvey" ;
print "Literal scalar as list operator..." ;
print ( $fixed_name eq "John McVey" ? "OK\n" : "Failed\a\n" ) ;

# Test a reference to a scalar.
$name = $uppercase_names[1] ;
$fixed_name = nc( \$name ) ;
print "Reference to a scalar using nc..." ;
print ( $name eq $uppercase_names[1] ? "OK" : "Failed\a" ) ;
print ". Fixed..." ;
print ( $fixed_name eq $proper_names[1] ? "OK\n" : "Failed\a\n" ) ;

# Test a scalar in an array context.
$name = $uppercase_names[1] ;
@result = nc $name ;
print "Scalar in a list context using nc..." ;
print ( $result[0] eq $proper_names[1] ? "OK\n" : "Failed\a\n" ) ;

# Test a reference to a scalar in an array context.
$name = $uppercase_names[1] ;
@result = nc \$name ;
print "Reference to a scalar in a list context using nc..." ;
print ( $name eq $uppercase_names[1] ? "OK" : "Failed\a" ) ;
print ". Fixed..." ;
print ( $result[0] eq $proper_names[1] ? "OK\n" : "Failed\a\n" ) ;

# Test a reference to a scalar.
$name = $uppercase_names[1] ;
$fixed_name = NameCase( \$name ) ;
print "Reference to a scalar using NameCase..." ;
print ( $name eq $uppercase_names[1] ? "OK" : "Failed\a" ) ;
print ". Fixed..." ;
print ( $fixed_name eq $proper_names[1] ? "OK\n" : "Failed\a\n" ) ;

# Test a scalar in an array context.
$name = $uppercase_names[1] ;
@result = NameCase $name ;
print "Scalar in a list context using NameCase..." ;
print ( $result[0] eq $proper_names[1] ? "OK\n" : "Failed\a\n" ) ;

# Test a reference to a scalar in an array context.
$name = $uppercase_names[1] ;
@result = NameCase \$name ;
print "Reference to a scalar in a list context using NameCase..." ;
print ( $name eq $uppercase_names[1] ? "OK" : "Failed\a" ) ;
print ". Fixed..." ;
print ( $result[0] eq $proper_names[1] ? "OK\n" : "Failed\a\n" ) ;


sub eq_array {
    my( $array_ref_A, $array_ref_B ) = @_ ;
    local( $_ ) ;

    # Can't be equal if different lengths.
    return 0 if $#{$array_ref_A} != $#{$array_ref_B} ;

    for ( 0..$#{$array_ref_A} ) {
        # Can't be equal if any element differs.
        return 0 if ${$array_ref_A}[$_] ne ${$array_ref_B}[$_] ;
    }

    1 ; # Must be equal.
}

