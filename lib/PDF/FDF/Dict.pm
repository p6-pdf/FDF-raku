use v6;

use PDF::DAO::Tie;
use PDF::DAO::Tie::Hash;
use PDF::FDF::Type::Field;
use PDF::FDF::Type::Page;

# FDF Top level dictionary

my role Dict
    does PDF::DAO::Tie::Hash {

   # See [PDF 1.7 TABLE 8.93 Entries in the FDF dictionary]

    use PDF::DAO::Tie;

    has Str $.F is entry;                         #| Optional) The source file or target file: the PDF document file that this FDF file was exported from or is intended to be imported into.
    has Str @.ID is entry(:len(2));               #| (Optional) An array of two byte strings constituting a file identifier (see Section 10.3, “File Identifiers”) for the source or target file designated by F, taken from the ID entry in the file’s trailer dictionary

    has PDF::FDF::Type::Field @.Fields is entry;  #| (Optional) An array of FDF field dictionaries describing the root fields (those with no ancestors in the field hierarchy) to be exported or imported. This entry and the Pages entry may not both be present.
    method fields { flat @.Fields.map: *.fields }

    # To be completed
    has Str $.Status is entry;                    #| (Optional) A status string to be displayed indicating the result of an action, typically a submit-form action on page 703). The string is encoded with PDFDocEncoding. 

    has PDF::FDF::Type::Page @.Pages is entry;    #| (Optional; PDF 1.3) An array of FDF page dictionaries  describing new pages to be added to a PDF target document. The Fields and Status entries may not be present together with this entry. 
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

role PDF::FDF::Dict does Dict {};
