use PDF::COS::Tie::Hash;

# FDF Annot Dictionary definition

role FDF::Annot
    does PDF::COS::Tie::Hash {

    # See [PDF-32000 Table 251 – Additional entry for annotation dictionaries in an FDF file]

    use PDF::COS::Tie;
    use PDF::Class::Defs :AnnotLike;

    has UInt $.Page is entry;  #| (Required for annotations in FDF files) The ordinal page number on which this annotation should appear, where page 0 is the first page.

    multi method coerce(AnnotLike $dict)   { PDF::COS.coerce($dict, FDF::Annot) }
}

