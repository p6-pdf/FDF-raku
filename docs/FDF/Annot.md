NAME
====

FDF::Annot

DESCRIPTION
===========

Annotation dictionaries in an FDF file are of an appropriate PDF::Annot subclass (e.g. PDF::Annot::Widget). They also mix-in this role (FDF::Annot) which includes a `Page` entry indicating the page of the source document to which the annotation is attached.

class UInt $.Page
-----------------

(Required for annotations in FDF files) The ordinal page number on which this annotation should appear, where page 0 is the first page.

