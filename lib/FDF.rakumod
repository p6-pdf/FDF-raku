use PDF;

#| Entry point into an FDF document
class FDF:ver<0.0.2>
    is PDF {

    # See [PDF 32000 Table  241 - Entry in the FDF trailer dictionary]
    =begin pod
    =head2 Description

    The trailer of an FDF file enables a reader to find significant objects quickly within the body of the file.  The
    only required key is Root, whose value is an indirect reference to the file’s catalogue dictionary (see
    Table 242). The trailer may optionally contain additional entries for objects that are referenced from within the
    catalogue.

    =head2 Methods

    This class inherits from L<PDF> and has most its methods available, including: `new`, `open`, `save-as`, `update`, `Str` and `Blob`.

    Note that `encrypt` is not applicable to FDF files.

    =end pod

    use PDF::Class:v<0.4.4+>;
    use FDF::Catalog;
    use PDF::COS;
    use PDF::COS::Tie;
    use PDF::COS::Type::Encrypt :PermissionsFlag;

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
	nextwith( :$.type, |c);
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

    multi method export(FDF:D: PDF::Class:D :$to!,
                  Bool :$drm = True,
                  :%fill --> Array) {
        my %to-fields = $to.fields-hash;

	unless %to-fields {
            my $to-file = do with $to.reader { .filename } // 'PDF';
            die "$to-file has no fields defined";
        }

        if $drm {
            die "This PDF forbids modification\n"
	        unless $to.permitted( PermissionsFlag::Modify );
        }

        my @ignored;
        my @fdf-fields = self.fields;

        for @fdf-fields -> $fdf-field {
	    my $key = $fdf-field.T;

	    with %to-fields{$key} -> $to-field {
                $fdf-field.export(to => $to-field);
                $to-field.V = $_
                    with %fill{$key}:delete;
	    }
	    else {
	        @ignored.push: $key;
	    }
        }

        warn "unknown import fields were ignored: @ignored[]"
            if @ignored;

        warn "ignoring edits on unknown fields: {%fill.keys.sort.join: ','}"
            if %fill;

        @fdf-fields;
    }

    multi method export(FDF:D: *%o) {
        my Str $to-file = .file-name
            with self.Root.FDF;
        with $to-file {
            my PDF::Class $to .= open($_);
            self.export: :$to, |%o;
        }
        else {
            die "FDF does not contain a source/target PDF";
        }
    }

    method create(PDF::Class:D :$from!, *%o) {
        my $fdf = self.new;
        $fdf.import( :$from, |%o);
        $fdf;
    }

    multi method import(FDF:D: PDF::Class:D :$from!, :%fill, *%o) {
        my $fdf-dict = self.Root.FDF;
        $fdf-dict.F = .file-name
           with $from.reader;

        my @pdf-fields = $from.fields;

        unless @pdf-fields {
            my $from-file = do with $from.reader { .file-name } // 'PDF';
            die "$from-file has no AcroForm fields"
        }

        my $fdf-fields = $fdf-dict.Fields //= [];

        for 0..^ +@pdf-fields {
            my $from-field = @pdf-fields[$_];
            temp $from-field.V = $_
                with %fill{$from-field.T}:delete;
            my $fdf-field = $fdf-fields.push: {};
            $fdf-field.import(from => $from-field, |%o);
        }

        if %fill {
            warn "ignoring edits on unknown fields: {%fill.keys.sort.join: ','}";
        }

        $fdf-fields;
    }

    multi method import(*%o) {
        my Str $from-file = .file
            with self.Root.FDF;
        with $from-file {
            my PDF::Class $from .= open($_);
            self.import: :$from, |%o;
        }
        else {
            die "FDF does not contain a source/target PDF";
        }
    
    }

    multi method merge(PDF::Class:D :$from!, *%o) {
        self.import(:$from, |%o);
    }

    multi method merge(PDF::Class:D :$to!, *%o) {
        self.export(:$to, |%o);
    }

}
