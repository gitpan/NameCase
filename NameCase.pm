package Text::NameCase ;    # Documented at the __END__.

# $Id: NameCase.pm,v 1.2 1999/01/20 22:09:31 root Exp root $

require 5.004 ;

use strict ;

use Carp ;

use vars qw( $VERSION @ISA @EXPORT @EXPORT_OK ) ;

$VERSION = '1.00' ;


use Exporter() ;

@ISA        = qw( Exporter ) ;

@EXPORT     = qw( nc ) ;
@EXPORT_OK  = qw( NameCase nc ) ;


#############################
sub NameCase {

    croak "Usage: \$SCALAR|\@ARRAY = NameCase [\\]\$SCALAR|\@ARRAY"
        if ref $_[0] and ( ref $_[0] ne 'ARRAY' and ref $_[0] ne 'SCALAR' ) ;
        
    local( $_ ) ;

    if( wantarray and ( scalar @_ > 1 or ref $_[0] eq 'ARRAY' ) ) {
        # We have received an array or array reference in a list context
        # so we will return an array.
        map { nc( $_ ) } @{ ref( $_[0] ) ? $_[0] : \@_ } ;
    } 
    elsif( ref $_[0] eq 'ARRAY' ) {
        # We have received an array reference in a scalar or void context
        # so we will work on the array in-place.
        foreach ( @{ $_[0] } ) { 
            $_ = nc( $_ ) ;
        }
    }
    elsif( ref $_[0] eq 'SCALAR' ) {
        # We don't work on scalar references in-place; we take the value 
        # and return a name-cased copy.
        nc( ${ $_[0] } ) ;
    }
    elsif( scalar @_ == 1 and not ref $_[0] ) {
        # We've received a scalar: we return a name-cased copy.
        nc( $_[0] ) ;
    }
    else {
        croak "NameCase only accepts a single scalar, array or array ref" ;
    }
}


#############################
sub nc {

    croak "Usage: nc [\\]\$SCALAR"
        if scalar @_ != 1 or ( ref $_[0] and ref $_[0] ne 'SCALAR' ) ;
        
    local( $_ ) = @_ ;

    $_ = ${$_} if ref( $_ ) ;           # Replace reference with value.

    $_ = lc ;                           # Lowercase the lot.
	s{ \b (\w) }{\u$1}gox ;             # Uppercase first letter of every word.
    s{ (\'\w) \b }{\L$1}gox ;           # Lowercase 's.

    # Fixes for "son (daughter) of" etc. in various languages.
    s{ \b Mc(\w)       }{Mc\u$1}gox ;   # Mc? Irish/Celtic.
    s{ \b (E)l      \b }{\l$1l}gox ;    # el Arabic/Greek.
    s{ \b Ap        \b }{ap}gox ;       # ap Welsh.
    s{ \b D([aeiu]) \b }{d$1}gox ;      # da, de, di Italian; du French.
    s{ \b De([lr])  \b }{de$1}gox ;     # del Italian; der Dutch/Flemish.
    s{ \b L([ae])   \b }{l$1}gox ;      # la, le French.
    s{ \b V([ao])n  \b }{v$1n}gox ;     # van German; von Dutch/Flemish.

    $_ ;
}


1 ;

__END__

=head1 NAME

NameCase - Perl module to fix the case of people's names.

=head1 SYNOPSIS

    use Text::NameCase 'NameCase' ;

    $FixedCasedName  = NameCase( $OriginalName ) ;
    @FixedCasedNames = NameCase( @OriginalNames ) ;

    $FixedCasedName  = NameCase( \$OriginalName ) ;
    @FixedCasedNames = NameCase( \@OriginalNames ) ;

    NameCase( \@OriginalNames ) ; # In-place.

    # NameCase will not change a scalar in-place, i.e.
    NameCase( \$OriginalName ) ; # WRONG: null operation.

    # "Faster" version for working with scalars only; complementing lc and uc.

    use Text::NameCase qw( nc ) ;

    $FixedCasedName  = nc( $OriginalName ) ;

    $FixedCasedName  = nc( \$OriginalName ) ;

=head1 DESCRIPTION

Forenames and surnames are often stored either wholly in UPPERCASE
or wholly in lowercase. This module allows you to convert names into
the correct case where possible.

Although forenames and surnames are normally stored separately if they
do appear in a single string, space separated, NameCase and nc deal
correctly with them.

NameCase currently correctly name cases names which include any of the
following:
    Mc, el, ap, da, de, di, du, del, der, la, le, van and von.

It correctly deals with names which contain apostrophies and hyphens too.

=head2 EXAMPLE FIXES

    Original            Name Case
    --------            ---------
    KEITH               Keith
    LEIGH-WILLIAMS      Leigh-Williams
    MCCARTHY            McCarthy
    O'CALLAGHAN         O'Callaghan
    ST. JOHN            St. John

plus "son (daughter) of" etc. in various languages, e.g.:

    VON STREIT          von Streit
    VAN DYKE            van Dyke
    AP LLWYD DAFYDD     ap Llwyd Dafydd
etc.

=head1 BUGS

The module covers the rules that I know of. There are probably a lot
more rules, exceptions etc. for "Western"-style languages which could be
incorporated.

We don't fix names that begin with "Mac" because we can't distinguish
between MacDonald and Macadema... unless we used a list of literal
names to check for?

We don't fix "ben" - for hebrew names this means son of, but it can
mean "Ben" as a name in itself or as a form of "Benjamin". Similarly we
don't fix "al" - for arabic names this means son of, but it can also
mean "Al" as a name in itself.

There are probably lots of exceptions and problems - but as a general
data 'cleaner' it may be all you need.

=head1 CHANGES

1998/4/20   First release.

1998/6/25   First public release.

1999/01/18  Second public release.

=head1 AUTHOR

Mark Summerfield. I can be contacted as <mark.summerfield@chest.ac.uk> -
please include the word 'namecase' in the subject line.

=head1 COPYRIGHT

Copyright (c) Mark Summerfield 1998/9. All Rights Reserved.

This module may be used/distributed/modified under the same terms as Perl
itself.

=cut


