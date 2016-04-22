#!/usr/bin/env perl6
use v6;

use PDF::Struct::Doc;
use PDF::FDF;
use PDF::DAO::Type::Encrypt :PermissionsFlag;

#| list all fields and current values
multi sub MAIN(
    Str $infile,            #| input PDF or FDF
    Bool :$list!,
    Str  :$password = '',   #| password for the PDF/FDF, if encrypted
    ) {
    my $doc;
    my @fields;

    if $infile.IO.extension.lc eq 'fdf' {
        $doc = PDF::FDF.open($infile, :$password);
        @fields = $doc.fields;
    }
    else {
        $doc = PDF::Struct::Doc.open($infile, :$password);
        @fields = $doc.Root.AcroForm.fields
	    if $doc.Root.?AcroForm;
    }

    if +@fields {
	my %fields-hash;

	for @fields -> $field {
	    next unless $field.can('V');
	    my $key = '???';
	    if $field.T && !(%fields-hash{ $field.T }:exists) {
		$key = $field.T
	    }
	    else {
		$key = $field.TU
		    if $field.TU && !(%fields-hash{ $field.TU }:exists);
	    }
	    %fields-hash{$key} = $field.V;
	}

	say "{.key}: {.value // ''}"
	    for %fields-hash.pairs.sort;
    }
    else {
	warn "this {$doc.type} has no form fields";
    }
}

#| update PDF, setting specified fields from imported FDF or name-value pairs
multi sub MAIN(
    Str $infile,
    Bool :$fill!,
    Str  :$import,
    Str  :$save-as,
    Bool :$trigger-clear,
    Str  :$background,
    Str  :$password = '',
    *@field-list) {

    my $doc = PDF::Struct::Doc.open($infile, :$password);
    die "$infile has no fields defined"
	unless $doc.Root.AcroForm;

    die "please use --import file.fdf, provide field-value pairs or --list to display fields"
	unless @field-list || $import.defined;

    my %fields = $doc.Root.AcroForm.fields-hash;

    if $import.defined {
        die "--import file does not have '.fdf' extension"
	    unless $import.IO.extension.lc eq 'fdf';
	my $fdf = PDF::FDF.open: $import;

	my @import-fields = $fdf.fields;
	my @ignored;

	for @import-fields -> $field {
	    my $key = $field.T;
	    my $val = $field.V
	        // next;

	    if %fields{$key}:exists {
		%fields{$key}.V = $val;
		%fields{$key}<AA>:delete
		    if $trigger-clear;
	    }
	    else {
		@ignored.push: $key;
	    }
	}
        warn "unknown import fields were ignored: @ignored[]"
	    if @ignored;
    }

    die "last field not paired with a value: @field-list[*-1]"
	unless +@field-list %% 2;

##if ($opts{background} =~ m/\s/xms)
##{
##   # Separate r,g,b
##   $opts{background} = [split m/\s+/xms, $opts{background}];
##}

    for @field-list -> $key, $val {
	if %fields{$key}:exists {
	    # CAM::PDF is working harder here and resizing/styling the field to accomodate the field value
	    # todo: port CAM::PDF::fillFormFields sub. fill-form method in PDF::Struct::Field?
	    %fields{$key}.V = $val;
	    %fields{$key}<AA>:delete
		if $trigger-clear;
	}
	else {
	    warn "no such field: $key. Use --list to display fields";
	}
    }

    die "This PDF forbids modification\n"
	unless $doc.permitted( PermissionsFlag::Modify );

    with $save-as {
        $doc.save-as( $_ );
    }
    else {
        $doc.update;
    }
}

#| export acroform fields from a PDF to an FDF file
multi sub MAIN(
    Str $infile,            #| input PDF
    Str $outfile = $infile.subst(/:i ['.' \w+]? $/, '.fdf'),           #| output FDF
    Bool :$export!,
    Str  :$password = '',   #| password for the PDF, if encrypted
    ) {
    my $doc;
    my @fields;

    $doc = PDF::Struct::Doc.open($infile, :$password);
    my @pdf-fields = $doc.Root.AcroForm.fields
	    if $doc.Root.?AcroForm;
 
    die "PDF has no AcroForm fields: $infile"
	unless @pdf-fields;

    die "Output file does not have an .fdf or .json extension: $outfile"
	unless $outfile.IO.extension ~~ /:i [fdf|json] $/;

    my $fdf = PDF::FDF.new;
    my $fdf-dict = $fdf.Root.FDF;
    $fdf-dict.F = $infile.IO.basename;
    my $fdf-fields = $fdf-dict.Fields //= [];

    for 0..2 {
        my $pdf-field = @pdf-fields[$_];
	my $fdf-field = $fdf-fields.push: {};
	# pretty simple ATM, just copy common fields
	for $pdf-field.keys {
	    next if $_ ~~ 'Kids' | 'Type' | 'Subtype' || ! $fdf-field.can($_);
	    $fdf-field."$_"() = $pdf-field{$_};
	}
    }

    warn "saving...";
    $fdf.save-as: $outfile;
}

=begin pod

=head1 NAME

pdf-fields.p6 - Manipulate PDF/FDF fields

=head1 SYNOPSIS

 pdf-fields.p6 --list infile.[pdf|fdf]
 pdf-fields.p6 --fill [--save-as outfile.pdf] [options] infile.pdf --import=values.fdf [field value ...]
 pdf-fields.p6 --export infile.pdf [outfile.fdf]

 Options
   --list               list fields and current values
   --fill               fill fields from an fdf, or command-line values
       --import=values.fdf  import FDF field data
       --save-as=file.pdf   save to a new file
       --trigger-clear      remove all of the form triggers after replacing values
   --export             export PDF fields to an FDF

 General Options:
   --password           provide user/owner password for an encrypted PDF

=head1 DESCRIPTION

List, fill or export PDF form fields.

=end pod
