[[Raku PDF Project]](https://pdf-raku.github.io)
 / [FDF](https://pdf-raku.github.io/FDF-raku)

FDF-raku
========

A Raku module for the creation and manipulation of FDF (Form Data Format)
files, including PDF export and import.

Classes/Roles in this Distribution
-------

- [FDF](https://pdf-raku.github.io/FDF-raku) - FDF file
- [FDF::Annot](https://pdf-raku.github.io/FDF-raku/Annot) - FDF Annotations
- [FDF::Catalog](https://pdf-raku.github.io/FDF-raku/Catalog) - FDF Catalog
- [FDF::Dict](https://pdf-raku.github.io/FDF-raku/Dict) - FDF Main Dictionary
- [FDF::Field](https://pdf-raku.github.io/FDF-raku/Field) - FDF Fields
- [FDF::IconFit](https://pdf-raku.github.io/FDF-raku/IconFit) - FDF IconFits
- [FDF::JavaScript](https://pdf-raku.github.io/FDF-raku/JavaScript) - FDF JavaScripts
- [FDF::NamedPageRef](https://pdf-raku.github.io/FDF-raku/NamedPageRef) - FDF Named Page References
- [FDF::Page](https://pdf-raku.github.io/FDF-raku/Page) - FDF Pages to be added
- [FDF::Template](https://pdf-raku.github.io/FDF-raku/Template) - FDF Page Templates


Synopsis
--------

### Export fields from a PDF to an FDF
```
use PDF::Class;
use FDF;
my PDF::Class $pdf .= open: "PDF-With-Fields.pdf";
my FDF $fdf .= new;

# fill the email field, overriding PDF value
my %fill = :email<david.warring@gmail.com>;

# populate form data from the PDF
$fdf.merge: :from($pdf), :%fill;

note "saving fields :-"
for $fdf.field-hash.sort {
    note " - {.key}: {.value.perl}";
}

$fdf.save-as: "PDF-With-Fields.fdf";
```


### Import field data from an FDF to a PDF
```
use PDF::Class;
use FDF;
my PDF::Class $pdf .= open: "PDF-With-Fields.pdf";
my FDF $fdf .= open: "PDF-With-Fields.fdf";

# populate form data from the PDF
$fdf.merge: :to($pdf);

# save updated fields
$pdf.update;

```

Description
----------
FDF (Form Data Format) is a format for storing form data and formatting or
annotations seperately from PDF files.


Bugs and Limitations
----
Not yet handled:

- Form signing and signature manipulation
- Import/export of annotations and pages
- Custom encodings (`/Encoding` entry in the FDF dictionary)

<hr/>

class FDF (Form Data Format)
============================

Description
-----------

The trailer of an FDF file enables a reader to find significant objects quickly within the body of the file. The only required key is Root, whose value is an indirect reference to the file’s catalogue dictionary (see Table 242). The trailer may optionally contain additional entries for objects that are referenced from within the catalogue.

Methods
-------

This class inherits from [PDF](https://pdf-raku.github.io/PDF-raku) and has most its methods available, including: `new`, `open`, `save-as`, `update`, `Str` and `Blob`.

Note that `encrypt` is not applicable to FDF files.

class FDF::Catalog $.Root (catalog)
-----------------------------------

(Required; shall be an indirect reference) The Catalog object for this FDF file

