[[Raku PDF Project]](https://pdf-raku.github.io)
 / [FDF](https://pdf-raku.github.io/FDF-raku)
 :: [Dict](https://pdf-raku.github.io/FDF-raku/Dict)

NAME
====

FDF::Dict

DESCRIPTION
===========

This is the main dictionary describing the contents of an FDF (Forms Data Format) file.

METHODS
=======

class PDF::Filespec::File $.F (file)
------------------------------------

Optional) The source file or target file: the PDF document file that this FDF file was exported from or is intended to be imported into.

class Str @.ID
--------------

(Optional) An array of two byte strings constituting a file identifier for the source or target file designated by F, taken from the ID entry in the file’s trailer dictionary

class FDF::Field @.Fields
-------------------------

(Optional) An array of FDF field dictionaries describing the root fields (those with no ancestors in the field hierarchy) to be exported or imported. This entry and the Pages entry may not both be present.

class Str $.Status
------------------

(Optional) A status string to be displayed indicating the result of an action, typically a submit-form action. The string is encoded with PDFDocEncoding.

class FDF::Page @.Pages
-----------------------

(Optional; PDF 1.3) An array of FDF page dictionaries describing new pages to be added to a PDF target document. The Fields and Status entries may not be present together with this entry.

class PDF::COS::Name $.Encoding
-------------------------------

(Optional; PDF 1.3) The encoding to be used for any FDF field value or option (V or Opt in the field dictionary; see Table 246) or field name that is a string and does not begin with the Unicode prefix U+FEFF. Default value: PDFDocEncoding.

class PDF::COS::Stream $.Differences
------------------------------------

(Optional; PDF 1.4) A stream containing all the bytes in all incremental updates made to the underlying PDF document since it was opened (see Section 3.4.5, “Incremental Updates”). If a submit-form action submitting the document to a remote server as FDF #has its IncludeAppendSaves flag set (see “Submit-Form Actions” on page 703), the contents of this stream are included in the submission. This allows any digital signatures (see Section 8.7, “Digital Signatures) to be transmitted to the server. An incremental update is automatically performed just before the submission takes place, in order to capture all changes made to the document. Note that the submission always includes the full set of incremental updates back to the time the document was first opened, even if some of them may already have been included in intervening submissions.

class Str $.Target
------------------

(Optional; PDF 1.4) The name of a browser frame in which the underlying PDF document is to be opened. This mimics the behavior of the target attribute in HTML < href > tags.

class PDF::Filespec::File @.EmbeddedFDFs
----------------------------------------

(Optional; PDF 1.4) An array of file specifications representing other FDF files embedded within this one

class FDF::JavaScript $.JavaScript
----------------------------------

(Optional; PDF 1.4) A JavaScript dictionary

