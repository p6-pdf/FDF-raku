use PDF::COS::Tie::Hash;

=begin pod
=head1 NAME

FDF::Annot

=head1 DESCRIPTION

Annotation dictionaries in an FDF file are of an appropriate PDF::Annot subclass (e.g. PDF::Annot::Widget). They also mix-in this role (FDF::Annot) which includes a `Page` entry indicating the page of the source document to which the annotation is attached.

=end pod

role FDF::Annot
    does PDF::COS::Tie::Hash {

    # See [PDF-32000 Table 251 – Additional entry for annotation dictionaries in an FDF file]

    use PDF::COS::Tie;
    use PDF::Class::Defs :AnnotLike;

    #| (Required for annotations in FDF files) The ordinal page number on which this annotation should appear, where page 0 is the first page.
    has UInt $.Page is entry;

    multi method coerce(AnnotLike $dict)   { PDF::COS.coerce($dict, FDF::Annot) }
}

