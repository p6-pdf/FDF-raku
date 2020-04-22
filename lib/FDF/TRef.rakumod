use v6;

use PDF::COS::Tie;
use PDF::COS::Tie::Hash;

# FDF Field definition

role FDF::TRef
    does PDF::COS::Tie::Hash {

    # See [PDF 32000 Table 250 - Entries in an FDF named page reference dictionary]

    use PDF::COS::Tie;
    use PDF::COS::Name;
    use PDF::Filespec :File, :&to-file;

    has PDF::COS::Name $.Name is entry(:required);            #| (Required) The name of the referenced page. 
    has File $.F is entry(:alias<file>, :coerce(&to-file));   #| (Optional) The file containing the named page. If this entry is absent, it is assumed that the page resides in the associated PDF file. 
}
