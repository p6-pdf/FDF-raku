[[Raku PDF Project]](https://pdf-raku.github.io)
 / [FDF](https://pdf-raku.github.io/FDF-raku)
 :: [Catalog](https://pdf-raku.github.io/FDF-raku/Catalog)

NAME
====

FDF::Catalog

DESCRIPTION
===========

The root node of an FDF file’s object hierarchy is the Catalog dictionary, located by means of the Root entry in the file’s trailer dictionary (FDF). The only required entry in the catalogue is FDF - an FDF dictionary [FDF::Dict](https://pdf-raku.github.io/FDF-raku/Dict), which in turn contains references to other objects describing the file’s contents. The catalogue may also contain an optional Version entry identifying the version of the PDF specification to which this FDF file conforms.

METHODS
=======

class PDF::COS::Name $.Version
------------------------------

(Optional; PDF 1.4) The version of the PDF specification to which the document conforms (for example, 1.)

class FDF::Dict $.FDF
---------------------

(Required) The FDF dictionary for this file

