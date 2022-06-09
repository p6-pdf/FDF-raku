use v6;

=begin pod

=head1 role FDF::NamedPageRef

=head2 Description

a named page reference dictionary that describes
the location of external templates or page elements

=head2 Methods
=end pod

use PDF::COS::Tie::Hash;

role FDF::NamedPageRef
    does PDF::COS::Tie::Hash {

    # See [PDF 32000 Table 250 - Entries in an FDF named page reference dictionary]

    use PDF::COS::Tie;
    use PDF::COS::ByteString;
    use PDF::Filespec :FileRef, :&to-file;

    #| (Required) The name of the referenced page.
    has PDF::COS::ByteString $.Name is entry(:required);
    #| (Optional) The file containing the named page. If this entry is absent, it is assumed that the page resides in the associated PDF file. 
    has FileRef $.F is entry(:alias<file>, :coerce(&to-file));
}
