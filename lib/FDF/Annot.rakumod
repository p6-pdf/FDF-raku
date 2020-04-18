use v6;

use PDF::COS::Tie;
use PDF::COS::Tie::Hash;

# FDF Annot Dictionary definition

role FDF::Annot
    does PDF::COS::Tie::Hash {

    # See [PDF-32000 Table 251 – Additional entry for annotation dictionaries in an FDF file]

    # Note PDF::Class::Loader will subclass this as type PDF::Annot and possibly PDF::Field

    use PDF::COS::Tie;
    has UInt $.Page is entry;  # (Required for annotations in FDF files) The ordinal page number on which this annotation should appear, where page 0 is the first page.

}

