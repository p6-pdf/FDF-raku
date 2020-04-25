SRC=src

all : docs

test :
	@prove -e"perl6 -I ." t

loudtest :
	@prove -e"perl6 -I ." -v t

clean :
	@rm -f Makefile docs/FDF/*.md docs/FDF/*/*.md

docs : docs/FDF.md docs/FDF/Annot.md docs/FDF/Catalog.md docs/FDF/Dict.md docs/FDF/Field.md docs/FDF/IconFit.md\
 docs/FDF/JavaScript.md docs/FDF/NamedPageRef.md docs/FDF/Page.md docs/FDF/Template.md

docs/FDF.md : lib/FDF.rakumod
	rakudo -I . --doc=Markdown lib/FDF.rakumod > docs/FDF.md

docs/FDF/Annot.md : lib/FDF/Annot.rakumod
	rakudo -I . --doc=Markdown lib/FDF/Annot.rakumod > docs/FDF/Annot.md

docs/FDF/Catalog.md : lib/FDF/Catalog.rakumod
	rakudo -I . --doc=Markdown lib/FDF/Catalog.rakumod > docs/FDF/Catalog.md

docs/FDF/Dict.md : lib/FDF/Dict.rakumod
	rakudo -I . --doc=Markdown lib/FDF/Dict.rakumod > docs/FDF/Dict.md

docs/FDF/Field.md : lib/FDF/Field.rakumod
	rakudo -I . --doc=Markdown lib/FDF/Field.rakumod > docs/FDF/Field.md

docs/FDF/IconFit.md : lib/FDF/IconFit.rakumod
	rakudo -I . --doc=Markdown lib/FDF/IconFit.rakumod > docs/FDF/IconFit.md

docs/FDF/JavaScript.md : lib/FDF/JavaScript.rakumod
	rakudo -I . --doc=Markdown lib/FDF/JavaScript.rakumod > docs/FDF/JavaScript.md

docs/FDF/NamedPageRef.md : lib/FDF/NamedPageRef.rakumod
	rakudo -I . --doc=Markdown lib/FDF/NamedPageRef.rakumod > docs/FDF/NamedPageRef.md

docs/FDF/Page.md : lib/FDF/Page.rakumod
	rakudo -I . --doc=Markdown lib/FDF/Page.rakumod > docs/FDF/Page.md

docs/FDF/Template.md : lib/FDF/Template.rakumod
	rakudo -I . --doc=Markdown lib/FDF/Template.rakumod > docs/FDF/Template.md

