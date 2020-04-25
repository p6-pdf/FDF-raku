use v6;

=begin pod
=head1 NAME

FDF::Page

=head1 DESCRIPTION

This dictionary describes a new page that is added to the target document.

=head1 METHODS
=end pod

use PDF::COS::Tie::Hash;

role FDF::Page
    does PDF::COS::Tie::Hash {

    # See [PDF 32000 - Table 248 Entries in an FDF page dictionary]
    use PDF::COS::Tie;

    use FDF::Template;
    #| (Required) An array of FDF template dictionaries describing the named pages that serve as templates on the page. 
    has FDF::Template @.Templates is entry(:required);
    #| (Optional) An FDF page information dictionary containing additional information about the page. At the time of ISO-32000 publication, no entries have been defined for this dictionary. 
    has Hash $.Info is entry;
}
