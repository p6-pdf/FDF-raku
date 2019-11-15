use v6;

use PDF::COS::Tie;
use PDF::COS::Tie::Hash;

# FDF Field definition

role FDF::Template
    does PDF::COS::Tie::Hash {

    # See [ PDF 32000 Table 249 - Entries in an FDF template dictionary]
    use PDF::COS::Tie;

    use FDF::TRef;
    has FDF::TRef $.TRef is entry(:required);   # (Required) A named page reference dictionary specifying the location of the template. 
    use FDF::Field;
    has FDF::Field @.Fields is entry;           # (Optional) An array of references to FDF field dictionaries describing the root fields to be imported (those with no ancestors in the field hierarchy). 

    has Bool $.Rename is entry;                 # (Optional) A flag specifying whether fields imported from the template may be renamed in the event of name conflicts with existing fields. Default value: true. 
}
