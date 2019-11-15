use v6;

use PDF::COS::Tie::Hash;

# FDF Actions Dictionary definition

role FDF::Actions
    does PDF::COS::Tie::Hash {

    # See [PDF 1.7 TABLE 8.100 Entries in an FDF named page reference dictionary]

    use PDF::COS::Tie;
    use PDF::COS::Name;
    use PDF::COS::TextString;

    has PDF::COS::Name $.Type is entry;         # (Optional) The type of PDF object that this dictionary describes; if present, must be Action for an action dictionary.
    has PDF::COS::Name $.S is entry(:required); # (Required) The type of action that this dictionary describes; see Table 8.48 on page 653 for specific values.

    has Hash @.Next is entry(:array-or-item);   # (Optional; PDF 1.2) The next action or sequence of actions to be performed after the action represented by this dictionary. The value is either a single action dictionary or an array of action dictionaries to be performed in order 

}
