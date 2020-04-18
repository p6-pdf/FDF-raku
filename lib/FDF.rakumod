use v6;

use PDF;
use PDF::Class::Loader;
use PDF::Class:ver<0.4.4+>;
use PDF::COS::Type::Encrypt :PermissionsFlag;

class FDF
    is PDF {

    # See [PDF 1.7 TABLE 8.91 Entry in the FDF trailer dictionary]
    use PDF::COS::Tie;
    use FDF::Catalog;
    use PDF::COS;

    has FDF::Catalog $.Root is entry(:required, :indirect);

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
    #| There is however a /Differences entry in the FDF dictionary...
    method update(|c) {
	$.save-as($.reader.file-name, |c);
    }

    method cb-init {
	self<Root> //= { :FDF{} };
	PDF::COS.coerce(self<Root>, FDF::Catalog);
    }

    method import-to(PDF::Class $pdf, Bool :$drm = True, |c) {
        my %fields = $pdf.fields-hash;

	unless %fields {
            my $pdf-file = do with $pdf.reader { .filename } // 'PDF';
            die "$pdf-file has no fields defined";
        }

        if $drm {
            die "This PDF forbids modification\n"
	        unless $pdf.permitted( PermissionsFlag::Modify );
        }
        my @ignored;

        my @fdf-fields = self.fields;

        for @fdf-fields -> $fdf-field {
	    my $key = $fdf-field.T;

	    if %fields{$key}:exists {
                $fdf-field.import-to: %fields{$key}, |c;
	    }
	    else {
	        @ignored.push: $key;
	    }
        }
        warn "unknown import fields were ignored: @ignored[]"
            if @ignored;
    }

    method export-from(PDF::Class $pdf, |c) {
        my $fdf-dict = self.Root.FDF;
        $fdf-dict.F = .file-name
           with $pdf.reader;

        my @pdf-fields = $pdf.fields;

        unless @pdf-fields {
            my $pdf-file = do with $pdf.reader { .filename } // 'PDF';
            die "$pdf-file has no AcroForm fields"
        }

        my $fdf-fields = $fdf-dict.Fields //= [];

        for 0..^ +@pdf-fields {
            my $pdf-field = @pdf-fields[$_];
            my $fdf-field = $fdf-fields.push: {};
            $fdf-field.export-from: $pdf-field, |c;
        }
    }

}
