use v6;

use PDF::DAO::Tie;
use PDF::DAO::Tie::Hash;

# FDF Annot Dictionary definition

my role JavaScript
    does PDF::DAO::Tie::Hash {

    # See [PDF 1.7 TABLE TABLE 8.95 Entries in the JavaScript dictionary]

    use PDF::DAO::Tie;
    use PDF::DAO::ByteString;
    use PDF::DAO::Stream;

    my subset TextOrStream of PDF::DAO where PDF::DAO::ByteString | PDF::DAO::Stream;

    has TextOrStream $.Before is entry; #| (Optional) A text string or text stream containing a JavaScript script to be executed just before the FDF file is imported.
    has TextOrStream $.After is entry;  #| (Optional) A text string or text stream containing a JavaScript script to be executed just after the FDF file is imported.
    has TextOrStream $.AfterPermsReady is entry;  #| (Optional; PDF 1.6) A text string or text stream containing a JavaScript script to be executed after the FDF file is imported and the usage rights in the PDF document have been determined.
    #| Note: Verification of usage rights requires the entire file to be present, in which case this script defers execution until that requirement is met.

    # to be completed

}

role PDF::FDF::Type::JavaScript does JavaScript {}

