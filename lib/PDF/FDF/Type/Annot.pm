use v6;

use PDF::DAO::Tie;
use PDF::DAO::Tie::Hash;

# FDF Annot Dictionary definition

my role Annot
    does PDF::DAO::Tie::Hash {

    # See [PDF 1.7 TABLE (Required for annotations in FDF files) The ordinal page number on which this annotation should appear, where page 0 is the first page.]

    # Note PDF::DOM::Delegator will subclass this as type PDF::DOM::Type::Annot

    use PDF::DAO::Tie;
    has UInt $.Page is entry;  #| (Required for annotations in FDF files) The ordinal page number on which this annotation should appear, where page 0 is the first page.

}

role PDF::FDF::Type::Annot does Annot {}

