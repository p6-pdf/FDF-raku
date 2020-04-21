use v6;

use PDF::COS::Tie::Hash;

# FDF Top level dictionary

role FDF::Dict
    does PDF::COS::Tie::Hash {

   # See [PDF 32000 Table 243 – Entries in the FDF dictionary]

    use PDF::COS;
    use PDF::COS::Tie;
    use PDF::Filespec :File, :&to-file;
    use PDF::Annot;

    use FDF::Annot;
    use FDF::Field;
    use FDF::Page;

    has File $.F is entry(:alias<file>, :coerce(&to-file));                         # Optional) The source file or target file: the PDF document file that this FDF file was exported from or is intended to be imported into.

    has Str @.ID is entry(:len(2));               # (Optional) An array of two byte strings constituting a file identifier for the source or target file designated by F, taken from the ID entry in the file’s trailer dictionary

    has FDF::Field @.Fields is entry;  # (Optional) An array of FDF field dictionaries describing the root fields (those with no ancestors in the field hierarchy) to be exported or imported. This entry and the Pages entry may not both be present.
    method fields {
	my @fields;
        my $flds = self.Fields;
	for $flds.keys {
	    @fields.append( $flds[$_].fields )
	}
	@fields;
    }

    has Str $.Status is entry;                    # (Optional) A status string to be displayed indicating the result of an action, typically a submit-form action on page 703). The string is encoded with PDFDocEncoding. 

    has FDF::Page @.Pages is entry;    # (Optional; PDF 1.3) An array of FDF page dictionaries  describing new pages to be added to a PDF target document. The Fields and Status entries may not be present together with this entry.

    has PDF::COS::Name $.Encoding is entry;      # (Optional; PDF 1.3) The encoding to be used for any FDF field value or option (V or Opt in the field dictionary; see Table 8.96 on page 717) or field name that is a string and does not begin with the Unicode prefix U+FEFF. Default value: PDFDocEncoding.

    sub coerce-annot(PDF::Annot $_, FDF::Annot) {
        FDF::Annot.coerce($_);
    }
    has FDF::Annot @.Annots is entry(:coerce(&coerce-annot)); # Optional; PDF 1.3) An array of FDF annotation dictionaries

    has PDF::COS::Stream $.Differences is entry; # (Optional; PDF 1.4) A stream containing all the bytes in all incremental updates made to the underlying PDF document since it was opened (see Section 3.4.5, “Incremental Updates”). If a submit-form action submitting the document to a remote server as FDF has its IncludeAppendSaves flag set (see “Submit-Form Actions” on page 703), the contents of this stream are included in the submission. This allows any digital signatures (see Section 8.7, “Digital Signatures) to be transmitted to the server. An incremental update is automatically performed just before the submission takes place, in order to capture all changes made to the document. Note that the submission always includes the full set of incremental updates back to the time the document was first opened, even if some of them may already have been included in intervening submissions.
    # Note: Although a Fields or Annots entry (or both) may be present along with Differences, there is no guarantee that their contents will be consistent with it. In particular, if Differences contains a digital signature, only the values of the form fields given in the Differences stream can be considered trustworthy under that signature.

    has Str $.Target is entry;                   # (Optional; PDF 1.4) The name of a browser frame in which the underlying PDF document is to be opened. This mimics the behavior of the target attribute in HTML < href > tags.

    has File @.EmbeddedFDFs is entry(:coerce(&to-file));             # (Optional; PDF 1.4) An array of file specifications representing other FDF files embedded within this one

    use FDF::JavaScript;
    has FDF::JavaScript $.JavaScript is entry; # (Optional; PDF 1.4) A JavaScript dictionary
}
