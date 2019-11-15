use v6;

use PDF::COS::Tie::Hash;

# FDF Field definition

role FDF::Page
    does PDF::COS::Tie::Hash {

    # See [PDF 1.7 TABLE 8.98 Entries in an FDF page dictionary]
    use PDF::COS::Tie;

    use FDF::Template;
    has FDF::Template @.Templates is entry(:required);  #| (Required) An array of FDF template dictionaries describing the named pages that serve as templates on the page. 
    has Hash $.Info is entry;                  #| (Optional) An FDF page information dictionary containing additional information about the page. At the time of publication, no entries have been defined for this dictionary. 
}
