use v6;

use PDF::DAO::Tie::Hash;
use PDF::FDF::Dict;

# See [PDF 1.7 TABLE 8.92 Entries in the FDF catalog dictionary]

role PDF::FDF::Catalog
    does PDF::DAO::Tie::Hash {

    use PDF::DAO::Tie;

    # see [PDF 1.7 TABLE 3.25 Entries in the catalog dictionary]
    use PDF::DAO::Tie::Hash;
    use PDF::DAO::Name;

    has PDF::DAO::Name $.Version is entry;         #| (Optional; PDF 1.4) The version of the PDF specification to which the document conforms (for example, 1.4)y

    has PDF::FDF::Dict $.FDF is entry(:required);  #| (Required) The FDF dictionary for this file

    has Hash $.Sig is entry;
}
