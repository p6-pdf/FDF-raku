use v6;
use Test;
use FDF;

my $fdf;
lives-ok {$fdf = FDF.open: "t/fdf/samples/pages-and-annots.fdf"}, "open annots FDF - lives";

my $annots = $fdf.Root.FDF.Annots;

is +$annots, 8, 'number of annots';

isa-ok $annots[0], ::('PDF::Annot::Square'), 'annot class';
does-ok $annots[0], ::('FDF::Annot'), 'annot role';
does-ok $annots[0], ::('FDF::Annot'), 'annot role';
is $annots[0].Page, 3, 'annot.Page';

done-testing;
