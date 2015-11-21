use v6;

use PDF::DAO::Doc;
use PDF::DOM::Delegator;

#| DOM entry-point. either a trailer dict or an XRef stream
my class FDF
    is PDF::DAO::Doc {

    # See [PDF 1.7 TABLE 8.91 Entry in the FDF trailer dictionary]
    use PDF::DAO::Tie;
    use PDF::DAO::Delegator;
    use PDF::FDF::Catalog;

    has PDF::FDF::Catalog $.Root is entry(:required,:indirect);

    method type { 'FDF' }
    method version returns Version:_ {
	my $version = self.Root.Version;
	# reader extracts version from the PDF Header, e.g.: '%PDF-1.4'
	$version //= self.reader.version
	    if self.reader;

	$version
	    ?? Version.new( $version )
	    !! Nil
    }

    method open(|c) {
	my $obj = callsame;
	$obj.delegator.coerce($obj<Root>, PDF::FDF::Catalog);
	$obj;
    }

    #| Save back to the original PDF. Note that incremental update is not support for FDF
    method update(|c) {
	$.save-as($.reader.file-name, |c);
    }

    method save-as($spec, Bool :$force, |c) {
	self.cb-init
	    unless self<Root>:exists;

	nextwith( $spec, |c);
    }

    method cb-init {
	self<Root> //= { :FDF{} };
	self.delegator.coerce(self<Root>, PDF::FDF::Catalog);
    }

}

class PDF::FDF is FDF {};
