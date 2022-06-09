use v6;
use Test;
use FDF;
use FDF::Dict;

mkdir ('tmp');

lives-ok { FDF.new.save-as: "tmp/create-minimal.fdf" }, "create minimal";

my $fdf-doc = FDF.new;
my FDF::Dict $fdf = $fdf-doc.Root.FDF;

$fdf.F = 't/fdf/create-simple.pdf';
my $fields = $fdf.Fields //= [];

$fields.push: { :T<Greeting>, :V<Hello> };

$fdf-doc.save-as: "tmp/create-simple.fdf";

lives-ok {$fdf-doc .= open: "tmp/create-simple.fdf"};
is +$fdf-doc.catalog.FDF.ID, 2, 'ID generated';

my $id0 = $fdf-doc.catalog.FDF.ID[0];
my $id1 = $fdf-doc.catalog.FDF.ID[1];

is $id0, $id1, 'created with two identical ID fields';
$fields = $fdf-doc.Root.FDF.Fields;
$fields.push: { :T<Recipient>, :V<World> };

$fdf-doc.update();

is $fdf-doc.catalog.FDF.ID[0], $id0, 'first ID retained after updated';
isnt $fdf-doc.catalog.FDF.ID[1], $id1, 'second ID changed after update';

done-testing;
