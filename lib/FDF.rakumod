use v6;

=begin pod
=head1 NAME

FDF (Form Data Format) Trailer Dictionary

=head1 DESCRIPTION

The trailer of an FDF file enables a reader to find significant objects quickly within the body of the file.  The
only required key is Root, whose value is an indirect reference to the file’s catalogue dictionary (see
Table 242). The trailer may optionally contain additional entries for objects that are referenced from within the
catalogue.

=head1 METHODS

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

    # Save back to the original file. Note that incremental update is not applicable to FDF
    # There is however a /Differences entry in the FDF dictionary...
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

    method export-from(PDF::Class $pdf, :%fill, |c) {
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
            temp $pdf-field.V = $_
                with %fill{$pdf-field.T}:delete;
            my $fdf-field = $fdf-fields.push: {};
            $fdf-field.export-from: $pdf-field, |c;
        }

        if %fill {
            warn "ignoring edits on unknown fields: {%fill.keys.sort.join: ','}";
        }

        $fdf-fields;
    }

}
