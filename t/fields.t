use v6;
use Test;
use FDF;
use FDF::Field;

my $fdf;
lives-ok {$fdf = FDF.open: "t/fdf/samples/fields-basic.fdf"}, "open annots FDF - lives";
is $fdf.Root.FDF.F, 'fields-basic.pdf', 'FDF.F';
my FDF::Field @fields = $fdf.fields;

is +@fields, 7, 'number of fields';

does-ok @fields[0], FDF::Field, 'field role';
is @fields[0].T, 'CheckBox', '@fields[0].T';
is @fields[0].V, 'Off', '@fields[0].V';

my FDF::Field %fields = $fdf.fields-hash;

is +%fields, 7, 'number of fields';

does-ok %fields<CheckBox>, FDF::Field, 'field role';
is %fields<CheckBox>.T, 'CheckBox', '%fields<CheckBox>.T';
is %fields<CheckBox>.V, 'Off', '%fields<CheckBox>.V';

done-testing;
