#!/usr/bin/env perl6
use v6;

use PDF::DOM;
use PDF::FDF;
use PDF::DAO::Type::Encrypt :PermissionsFlag;

#| list all fields and current values
multi sub MAIN(
    Str $infile,            #| input PDF or FDF
    Str  :$password = '',   #| password for the PDF/FDF, if encrypted
    Bool :$list!,
    ) {
    my $doc;
    my @fields;

    if $infile.IO.extension.lc eq 'fdf' {
        $doc = PDF::FDF.open($infile, :$password);
        @fields = $doc.fields;
    }
    else {
        $doc = PDF::DOM.open($infile, :$password);
        @fields = $doc.Root.AcroForm.fields
	    if $doc.Root.?AcroForm;
    }

    if +@fields {
	my %fields-hash;

	for @fields -> $field {
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

	say "{.key}: {.value}"
	    for %fields-hash.pairs.sort;
    }
    else {
	warn "this {$doc.type} has no form fields";
    }
}

#| update PDF, setting specified fields from imported FDF or name-value pairs
multi sub MAIN(
    Str $infile,
    Str  :$import,
    Str  :$save-as,
    Bool :$update,
    Bool :$trigger-clear,
    Str  :$background,
    Str  :$password = '',
    Bool :$force = False,
    *@field-list) {

    my $doc = PDF::DOM.open($infile, :$password);
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
	    # todo: port CAM::PDF::fillFormFields sub. fill-form method in PDF::DOM::Type::Field?
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

    if $save-as.defined {
        $doc.save-as( $save-as, :$force );
    }
    else {
        $doc.update;
    }
}

=begin pod

=head1 NAME

pdf-fill-fields.p6 - Replace PDF form fields with specified values

=head1 SYNOPSIS

 pdf-fill-fields.p6 --list --password=text infile.pdf
 pdf-fill-fields.p6 [--save-as outfile.pdf] [options] infile.pdf --import values.fdf [field value ...]

 Options:
   --list               list fields and current values
   --import=values.fdf  import FDF field data
   --save-as=file.pdf   save to a new file
   --force              force save-as when digital signatures may be invalidated
   --trigger-clear      remove all of the form triggers after replacing values
   --password           provide user/owner password for an encrypted PDF

=head1 DESCRIPTION

Fill in the forms in the PDF with the specified values, identified by
their field names.  See C<pdf-fill-fields.pl --list> lists form fields.

In some cases digital signatures may be invalidated when the document is saved
in full with the --save-as option. The --force option can be used to proceed,
in such circumstances.

=head1 SEE ALSO

CAM::PDF (Perl 5)
PDF::DOM (Perl 6)

=head1 AUTHOR

See L<CAM::PDF>

=cut

=end pod
