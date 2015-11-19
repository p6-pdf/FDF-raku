use v6;

use PDF::DAO::Tie;
use PDF::DAO::Tie::Hash;

# FDF Field definition

my role Page
    does PDF::DAO::Tie::Hash {

    # See [PDF 1.7 TABLE 8.98 Entries in an FDF page dictionary]
    use PDF::DAO::Tie;

    use PDF::FDF::Type::Template;
    has PDF::FDF::Type::Template @.Templates is entry(:required);  #| (Required) An array of FDF template dictionaries describing the named pages that serve as templates on the page. 
    has Hash $.Info is entry;                  #| (Optional) An FDF page information dictionary containing additional information about the page. At the time of publication, no entries have been defined for this dictionary. 
}

role PDF::FDF::Type::Page does Page {}
