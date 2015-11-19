use v6;

use PDF::DAO::Tie;
use PDF::DAO::Tie::Hash;
use PDF::FDF::Type::Field;

# FDF Top level dictionary

role PDF::FDF::Dict
    does PDF::DAO::Tie::Hash {

    use PDF::DAO::Tie;

    has Str $.F is entry;                 #| Optional) The source file or target file: the PDF document file that this FDF file was exported from or is intended to be imported into.
    has Str @.ID is entry(:len(2));       #| (Optional) An array of two byte strings constituting a file identifier (see Section 10.3, “File Identifiers”) for the source or target file designated by F, taken from the ID entry in the file’s trailer dictionary

    has PDF::FDF::Type::Field @.Fields is entry;           #| (Optional) An array of FDF field dictionaries describing the root fields (those with no ancestors in the field hierarchy) to be exported or imported. This entry and the Pages entry may not both be present.

    # To be completed
}
