use v6;

use PDF;
use PDF::Class::Loader;
use PDF::Class:ver<0.4.4+>;

class FDF
    is PDF {

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
        do with self.Root.FDF { .fields } // [];
    }
    method fields-hash(|c) {
        do with self.Root.FDF { .fields-hash(|c) } // %();
    }

    method open(|c) {
        # make sure it really is an FDF
	callwith( :type<FDF>, |c);
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
