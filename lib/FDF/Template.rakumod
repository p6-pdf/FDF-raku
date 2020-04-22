use v6;

use PDF::COS::Tie::Hash;

=begin pod

=head1 NAME

FDF::Template

=head1 DESCRIPTION

An FDF template dictionary contains information describing a named page that serves as a template.

=head1 METHODS
=end pod

role FDF::Template
    does PDF::COS::Tie::Hash {

    # See [ PDF 32000 Table 249 - Entries in an FDF template dictionary]
    use PDF::COS::Tie;

    use FDF::NamedPageRef;
    #| (Required) A named page reference dictionary specifying the location of the template. 
    has FDF::NamedPageRef $.TRef is entry(:required, :alias<page-ref>);
    use FDF::Field;
    #| (Optional) An array of references to FDF field dictionaries describing the root fields to be imported (those with no ancestors in the field hierarchy). 
    has FDF::Field @.Fields is entry;
    #| (Optional) A flag specifying whether fields imported from the template may be renamed in the event of name conflicts with existing fields. Default value: true. 
    has Bool $.Rename is entry;
}
