[[Raku PDF Project]](https://pdf-raku.github.io)
 / [[FDF Module]](https://pdf-raku.github.io/FDF-raku)

FDF-raku
========

A Raku module for the creation and manipulation of FDF (Form Data Format)
files, including PDF export and import.

Classes/Roles in this Distribution
-------

- [FDF](https://pdf-raku.github.io/FDF-raku/FDF) - FDF file
- [FDF::Annot](https://pdf-raku.github.io/FDF-raku/FDF/Annot) - FDF Annotations
- [FDF::Catalog](https://pdf-raku.github.io/FDF-raku/FDF/Catalog) - FDF Catalog
- [FDF::Dict](https://pdf-raku.github.io/FDF-raku/FDF/Dict) - FDF Main Dictionary
- [FDF::Field](https://pdf-raku.github.io/FDF-raku/FDF/Field) - FDF Fields
- [FDF::Field::AdditionalActions](https://pdf-raku.github.io/FDF-raku/FDF/Field/AdditionalActions) - FDF Field Additional Actions
- [FDF::IconFit](https://pdf-raku.github.io/FDF-raku/FDF/IconFit) - FDF IconFits
- [FDF::JavaScript](https://pdf-raku.github.io/FDF-raku/FDF/JavaScript) - FDF JavaScripts
- [FDF::NamedPageRef](https://pdf-raku.github.io/FDF-raku/FDF/NamedPageRef) - FDF Named Page References
- [FDF::Page](https://pdf-raku.github.io/FDF-raku/FDF/Page) - FDF Pages to be added
- [FDF::Template](https://pdf-raku.github.io/FDF-raku/FDF/Template) - FDF Page Templates


Synopsis
--------

### Export fields from a PDF to an FDF
```
use PDF::Class;
use FDF;
my PDF::Class $from .= open: "MyDoc.pdf";
my FDF $fdf .= new;

# fill the email field, overriding PDF value
my %fill = :email<david.warring@gmail.com>;

# Combined import and filling
$fdf.import: :$from, :%fill;
# -OR- import then fill
$fdf.import: :$from;
$fdf.import: :%fill;

note "saving fields :-"
for $fdf.field-hash.sort {
    note " - {.key}: {.value.perl}";
}

$fdf.save-as: "MyDoc.fdf";
```

### List field values in an FDF file
```
use FDF;
use FDF::Field;
my FDF $fdf .= open: "MyDoc.fdf";

my FDF::Fields @fields = $fdf.fields;
for @fields {
    say .key ~ ': ' ~ .value.raku;
}

```


### Export field data from an FDF to a PDF
```
use PDF::Class;
use FDF;
my PDF::Class $to .= open: "MyDoc.pdf";
my FDF $fdf .= open: "MyDoc.fdf";

# populate form data from the PDF
$fdf.export: :$to;

# save updated fields
$to.update;

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
