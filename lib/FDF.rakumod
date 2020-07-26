use v6;

=begin pod
=head1 class FDF (Form Data Format)

=head2 Description

The trailer of an FDF file enables a reader to find significant objects quickly within the body of the file.  The
only required key is Root, whose value is an indirect reference to the file’s catalogue dictionary (see
Table 242). The trailer may optionally contain additional entries for objects that are referenced from within the
catalogue.

=head2 Methods

This class inherits from L<PDF> and has most its methods available, including: `new`, `open`, `save-as`, `update`, `Str` and `Blob`.

Note that `encrypt` is not applicable to FDF files.

=end pod

use PDF;
use PDF::Class:v<0.4.4+>;
use PDF::COS::Type::Encrypt :PermissionsFlag;

class FDF
    is PDF {

    # See [PDF 32000 Table  241 - Entry in the FDF trailer dictionary]
    use PDF::COS::Tie;
    use FDF::Catalog;
    use PDF::COS;

    #| (Required; shall be an indirect reference) The Catalog object for this FDF file
    has FDF::Catalog $.Root is entry(:required, :indirect, :alias<catalog>);

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

    method encrypt { fail "encryption is not applicable to FDF files"; }

    #| Return a list of fields
    method fields {
        do with self.Root.FDF { .fields } // [];
    }
    =begin code :lang<raku>
        use FDF;
        use FDF::Field;
        my FDF $fdf .= open("MyDoc.pdf");
        my FDF::Field @fields = $fdf.fields;
    =end code

    #| Returns a Hash of fields
    method fields-hash(|c) {
        do with self.Root.FDF { .fields-hash(|c) } // %();
    }
    =begin code :lang<raku>
        my FDF::Field %fields = $fdf.fields-hash;
    =end code

    method open(|c) {
        # make sure it really is an FDF
	callwith( :type<FDF>, |c);
    }

    # Save back to the original file. Note that incremental update is not applicable to FDF
    # There is however a /Differences entry in the FDF dictionary...
    method update(|c) {
	$.save-as($.reader.file-name, |c);
    }

    method cb-init {
	self<Root> //= { :FDF{} };
	PDF::COS.coerce(self<Root>, FDF::Catalog);
    }

    multi method export(
        PDF::Class:D $pdf,
        Bool :$drm = True --> Hash) {
        my %pdf-fields = $pdf.fields-hash;

	unless %pdf-fields {
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

	    if %pdf-fields{$key}:exists {
                $fdf-field.export(%pdf-fields{$key});
	    }
	    else {
	        @ignored.push: $key;
	    }
        }
        warn "unknown import fields were ignored: @ignored[]"
            if @ignored;

        %pdf-fields;
    }

    multi method export(*%o) {
        my Str $pdf-file = .file-name
            with self.Root.FDF;
        with $pdf-file {
            my PDF::Class $pdf .= open($_);
            self.export: $pdf, |%o;
        }
        else {
            die "FDF does not contain a source/target PDF";
        }
    }

    multi method import(PDF::Class:D $pdf, :%fill, *%o) {
        my $fdf-dict = self.Root.FDF;
        $fdf-dict.F = .file-name
           with $pdf.reader;

        my @pdf-fields = $pdf.fields;

        unless @pdf-fields {
            my $pdf-file = do with $pdf.reader { .file-name } // 'PDF';
            die "$pdf-file has no AcroForm fields"
        }

        my $fdf-fields = $fdf-dict.Fields //= [];

        for 0..^ +@pdf-fields {
            my $pdf-field = @pdf-fields[$_];
            temp $pdf-field.V = $_
                with %fill{$pdf-field.T}:delete;
            my $fdf-field = $fdf-fields.push: {};
            $fdf-field.import($pdf-field, |%o);
        }

        if %fill {
            warn "ignoring edits on unknown fields: {%fill.keys.sort.join: ','}";
        }

        $fdf-fields;
    }

    multi method import(*%o) {
        my Str $pdf-file = .file
            with self.Root.FDF;
        with $pdf-file {
            my PDF::Class $pdf .= open($_);
            self.import: $pdf, |%o;
        }
        else {
            die "FDF does not contain a source/target PDF";
        }
    
    }

    multi method merge(PDF::Class:D :$from!, *%o) {
        self.import($from, |%o);
    }

    multi method merge(PDF::Class:D :$to!, *%o) {
        self.export($to, |%o);
    }

}
