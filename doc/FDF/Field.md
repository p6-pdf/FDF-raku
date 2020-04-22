NAME
====

FDF::Field

DESCRIPTION
===========

Each field in an FDF file is described by an FDF field dictionary. Most of the entries have the same form and meaning as the corresponding entries in a field (PDF::Field) dictionary or a widget annotation dictionary (PDF::Widget). Unless otherwise indicated in the table, importing a field causes the values of the entries in the FDF field dictionary to replace those of the corresponding entries in the field with the same fully qualified name in the target document.

METHODS
=======

class FDF::Field @.Kids
-----------------------

(Optional) An array containing the immediate children of this field.

### method fields

```perl6
method fields() returns Array
```

return ourself, if terminal, any children otherwise

class Str $.T (key)
-------------------

(Required) The partial field name

class Mu $.V (value)
--------------------

(Optional) The field’s value, whose format varies depending on the field type

class UInt $.Ff (field-flags)
-----------------------------

(Optional) A set of flags specifying various characteristics of the field. When imported into an interactive form, the value of this entry replaces that of the Ff entry in the form’s corresponding field dictionary. If this field is present, the SetFf and ClrFf entries, if any, are ignored.

class UInt $.SetFf (set-field-flags)
------------------------------------

(Optional) A set of flags to be set (turned on) in the Ff entry of the form’s corresponding field dictionary. Bits equal to 1 in SetFf cause the corresponding bits in Ff to be set to 1. This entry is ignored if an Ff entry is present in the FDF field dictionary.

class UInt $.ClrFf (clear-field-flags)
--------------------------------------

(Optional) A set of flags to be cleared (turned off) in the Ff entry of the form’s corresponding field dictionary. Bits equal to 1 in ClrFf cause the corresponding bits in Ff to be set to 0. If a SetFf entry is also present in the FDF field dictionary, it is applied before this entry. This entry is ignored if an Ff entry is present in the FDF field dictionary.

class UInt $.F (annot-flags)
----------------------------

(Optional) A set of flags specifying various characteristics of the field’s widget annotation. When imported into an interactive form, the value of this entry replaces that of the F entry in the form’s corresponding annotation dictionary. If this field is present, the SetF and ClrF entries, if any, are ignored.

class UInt $.SetF (set-annot-flags)
-----------------------------------

(Optional) A set of flags to be set (turned on) in the F entry of the form’s corresponding widget annotation dictionary. Bits equal to 1 in SetF cause the corresponding bits in F to be set to 1. This entry is ignored if an F entry is present in the FDF field dictionary.

class UInt $.ClrF (clear-annot-flags)
-------------------------------------

(Optional) A set of flags to be cleared (turned off) in the F entry of the form’s corresponding widget annotation dictionary. Bits equal to 1 in ClrF cause the corresponding bits in F to be set to 0. If a SetF entry is also present in the FDF field dictionary, it is applied before this entry. This entry is ignored if an F entry is present in the FDF field dictionary.

class FDF::Field::APDict $.AP (appearance)
------------------------------------------

(Optional) An appearance dictionary specifying the appearance of a pushbutton field. The appearance dictionary’s contents are as shown in Table 8.19 on page 614, except that the values of the N, R, and D entries must all be streams.

class FDF::Field::APRefDict $.ApRef (appearance-ref)
----------------------------------------------------

(Optional; PDF 1.3) A dictionary holding references to external PDF files containing the pages to use for the appearances of a pushbutton field. This dictionary is similar to an appearance dictionary, except that the values of the N,R and D entries must all be named page reference dictionaries. This entry is ignored if an AP entry is present.

class FDF::IconFit $.IF (icon-fit)
----------------------------------

(Optional; PDF 1.3; button fields only) An icon fit dictionary (see Table 8.97) specifying how to display a button field’s icon within the annotation rectangle of its widget annotation.

class PDF::Action $.A (actions)
-------------------------------

(Optional) An action to be performed when this field’s widget annotation is activated

class PDF::AdditionalActions $.AA (additional-actions)
------------------------------------------------------

(Optional) An additional-actions dictionary defining the field’s behavior in response to various trigger events

class PDF::Class::Defs::TextOrStream $.RV (rich-text)
-----------------------------------------------------

(Optional; PDF 1.5) A rich text string

### method import-to

```perl6
method import-to(
    PDF::Field:D $fld,
    Bool :$appearances = Bool::True,
    Bool :$actions = Bool::True
) returns Mu
```

import values into a PDF field from this FDF field

### method export-from

```perl6
method export-from(
    PDF::Field:D $fld,
    Bool :$appearances,
    Bool :$actions
) returns Mu
```

Populate this FDF field from the PDF field

