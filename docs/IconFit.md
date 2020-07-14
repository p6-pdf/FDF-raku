[[Raku PDF Project]](https://pdf-raku.github.io)
 / [FDF](https://pdf-raku.github.io/FDF-raku)
 :: [IconFit](https://pdf-raku.github.io/FDF-raku/IconFit)

NAME
====

FDF::IconFit

DESCRIPTION
===========

The Icon Fit dictionary specifies how to display the button’s icon within the annotation rectangle of its widget annotation

METHODS
=======



(Optional) The circumstances under which the icon should be scaled inside the annotation rectangle:

class Numeric @.A
-----------------

(Optional) The type of scaling that shall be used:

### has Bool $.FB

(Optional) An array of two numbers between 0.0 and 1.0 indicating the fraction of leftover space to allocate at the left and bottom of the icon. A value of [0.0 0.0] positions the icon at the bottom-left corner of the annotation rectangle. A value of [0.5 0.5] centers it within the rectangle. This entry is used only if the icon is scaled proportionally. Defaultvalue: [0.5 0.5].

