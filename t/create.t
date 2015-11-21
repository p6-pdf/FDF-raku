use v6;
use Test;
use PDF::FDF;

# ensure consistant document ID generation
srand(123456);

lives-ok { PDF::FDF.new.save-as: "t/fdf/create-minimal.fdf" }, "create minimal";

my $fdf-doc = PDF::FDF.new;
my $fdf = $fdf-doc.Root.FDF;

$fdf.F = 'create-simple.fdf';
my $fields = $fdf.Fields //= [];

$fields.push: { :T( :name<Hello> ), :V<World> };

$fdf-doc.save-as: "t/fdf/create-simple.fdf";

done-testing;