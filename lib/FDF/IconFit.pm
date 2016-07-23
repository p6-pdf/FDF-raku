use v6;

use PDF::DAO::Tie;
use PDF::DAO::Tie::Hash;

# FDF Appearance Dictionary definition

role FDF::IconFit
    does PDF::DAO::Tie::Hash {

    # See [PDF 1.7 TABLE 8.100 Entries in an FDF named page reference dictionary]

    use PDF::DAO::Tie;
    use PDF::DAO::Name;
    use PDF::DAO::TextString;

    my subset SWVal of PDF::DAO::Name where 'A' | 'B' | 'S' | 'N';
    has SWVal $.SW is entry;     #| (Optional) The circumstances under which the icon should be scaled inside the annotation rectangle:
    #| A: Always scale.
    #| B: Scale only when the icon is bigger than the annotation rectangle.
    #| S: Scale only when the icon is smaller than the annotation rectangle.
    #| N: Never scale.
    #| Default value: A. 

    my subset ArrayOfTextStrings of Array where { !.first( !*.isa(PDF::DAO::TextString) ) }
    my subset IconFitOption of Any where ArrayOfTextStrings | PDF::DAO::TextString;
    multi sub coerce(Str $s is rw, IconFitOption) {
	PDF::DAO.coerce($s, PDF::DAO::TextString)
    }
    multi sub coerce(Array $a is rw, IconFitOption) {
	for $a.keys {
	    PDF::DAO.coerce( $a[$_],  PDF::DAO::TextString)
	}
    }

    has IconFitOption $.V is entry(:&coerce, :inherit);
    has IconFitOption $.DV is entry(:&coerce, :inherit);

    has IconFitOption @.Opt is entry(:&coerce);  #| (Required; choice fields only) An array of options to be presented to the user. Each element of the array can take either of two forms:
    #| • A text string representing one of the available options
    #| • A two-element array consisting of a text string representing one of the available options and a default appearance string for constructing the item’s appearance dynamically at viewing time

    has Numeric @.A is entry(:len(2));           #| (Optional) An array of two numbers between 0.0 and 1.0 indicating the fraction of leftover space to allocate at the left and bottom of the icon. A value of [0.0 0.0] positions the icon at the bottom-left corner of the annotation rectangle. A value of [0.5 0.5] centers it within the rectangle. This entry is used only if the icon is scaled proportionally. Defaultvalue: [0.5 0.5]. 

    has Bool $.FB;                               #| (Optional; PDF 1.5) If true, indicates that the button appearance should be scaled to fit fully within the bounds of the annotation without taking into consideration the line width of the border. Default value: false.

}
