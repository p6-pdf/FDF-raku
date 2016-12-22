use v6;

use PDF;
use PDF::Doc::Delegator;

#| DOM entry-point. either a trailer dict or an XRef stream
class FDF
    is PDF {

    # See [PDF 1.7 TABLE 8.91 Entry in the FDF trailer dictionary]
    use PDF::DAO::Tie;
    use FDF::Catalog;

    has FDF::Catalog $.Root is entry(:required,:indirect);

    method type { 'FDF' }
    method version returns Version:_ {
	my $version = self.Root.Version;
	# reader extracts version from the PDF Header, e.g.: '%PDF-1.4'
	$version //= .version
	    with self.reader;

	$version
	    ?? Version.new( $version )
	    !! Nil
    }

    method fields {
	self.Root.FDF.fields
    }

    method open(|c) {
	my $doc = callsame;

	die "FDF file has wrong type: " ~ $doc.reader.type
	    unless $doc.reader.type eq 'FDF';

	$doc.delegator.coerce($doc<Root>, FDF::Catalog);
	$doc;
    }

    #| Save back to the original file. Note that incremental update is not applicable FDF
    method update(|c) {
	$.save-as($.reader.file-name, |c);
    }

    method save-as($spec, |c) {
	self.cb-init
	    unless self<Root>:exists;

	nextwith( $spec, |c);
    }

    method cb-init {
	self<Root> //= { :FDF{} };
	self.delegator.coerce(self<Root>, FDF::Catalog);
    }

}
