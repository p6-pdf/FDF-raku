#!/usr/bin/env raku
use v6;

use PDF;
use PDF::Class;
use FDF;
use PDF::COS::Type::Encrypt :PermissionsFlag;

my subset FDF-File of Str where !.defined || .IO.extension.lc ~~ 'fdf'|'json';
my subset PDF-File of Str where !.defined || .IO.extension.lc ~~ 'pdf';
my subset PDF-or-FDF-File where PDF-File|FDF-File;

#| list all fields and current values
multi sub MAIN(
    PDF-or-FDF-File:D $infile,
    Bool :list($) where .so,
    Bool :$labels,          #| display labels, rather than keys
    Str  :$password = '',   #| password for the PDF/FDF, if encrypted
    ) {
    my $class = $infile ~~ FDF-File ?? FDF !! PDF::Class;
    my PDF $doc = $class.open($infile, :$password);
    my @fields = $doc.fields;

    if @fields {
        my $n = 0;
        for @fields {
            my $key = .TU if $labels;
            $key //= .T // '???';
            # value is commonly a text-string or name, but can
            # also be dictionary object (e.g. PDF::Signature)
            my $value = (.V // '').perl;
            say "{++$n}. $key: $value";
        }
    }
    else {
	warn "this {$doc.type} file has no form fields";
    }
}

sub get-pdf-fdf($file, $file2) {
    my PDF-File $pdf;
    my FDF-File $fdf;
    # allow PDF and FDF files in any order. only require one and guess the other

    given $file {
        when PDF-File {
            $pdf = $_;
            $fdf = $file2
                // .substr(0, *-4) ~ (.ends-with('.PDF') ?? '.FDF' !! '.fdf');
        }
        when FDF-File {
            $fdf = $_;
            $pdf = $file2
                // .substr(0, *-4) ~ (.ends-with('.FDF') ?? '.PDF' !! '.pdf');
        }
    }

    $pdf, $fdf;
}

#| update PDF, setting specified fields from imported FDF or name-value pairs
multi sub MAIN(
    Str $file,
    Str $file2?,
    Bool :$import! where .so,
    PDF-File :$save-as,
    Bool :$appearances,
    Str  :$background,
    Str  :$password = '',
) {
    (my PDF-File $pdf-file, my FDF-File $fdf-file) = get-pdf-fdf($file, $file2);

    my PDF::Class $pdf .= open($pdf-file, :$password);
    my %fields = $pdf.fields-hash;

    die "$pdf-file has no fields defined"
	unless %fields;

    die "This PDF forbids modification\n"
	unless $pdf.permitted( PermissionsFlag::Modify );

    my FDF $fdf .= open: $fdf-file;

    my @fdf-fields = $fdf.fields;
    my @ignored;

    for @fdf-fields -> $fdf-field {
	my $key = $fdf-field.T;
	my $val = $fdf-field.V
	    // next;

	if %fields{$key}:exists {
	    %fields{$key}.V = $val;
            if $appearances && ($fdf-field<AP>:exists) {
                %fields{$key}.AP = $fdf-field.AP;
            }
	}
	else {
	    @ignored.push: $key;
	}
    }
    warn "unknown import fields were ignored: @ignored[]"
        if @ignored;

    with $save-as {
        $pdf.save-as( $_ );
    }
    else {
        $pdf.update;
    }
}

#| export acroform fields from a PDF to an FDF file
multi sub MAIN(
    Str $file,
    Str $file2?,
    Bool :export($)! where .so;
    Str  :$password = '',   #| password for the PDF, if encrypted
    ) {
    (my PDF-File $pdf-file, my FDF-File $fdf-file) = get-pdf-fdf($file, $file2);
    my PDF::Class $pdf .= open($pdf-file, :$password);
    my @pdf-fields = $pdf.fields;
 
    die "PDF has no AcroForm fields: $pdf-file"
	unless @pdf-fields;

    my FDF $fdf .= new();
    my $fdf-dict = $fdf.Root.FDF;
    $fdf-dict.F = $fdf-file.IO.basename;
    my $fdf-fields = $fdf-dict.Fields //= [];

    for 0..^ +@pdf-fields {
        my $pdf-field = @pdf-fields[$_];
	my $fdf-field = $fdf-fields.push: {};
	# pretty simple ATM, just copy common fields
	for $pdf-field.keys {
	    next if $_ ~~ 'Kids' | 'Type' | 'Subtype' || ! $fdf-field.can($_);
	    $fdf-field."$_"() = $pdf-field{$_};
	}
    }

    note "saving $fdf-file...";
    $fdf.save-as: $fdf-file;
}

=begin pod

=head1 NAME

fdf-fields.raku - Manipulate FDF fields

=head1 SYNOPSIS

 fdf-fields.raku --list=infile.[pdf|fdf]
 fdf-fields.raku --import=infile.fdf [infile.pdf] [--save-as outfile.pdf] [options]
 fdf-fields.raku --export=outfile.fdf [infile.pdf]

 Options
   --list infile.[pdf|fdf]             % list fields and current values
   --import=infile.fdf [outfile.pdf]   % import fields from an fdf file
       --save-as=file.pdf              % - save to a new file
   --export=outfile.fdf [infile.pdf]   % export PDF fields to an FDF

 General Options:
   --password           provide user/owner password for an encrypted PDF

=head1 DESCRIPTION

List, import or export FDF form fields.

=end pod
