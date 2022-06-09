[[Raku PDF Project]](https://pdf-raku.github.io)
 / [[FDF Module]](https://pdf-raku.github.io/FDF-raku)
 / [FDF](https://pdf-raku.github.io/FDF-raku/FDF)
 :: [NamedPageRef](https://pdf-raku.github.io/FDF-raku/FDF/NamedPageRef)

role FDF::NamedPageRef
======================

Description
-----------

a named page reference dictionary that describes the location of external templates or page elements

Methods
-------

class PDF::COS::ByteString $.Name
---------------------------------

(Required) The name of the referenced page.

class PDF::Filespec::FileRef $.F (file)
---------------------------------------

(Optional) The file containing the named page. If this entry is absent, it is assumed that the page resides in the associated PDF file.

