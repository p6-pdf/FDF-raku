[[Raku PDF Project]](https://pdf-raku.github.io)
 / [[FDF Module]](https://pdf-raku.github.io/FDF-raku)
 / [FDF](https://pdf-raku.github.io/FDF-raku/FDF)

class FDF
---------

Entry point into an FDF document

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

### method fields

```perl6
method fields() returns Mu
```

Return a list of fields

```raku
    use FDF;
    use FDF::Field;
    my FDF $fdf .= open("MyDoc.pdf");
    my FDF::Field @fields = $fdf.fields;
```

### method fields-hash

```perl6
method fields-hash(
    |c
) returns Mu
```

Returns a Hash of fields

```raku
    my FDF::Field %fields = $fdf.fields-hash;
```

