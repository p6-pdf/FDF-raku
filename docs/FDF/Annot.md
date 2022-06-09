[[Raku PDF Project]](https://pdf-raku.github.io)
 / [[FDF Module]](https://pdf-raku.github.io/FDF-raku)
 / [FDF](https://pdf-raku.github.io/FDF-raku/FDF)
 :: [Annot](https://pdf-raku.github.io/FDF-raku/FDF/Annot)

role FDF::Annot
===============

Description
-----------

Annotation dictionaries in an FDF file are of an appropriate [PDF::Annot](https://pdf-raku.github.io/PDF-Class-raku) subclass (e.g. [PDF::Annot::Widget](https://pdf-raku.github.io/PDF-Class-raku)). They also mix-in this role (FDF::Annot) which includes a `Page` entry indicating the page of the source document to which the annotation is attached.

Methods
-------

class UInt $.Page
-----------------

(Required for annotations in FDF files) The ordinal page number on which this annotation should appear, where page 0 is the first page.

### method page-number

```raku
method page-number() returns UInt
```

Note that the raw `$.Page` entry starts at page 0. This is an alternative rw accessor that starts at page 1.

