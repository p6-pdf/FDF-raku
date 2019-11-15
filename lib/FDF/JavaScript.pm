use v6;

use PDF::COS::Tie;
use PDF::COS::Tie::Hash;

# FDF Annot Dictionary definition

role FDF::JavaScript
    does PDF::COS::Tie::Hash {

    # See [PDF 1.7 TABLE TABLE 8.95 Entries in the JavaScript dictionary]

    use PDF::COS::Tie;
    use PDF::COS::ByteString;
    use PDF::COS::Stream;

    my subset TextOrStream where PDF::COS::ByteString | PDF::COS::Stream;

    has TextOrStream $.Before is entry; #| (Optional) A text string or text stream containing a JavaScript script to be executed just before the FDF file is imported.
    has TextOrStream $.After is entry;  #| (Optional) A text string or text stream containing a JavaScript script to be executed just after the FDF file is imported.
    has TextOrStream $.AfterPermsReady is entry;  #| (Optional; PDF 1.6) A text string or text stream containing a JavaScript script to be executed after the FDF file is imported and the usage rights in the PDF document have been determined.
    #| Note: Verification of usage rights requires the entire file to be present, in which case this script defers execution until that requirement is met.

    # to be completed

}
