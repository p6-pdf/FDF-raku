SRC=src

all : doc

test :
	@prove -e"perl6 -I ." t

loudtest :
	@prove -e"perl6 -I ." -v t

clean :
	@rm -f Makefile doc/FDF/*.md doc/FDF/*/*.md

doc : doc/FDF.md doc/FDF/Annot.md doc/FDF/Catalog.md doc/FDF/Dict.md doc/FDF/Field.md doc/FDF/IconFit.md\
 doc/FDF/JavaScript.md doc/FDF/NamedPageRef.md doc/FDF/Page.md doc/FDF/Template.md

doc/FDF.md : lib/FDF.rakumod
	rakudo -I . --doc=Markdown lib/FDF.rakumod > doc/FDF.md

doc/FDF/Annot.md : lib/FDF/Annot.rakumod
	rakudo -I . --doc=Markdown lib/FDF/Annot.rakumod > doc/FDF/Annot.md

doc/FDF/Catalog.md : lib/FDF/Catalog.rakumod
	rakudo -I . --doc=Markdown lib/FDF/Catalog.rakumod > doc/FDF/Catalog.md

doc/FDF/Dict.md : lib/FDF/Dict.rakumod
	rakudo -I . --doc=Markdown lib/FDF/Dict.rakumod > doc/FDF/Dict.md

doc/FDF/Field.md : lib/FDF/Field.rakumod
	rakudo -I . --doc=Markdown lib/FDF/Field.rakumod > doc/FDF/Field.md

doc/FDF/IconFit.md : lib/FDF/IconFit.rakumod
	rakudo -I . --doc=Markdown lib/FDF/IconFit.rakumod > doc/FDF/IconFit.md

doc/FDF/JavaScript.md : lib/FDF/JavaScript.rakumod
	rakudo -I . --doc=Markdown lib/FDF/JavaScript.rakumod > doc/FDF/JavaScript.md

doc/FDF/NamedPageRef.md : lib/FDF/NamedPageRef.rakumod
	rakudo -I . --doc=Markdown lib/FDF/NamedPageRef.rakumod > doc/FDF/NamedPageRef.md

doc/FDF/Page.md : lib/FDF/Page.rakumod
	rakudo -I . --doc=Markdown lib/FDF/Page.rakumod > doc/FDF/Page.md

doc/FDF/Template.md : lib/FDF/Template.rakumod
	rakudo -I . --doc=Markdown lib/FDF/Template.rakumod > doc/FDF/Template.md

