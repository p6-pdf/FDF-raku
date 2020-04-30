all : doc

docs : doc

test :
	@prove -e"raku -I ." t

loudtest :
	@prove -e"raku -I ." -v t

clean :
	@rm -f docs/FDF.md docs/FDF/*.md

docs/%.md : lib/%.rakumod
	raku -I . --doc=Markdown $< > $@

doc : docs/FDF.md docs/FDF/Annot.md docs/FDF/Catalog.md docs/FDF/Dict.md docs/FDF/Field.md docs/FDF/IconFit.md\
 docs/FDF/JavaScript.md docs/FDF/NamedPageRef.md docs/FDF/Page.md docs/FDF/Template.md

docs/FDF.md : lib/FDF.rakumod

docs/FDF/Annot.md : lib/FDF/Annot.rakumod

docs/FDF/Catalog.md : lib/FDF/Catalog.rakumod

docs/FDF/Dict.md : lib/FDF/Dict.rakumod

docs/FDF/Field.md : lib/FDF/Field.rakumod

docs/FDF/IconFit.md : lib/FDF/IconFit.rakumod

docs/FDF/JavaScript.md : lib/FDF/JavaScript.rakumod

docs/FDF/NamedPageRef.md : lib/FDF/NamedPageRef.rakumod

docs/FDF/Page.md : lib/FDF/Page.rakumod

docs/FDF/Template.md : lib/FDF/Template.rakumod

