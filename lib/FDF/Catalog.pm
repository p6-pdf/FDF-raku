use v6;

use PDF::COS::Tie::Hash;

role FDF::Catalog
    does PDF::COS::Tie::Hash {

    use PDF::COS::Tie;

    # See [PDF 32000 Table 242 Entries in the FDF catalog dictionary]
    use PDF::COS::Tie::Hash;
    use PDF::COS::Name;

    has PDF::COS::Name $.Version is entry;         # (Optional; PDF 1.4) The version of the PDF specification to which the document conforms (for example, 1.4)

    use FDF::Dict;
    has FDF::Dict $.FDF is entry(:required);       # (Required) The FDF dictionary for this file

}

