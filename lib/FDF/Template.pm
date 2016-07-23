use v6;

use PDF::DAO::Tie;
use PDF::DAO::Tie::Hash;

# FDF Field definition

role FDF::Template
    does PDF::DAO::Tie::Hash {

    # See [ PDF 1.7 TABLE 8.99 Entries in an FDF template dictionary]
    use PDF::DAO::Tie;

    has Hash $.TRef is entry(:required);   #| (Required) A named page reference dictionary specifying the location of the template. 
    use FDF::Field;
    has FDF::Field @.Fields is entry;  #| (Optional) An array of references to FDF field dictionaries describing the root fields to be imported (those with no ancestors in the field hierarchy). 

    has Bool $.Rename is entry;            #| (Optional) A flag specifying whether fields imported from the template may be renamed in the event of name conflicts with existing fields. Default value: true. 
}
