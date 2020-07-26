[[Raku PDF Project]](https://pdf-raku.github.io)
 / [[FDF Module]](https://pdf-raku.github.io/FDF-raku)
 / [FDF](https://pdf-raku.github.io/FDF-raku/FDF)

NAME
====

Pod::To::Markdown - Render Pod as Markdown

SYNOPSIS
========

From command line:

    $ perl6 --doc=Markdown lib/To/Class.pm

From Perl6:

```perl6
use Pod::To::Markdown;

=NAME
foobar.pl

=SYNOPSIS
    foobar.pl <options> files ...

print pod2markdown($=pod);
```

EXPORTS
=======

    class Pod::To::Markdown
    sub pod2markdown

DESCRIPTION
===========



### method render

```perl6
method render(
    $pod,
    Bool :$no-fenced-codeblocks
) returns Str
```

Render Pod as Markdown

To render without fenced codeblocks (```` ``` ````), as some markdown engines don't support this, use the :no-fenced-codeblocks option. If you want to have code show up as ```` ```perl6```` to enable syntax highlighting on certain markdown renderers, use:

    =begin code :lang<perl6>

### sub pod2markdown

```perl6
sub pod2markdown(
    $pod,
    Bool :$no-fenced-codeblocks
) returns Str
```

Render Pod as Markdown, see .render()

LICENSE
=======

This is free software; you can redistribute it and/or modify it under the terms of The [Artistic License 2.0](http://www.perlfoundation.org/artistic_license_2_0).
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

