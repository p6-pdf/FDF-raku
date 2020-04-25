NAME
====

FDF (Form Data Format) Trailer Dictionary

DESCRIPTION
===========

The trailer of an FDF file enables a reader to find significant objects quickly within the body of the file. The only required key is Root, whose value is an indirect reference to the file’s catalogue dictionary (see Table 242). The trailer may optionally contain additional entries for objects that are referenced from within the catalogue.

METHODS
=======

This class inherits from [PDF](PDF) and has most its methods available, including: `new`, `open`, `save-as`, `update`, `Str` and `Blob`.

Note that `encrypt` is not applicable to FDF files.

class FDF::Catalog $.Root (catalog)
-----------------------------------

(Required; shall be an indirect reference) The Catalog object for this FDF file

