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

docs/%.md : lib/%.rakumod
	@raku -I . -c $<
	raku -I . --doc=Markdown $< \
	| TRAIL=$* raku -p -n $(DocLinker) \
        > $@

docs/index.md : README.md
	cp $< $@

$(DocLinker) :
	(cd .. && git clone $(DocRepo) $(DocProj))

Pod-To-Markdown-installed :
	@raku -M Pod::To::Markdown -c

doc : $(DocLinker) Pod-To-Markdown-installed docs/index.md docs/FDF.md docs/FDF/Annot.md docs/FDF/Catalog.md docs/FDF/Dict.md docs/FDF/Field.md docs/FDF/Field/AdditionalActions.md \
 docs/FDF/IconFit.md docs/FDF/JavaScript.md docs/FDF/NamedPageRef.md docs/FDF/Page.md docs/FDF/Template.md
