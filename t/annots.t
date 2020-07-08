use v6;
use Test;
use FDF;

my $fdf;
lives-ok {$fdf = FDF.open: "t/fdf/samples/pages-and-annots.fdf"}, "open annots FDF - lives";

my $annots = $fdf.Root.FDF.Annots;

is +$annots, 2, 'number of annots';

isa-ok $annots[0], 'PDF::Annot::Square', 'annot role';
does-ok $annots[0], (require ::('FDF::Annot')), 'annot role role';
is $annots[0].Page, 0, 'annot.Page';
is $annots[0].page-number, 1, 'annot.page-number';
is $annots[1].Page, 1, 'annot.Page';
is $annots[1].page-number, 2, 'annot.page-number';

done-testing;
