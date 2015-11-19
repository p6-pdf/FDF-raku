use v6;

use PDF::DAO::Tie;
use PDF::DAO::Tie::Hash;

# FDF Field definition

role PDF::FDF::Type::Field
    does PDF::DAO::Tie::Hash {

   # See [PDF 1.7 TABLE 8.96 Entries in an FDF field dictionary]

    use PDF::DAO::Tie;

    has Str $.T is entry(:required);   #| (Required) The partial field name
    has $.V is entry;                  #| (Optional) The field’s value, whose format varies depending on the field type

    ## To be completed
}
