[[Raku PDF Project]](https://pdf-raku.github.io)
 / [FDF](https://pdf-raku.github.io/FDF-raku)
 :: [NamedPageRef](https://pdf-raku.github.io/FDF-raku/NamedPageRef)

NAME
====

FDF::NamedPageRef

DESCRIPTION
===========

a named page reference dictionary that describes the location of external templates or page elements

METHODS
=======

class PDF::COS::ByteString $.Name
---------------------------------

(Required) The name of the referenced page.

class PDF::Filespec::File $.F (file)
------------------------------------

(Optional) The file containing the named page. If this entry is absent, it is assumed that the page resides in the associated PDF file.

