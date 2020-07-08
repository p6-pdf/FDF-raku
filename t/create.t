use v6;
use Test;
use FDF;
use FDF::Dict;

# ensure consistant document ID generation
srand(123456);

lives-ok { FDF.new.save-as: "t/fdf/create-minimal.fdf" }, "create minimal";

my $fdf-doc = FDF.new;
my FDF::Dict $fdf = $fdf-doc.Root.FDF;

$fdf.F = 't/fdf/create-simple.pdf';
my $fields = $fdf.Fields //= [];

$fields.push: { :T( :name<Greeting> ), :V<Hello> };

$fdf-doc.save-as: "t/fdf/create-simple.fdf";

lives-ok {$fdf-doc .= open: "t/fdf/create-simple.fdf"};
is +$fdf-doc.catalog.FDF.ID, 2, 'ID generated';

my $id0 = $fdf-doc.catalog.FDF.ID[0];
my $id1 = $fdf-doc.catalog.FDF.ID[1];

is $id0, $id1, 'created with two identical ID fields';
$fields = $fdf-doc.Root.FDF.Fields;
$fields.push: { :T( :name<Recipient> ), :V<World> };

$fdf-doc.update();

is $fdf-doc.catalog.FDF.ID[0], $id0, 'first ID retained after updated';
isnt $fdf-doc.catalog.FDF.ID[1], $id1, 'second ID changed after update';

done-testing;
