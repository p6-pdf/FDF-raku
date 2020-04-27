FDF-raku
========

A Raku module for the creation and manipulation of FDF (Form Data Format)
files, including PDF export and import.

SYNOPSIS
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
$fdf.export-from: $pdf, :%fill;

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
$fdf.import-to: $pdf;

# save updated fields
$pdf.update;

```

Description
----------
FDF (Form Data Format) is a format for storing form data and formatting or
annotations seperately from PDF files.


Classes/Roles in this Distribution
-------

- [FDF](https://pdf-raku.github.io/FDF-raku/FDF) - FDF file
- [FDF::Annot](https://pdf-raku.github.io/FDF-raku/FDF/Annot) - FDF Annotations
- [FDF::Catalog](https://pdf-raku.github.io/FDF-raku/FDF/Catalog) - FDF Catalog
- [FDF::Dict](https://pdf-raku.github.io/FDF-raku/FDF/Dict) - FDF Main Dictionary
- [FDF::Field](https://pdf-raku.github.io/FDF-raku/FDF/Field) - FDF Fields
- [FDF::IconFit](https://pdf-raku.github.io/FDF-raku/FDF/IconFit) - FDF IconFits
- [FDF::JavaScript](https://pdf-raku.github.io/FDF-raku/FDF/JavaScript) - FDF JavaScripts
- [FDF::NamedPageRef](https://pdf-raku.github.io/FDF-raku/FDF/NamedPageRef) - FDF Named Page References
- [FDF::Page](https://pdf-raku.github.io/FDF-raku/FDF/Page) - FDF Pages to be added
- [FDF::Template](https://pdf-raku.github.io/FDF-raku/FDF/Template) - FDF Page Templates



BUGS AND LIMITATIONS
----
Not yet handled:

- Form signing and signature manipulation
- Import/export of annotations and pages
- Custom encodings (`/Encoding` entry in the FDF dictionary)
