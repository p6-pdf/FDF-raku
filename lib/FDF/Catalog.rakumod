unit role FDF::Catalog;

use PDF::COS::Tie::Hash;
also does PDF::COS::Tie::Hash;

use ISO_32000::Table_242-Entries_in_the_FDF_catalog_dictionary;
also does ISO_32000::Table_242-Entries_in_the_FDF_catalog_dictionary;

use ISO_32000_2::Table_245-Entries_in_the_FDF_catalog_dictionary;
also does ISO_32000_2::Table_245-Entries_in_the_FDF_catalog_dictionary;

=begin pod
=head1 role FDF::Catalog

=head2 Description

The root node of an FDF file’s object hierarchy is the Catalog dictionary, located by means of the Root entry in
the file’s trailer dictionary (FDF). The only
required entry in the catalogue is FDF - an FDF dictionary L<FDF::Dict>, which in turn
contains references to other objects describing the file’s contents. The catalogue may also contain an optional
Version entry identifying the version of the PDF specification to which this FDF file conforms.

=head2 Methods
=end pod

    # See [PDF 32000 Table 242 Entries in the FDF catalog dictionary]
use PDF::COS::Tie;
use PDF::COS::Name;

#| (Optional; PDF 1.4) The version of the PDF specification to which the document conforms (for example, 1.)
has PDF::COS::Name $.Version is entry;

use FDF::Dict;
#| (Required) The FDF dictionary for this file
has FDF::Dict $.FDF is entry(:required);


