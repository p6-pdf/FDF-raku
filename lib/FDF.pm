use v6;

use PDF;
use FDF::Interface;
use PDF::Class::Loader;

class FDF
    is PDF does FDF::Interface {

    # See [PDF 1.7 TABLE 8.91 Entry in the FDF trailer dictionary]
    use PDF::COS::Tie;
    use FDF::Catalog;
    use PDF::COS;

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

	PDF::COS.coerce($doc<Root>, FDF::Catalog);
	$doc;
    }

    #| Save back to the original file. Note that incremental update is not applicable to FDF
    method update(|c) {
	$.save-as($.reader.file-name, |c);
    }

    method cb-init {
	self<Root> //= { :FDF{} };
	PDF::COS.coerce(self<Root>, FDF::Catalog);
    }

}
