use v6;

use PDF::COS::Tie;
use PDF::COS::Tie::Hash;

# FDF Annot Dictionary definition

role FDF::Annot
    does PDF::COS::Tie::Hash {

    # See [PDF 1.7 TABLE (Required for annotations in FDF files) The ordinal page number on which this annotation should appear, where page 0 is the first page.]

    # Note PDF::Class::Loader will subclass this as type PDF::Annot

    use PDF::COS::Tie;
    has UInt $.Page is entry;  #| (Required for annotations in FDF files) The ordinal page number on which this annotation should appear, where page 0 is the first page.

}

