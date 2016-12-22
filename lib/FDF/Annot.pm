use v6;

use PDF::DAO::Tie;
use PDF::DAO::Tie::Hash;

# FDF Annot Dictionary definition

role FDF::Annot
    does PDF::DAO::Tie::Hash {

    # See [PDF 1.7 TABLE (Required for annotations in FDF files) The ordinal page number on which this annotation should appear, where page 0 is the first page.]

    # Note PDF::Doc::Delegator will subclass this as type PDF::Annot

    use PDF::DAO::Tie;
    has UInt $.Page is entry;  #| (Required for annotations in FDF files) The ordinal page number on which this annotation should appear, where page 0 is the first page.

}

