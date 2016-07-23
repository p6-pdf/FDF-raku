use v6;
use Test;
use FDF;
use FDF::Field;

my $fdf;
lives-ok {$fdf = FDF.open: "t/fdf/samples/fields-basic.fdf"}, "open annots FDF - lives";
is $fdf.Root.FDF.F, 'fields-basic.pdf', 'FDF.F';
my $fields = $fdf.fields;

is +$fields, 7, 'number of fields';

does-ok $fields[0], FDF::Field, 'field role';
is $fields[0].T, 'CheckBox', '$fields.T';
is $fields[0].V, 'Off', '$fields.V';

done-testing;
