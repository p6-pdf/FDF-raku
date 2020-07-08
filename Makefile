DocProj=pdf-raku.github.io
DocRepo=https://github.com/pdf-raku/$(DocProj)
DocLinker=../$(DocProj)/etc/resolve-links.raku

all : doc

docs : doc

test :
	@prove -e"raku -I ." t

loudtest :
	@prove -e"raku -I ." -v t

clean :
	@rm -f docs/*.md

docs/%.md : lib/FDF/%.rakumod
	raku -I . --doc=Markdown $< \
	| raku -p -n $(DocLinker) \
        > $@

docs/index.md : lib/FDF.rakumod
	raku -I . --doc=Markdown $< \
	| raku -p -n $(DocLinker) \
        > $@

$(DocLinker) :
	(cd .. && git clone $(DocRepo) $(DocProj))

doc : $(DocLinker) docs/index.md docs/Annot.md docs/Catalog.md docs/Dict.md docs/Field.md docs/IconFit.md\
 docs/JavaScript.md docs/NamedPageRef.md docs/Page.md docs/Template.md

docs/index.md : lib/FDF.rakumod

docs/Annot.md : lib/FDF/Annot.rakumod

docs/Catalog.md : lib/FDF/Catalog.rakumod

docs/Dict.md : lib/FDF/Dict.rakumod

docs/Field.md : lib/FDF/Field.rakumod

docs/IconFit.md : lib/FDF/IconFit.rakumod

docs/JavaScript.md : lib/FDF/JavaScript.rakumod

docs/NamedPageRef.md : lib/FDF/NamedPageRef.rakumod

docs/Page.md : lib/FDF/Page.rakumod

docs/Template.md : lib/FDF/Template.rakumod

