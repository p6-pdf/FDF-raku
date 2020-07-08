use PDF::COS::Tie::Hash;

=begin pod
=head1 NAME

FDF::Annot

=head1 DESCRIPTION

Annotation dictionaries in an FDF file are of an appropriate L<PDF::Annot> subclass (e.g. L<PDF::Annot::Widget>). They also mix-in this role (FDF::Annot) which includes a `Page` entry indicating the page of the source document to which the annotation is attached.

=head1 METHODS
=end pod

role FDF::Annot
    does PDF::COS::Tie::Hash {

    # See [PDF-32000 Table 251 – Additional entry for annotation dictionaries in an FDF file]

    use PDF::COS::Tie;
    use PDF::Class::Defs :AnnotLike;

    #| (Required for annotations in FDF files) The ordinal page number on which this annotation should appear, where page 0 is the first page.
    has UInt $.Page is entry;

    #| Note that the raw `$.Page` entry starts at page 0. This is an alternative rw accessor that starts at page 1.
    method page-number is rw returns UInt {
        Proxy.new(
            FETCH => { self.Page + 1},
            STORE => -> $, UInt() $_ {
                self.Page = $_ - 1;
            }
        )
    }

    multi method coerce(AnnotLike $dict)   { PDF::COS.coerce($dict, FDF::Annot) }
}

