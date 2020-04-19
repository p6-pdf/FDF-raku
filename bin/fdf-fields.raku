#!/usr/bin/env raku
use v6;

use PDF;
use PDF::Class;
use FDF;

my subset FDF-File of Str where !.defined || .IO.extension.lc ~~ 'fdf'|'json';
my subset PDF-File of Str where !.defined || .IO.extension.lc ~~ 'pdf';
my subset PDF-or-FDF-File where PDF-File|FDF-File;

my %*SUB-MAIN-OPTS =
  :named-anywhere,    # allow named variables at any location 
;

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
        for @fields {
            my $key = .TU if $labels;
            $key //= .T // '???';
            # value is commonly a text-string or name, but can
            # also be dictionary object (e.g. PDF::Signature)
            my $value = (.V // '').perl;
            say "$key: $value";
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
    Bool :import($)! where .so,
    PDF-File :$save-as,
    Bool :$appearances,
    Bool :$actions,
    Bool :$drm = True,
    Str  :$password = '',
) {
    (my PDF-File $pdf-file, my FDF-File $fdf-file) = get-pdf-fdf($file, $file2);

    my PDF::Class $pdf .= open($pdf-file, :$password);
    my FDF $fdf .= open: $fdf-file;

    $fdf.import-to: $pdf, :$appearances, :$actions, :$drm;

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
    Bool :$appearances,
    Bool :$actions,
    Str  :$password = '',   #| password for the PDF, if encrypted
    *%edits,
    ) {
    (my PDF-File $pdf-file, my FDF-File $fdf-file) = get-pdf-fdf($file, $file2);
    my PDF::Class $pdf .= open($pdf-file, :$password);
    my FDF $fdf .= new();
    $fdf.export-from: $pdf, :$appearances, :$actions, :%edits;

    note "saving $fdf-file...";
    $fdf.save-as: $fdf-file;
}

=begin pod

=head1 NAME

fdf-fields.raku - Manipulate FDF fields

=head1 SYNOPSIS

 fdf-fields.raku --list infile.[pdf|fdf]
 fdf-fields.raku --import infile.fdf [infile.pdf] [--save-as outfile.pdf] [options]
 fdf-fields.raku --export outfile.fdf [infile.pdf]

 Options
   --list infile.[pdf|fdf]                               % list fields and current values
   --import infile.fdf [outfile.pdf]                     % import fields from an fdf file
   --export outfile.fdf [infile.pdf] :key=new-value ...  % export PDF fields to an FDF

 General Options:
   --password                 % provide user/owner password for an encrypted PDF
   --save-as=file.[fdf|pdf]   % save to a new file

=head1 DESCRIPTION

List, import, export or fill FDF form fields.

=end pod
