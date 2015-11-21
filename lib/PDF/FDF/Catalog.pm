use v6;

use PDF::DAO::Tie::Hash;

# See [PDF 1.7 TABLE 8.92 Entries in the FDF catalog dictionary]

role Catalog
    does PDF::DAO::Tie::Hash {

    use PDF::DAO::Tie;

    # see [PDF 1.7 TABLE 3.25 Entries in the catalog dictionary]
    use PDF::DAO::Tie::Hash;
    use PDF::DAO::Name;

    has PDF::DAO::Name $.Version is entry;         #| (Optional; PDF 1.4) The version of the PDF specification to which the document conforms (for example, 1.4)y

    use PDF::FDF::Dict;
    has PDF::FDF::Dict $.FDF is entry(:required);  #| (Required) The FDF dictionary for this file

    has Hash $.Sig is entry;                       #| (Optional; PDF 1.5) A signature dictionary indicating that the document is signed using an object digest (see Section 8.7, “Digital Signatures”). This dictionary must contain a signature reference dictionary whose Data entry is an indirect reference to the catalog and whose TransformMethod entry is Identity.

    has Str $.F is entry;                          #| (Optional; PDF 1.5) A signature dictionary indicating that the document is signed using an object digest (see Section 8.7, “Digital Signatures”). This dictionary must contain a signature reference dictionary whose Data entry is an indirect reference to the catalog and whose TransformMethod entry is Identity.

    has Str @.ID is entry(:len(2));                #| (Optional; PDF 1.5) A signature dictionary indicating that the document is signed using an object digest (see Section 8.7, “Digital Signatures”). This dictionary must contain a signature reference dictionary whose Data entry is an indirect reference to the catalog and whose TransformMethod entry is Identity.

    use PDF::FDF::Type::Field;
    has PDF::FDF::Type::Field @.Fields is entry;  #| (Optional; PDF 1.5) A signature dictionary indicating that the document is signed using an object digest (see Section 8.7, “Digital Signatures”). This dictionary must contain a signature reference dictionary whose Data entry is an indirect reference to the catalog and whose TransformMethod entry is Identity.

    has Str $.Status is entry;                    #| (Optional) A status string to be displayed indicating the result of an action, typically a submit-form action (see “Submit-Form Actions” on page 703). The string is encoded with PDFDocEncoding. (See implementation note 128 in Appendix H.) This entry and the Pagesentry may not both be present.

    use PDF::FDF::Type::Page;
    has PDF::FDF::Type::Page @.Pages is entry;   #| (Optional; PDF 1.3) An array of FDF page dictionaries describing new pages to be added to a PDF target document. The Fields and Status entries may not be present together with this entry.

    has PDF::DAO::Name $.Encoding is entry;      #| (Optional; PDF 1.3) The encoding to be used for any FDF field value or option (V or Opt in the field dictionary; see Table 8.96 on page 717) or field name that is a string and does not begin with the Unicode prefix U+FEFF. Default value: PDFDocEncoding.

    use PDF::FDF::Type::Annot;
    has PDF::FDF::Type::Annot @.Annots is entry; #| Optional; PDF 1.3) An array of FDF annotation dictionaries

    has PDF::DAO::Stream $.Differences is entry; #| (Optional; PDF 1.4) A stream containing all the bytes in all incremental updates made to the underlying PDF document since it was opened (see Section 3.4.5, “Incremental Updates”). If a submit-form action submitting the document to a remote server as FDF has its IncludeAppendSaves flag set (see “Submit-Form Actions” on page 703), the contents of this stream are included in the submission. This allows any digital signatures (see Section 8.7, “Digital Signatures) to be transmitted to the server. An incremental update is automatically performed just before the submission takes place, in order to capture all changes made to the document. Note that the submission always includes the full set of incremental updates back to the time the document was first opened, even if some of them may already have been included in intervening submissions.
    #| Note: Although a Fields or Annots entry (or both) may be present along with Differences, there is no guarantee that their contents will be consistent with it. In particular, if Differences contains a digital signature, only the values of the form fields given in the Differences stream can be considered trustworthy under that signature.

    has Str $.Target is entry;                   #| (Optional; PDF 1.4) The name of a browser frame in which the underlying PDF document is to be opened. This mimics the behavior of the target attribute in HTML < href > tags.

    has Str @.EmbeddedFDFs is entry;             #| (Optional; PDF 1.4) An array of file specifications (see Section 3.10, “File Specifications”) representing other FDF files embedded within this one

    use PDF::FDF::Type::JavaScript;
    has PDF::FDF::Type::JavaScript $.JavaScript is entry; #| (Optional; PDF 1.4) A JavaScript dictionary
}

role PDF::FDF::Catalog does Catalog {}
