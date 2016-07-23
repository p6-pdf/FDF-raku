use v6;

use PDF::DAO::Tie::Hash;

# See [PDF 1.7 TABLE 8.92 Entries in the FDF catalog dictionary]

role FDF::Catalog
    does PDF::DAO::Tie::Hash {

    use PDF::DAO::Tie;

    # see [PDF 1.7 TABLE 3.25 Entries in the catalog dictionary]
    use PDF::DAO::Tie::Hash;
    use PDF::DAO::Name;

    has PDF::DAO::Name $.Version is entry;         #| (Optional; PDF 1.4) The version of the PDF specification to which the document conforms (for example, 1.4)y

    use FDF::Dict;
    has FDF::Dict $.FDF is entry(:required);  #| (Required) The FDF dictionary for this file

    has Hash $.Sig is entry;                       #| (Optional; PDF 1.5) A signature dictionary indicating that the document is signed using an object digest (see Section 8.7, “Digital Signatures”). This dictionary must contain a signature reference dictionary whose Data entry is an indirect reference to the catalog and whose TransformMethod entry is Identity.

    has Str $.F is entry;                          #| (Optional; PDF 1.5) A signature dictionary indicating that the document is signed using an object digest (see Section 8.7, “Digital Signatures”). This dictionary must contain a signature reference dictionary whose Data entry is an indirect reference to the catalog and whose TransformMethod entry is Identity.

    has Str @.ID is entry(:len(2));                #| (Optional; PDF 1.5) A signature dictionary indicating that the document is signed using an object digest (see Section 8.7, “Digital Signatures”). This dictionary must contain a signature reference dictionary whose Data entry is an indirect reference to the catalog and whose TransformMethod entry is Identity.

}

