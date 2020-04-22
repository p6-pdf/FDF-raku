use v6;

=begin pod
=head1 NAME

FDF::IconFit

=head1 DESCRIPTION

The Icon Fit dictionary specifies how to display the button’s icon within the annotation rectangle of its widget annotation

=head1 METHODS
=end pod

use PDF::COS::Tie::Hash;

role FDF::IconFit
    does PDF::COS::Tie::Hash {

    # See [PDF 32000 - Table 247 – Entries in an icon fit dictionary]

    use PDF::COS::Tie;
    use PDF::COS::Name;
    use PDF::COS::TextString;

    my subset SWVal of PDF::COS::Name where 'A' | 'B' | 'S' | 'N';
    has SWVal $.SW is entry( :default<A>);     #| (Optional) The circumstances under which the icon should be scaled inside the annotation rectangle:
    # A: Always scale.
    # B: Scale only when the icon is bigger than the annotation rectangle.
    # S: Scale only when the icon is smaller than the annotation rectangle.
    # N: Never scale.
    # Default value: A.
    my subset SVal of PDF::COS::Name where 'A' | 'P';
    # A: Anamorphic scaling: Scale the icon to fill the annotation rectangle exactly,
    #    without regard to its original aspect ratio (ratio of width to height).
    # P: Proportional scaling: Scale the icon to fit the width or height of the annotation
    #    rectangle while maintaining the icon’s original aspect ratio. If the required
    #    horizontal and vertical scaling factors are different, use the smaller of the two,
    #    centering the icon within the annotation rectangle in the other dimension.
    # Default value: P.
    has SVal $.S is entry( :default<P>);  #| (Optional) The type of scaling that shall be used:

    has Numeric @.A is entry(:len(2));           #| (Optional) An array of two numbers between 0.0 and 1.0 indicating the fraction of leftover space to allocate at the left and bottom of the icon. A value of [0.0 0.0] positions the icon at the bottom-left corner of the annotation rectangle. A value of [0.5 0.5] centers it within the rectangle. This entry is used only if the icon is scaled proportionally. Defaultvalue: [0.5 0.5]. 

    has Bool $.FB;                               #| (Optional; PDF 1.5) If true, indicates that the button appearance should be scaled to fit fully within the bounds of the annotation without taking into consideration the line width of the border. Default value: false.

}
