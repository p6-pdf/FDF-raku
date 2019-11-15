use v6;

use PDF::COS::Tie;
use PDF::COS::Tie::Hash;

# FDF Field definition

role FDF::TRef
    does PDF::COS::Tie::Hash {

    # See [PDF 1.7 TABLE 8.100 Entries in an FDF named page reference dictionary]

    use PDF::COS::Tie;
    use PDF::COS::Name;

    has PDF::COS::Name $.Name is entry(:required);  #| (Required) The name of the referenced page. 
    has Str $.F is entry;                           #| (Optional) The file containing the named page. If this entry is absent, it is assumed that the page resides in the associated PDF file. 
}
