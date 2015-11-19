use v6;

use PDF::DAO::Tie;
use PDF::DAO::Tie::Hash;

# FDF Field definition

my role TRef
    does PDF::DAO::Tie::Hash {

    # See [PDF 1.7 TABLE 8.100 Entries in an FDF named page reference dictionary]

    use PDF::DAO::Tie;
    use PDF::DAO::Name;

    has PDF::DAO::Name $.Name is entry(:required);  #| (Required) The name of the referenced page. 
    has Str $.F is entry;                           #| (Optional) The file containing the named page. If this entry is absent, it is assumed that the page resides in the associated PDF file. 
}

role PDF::FDF::Type::TRef does TRef {}
