unit role FDF::Template;

use PDF::COS::Tie::Hash;
also does PDF::COS::Tie::Hash;

use ISO_32000::Table_249-Entries_in_an_FDF_template_dictionary;
also does ISO_32000::Table_249-Entries_in_an_FDF_template_dictionary;

=begin pod

=head1 role FDF::Template

=head2 Description

An FDF template dictionary contains information describing a named page that serves as a template.

=head2 Methods
=end pod


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

