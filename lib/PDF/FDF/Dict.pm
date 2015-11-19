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

    # To be completed
    has Str $.Status is entry;                    #| (Optional) A status string to be displayed indicating the result of an action, typically a submit-form action on page 703). The string is encoded with PDFDocEncoding. 

    has PDF::FDF::Type::Page @.Pages is entry;    #| (Optional; PDF 1.3) An array of FDF page dictionaries  describing new pages to be added to a PDF target document. The Fields and Status entries may not be present together with this entry. 
}

role PDF::FDF::Dict does Dict {};
