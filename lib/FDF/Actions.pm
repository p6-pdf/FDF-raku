use v6;

use PDF::DAO::Tie;
use PDF::DAO::Tie::Hash;

# FDF Actions Dictionary definition

role FDF::Actions
    does PDF::DAO::Tie::Hash {

    # See [PDF 1.7 TABLE 8.100 Entries in an FDF named page reference dictionary]

    use PDF::DAO::Tie;
    use PDF::DAO::Name;
    use PDF::DAO::TextString;

    has PDF::DAO::Name $.Type is entry;         #| (Optional) The type of PDF object that this dictionary describes; if present, must be Action for an action dictionary. 
    has PDF::DAO::Name $.S is entry(:required); #| (Required) The type of action that this dictionary describes; see Table 8.48 on page 653 for specific values.

    my subset ActionOrActions of PDF::DAO where { ($_ ~~ Array && $_[0] ~~ FDF::Actions) || $_ ~~ Hash };
    multi sub coerce(Hash $d, ActionOrActions) {
	PDF::DAO.coerce($d, PDF::DAO::Tie::Hash);
    }
    multi sub coerce(Array $a, ActionOrActions) {
	PDF::DAO.coerce($a[$_], PDF::DAO::Tie::Hash)
	    for $a.keys;
    }

    has ActionOrActions $.Next is entry(:&coerce); #| (Optional; PDF 1.2) The next action or sequence of actions to be performed after the action represented by this dictionary. The value is either a single action dictionary or an array of action dictionaries to be performed in order 

}
