use v6;
use Test;

use FDF;

my $fdf = FDF.open( 't/fdf/samples/simple.fdf' );

is $fdf.version, 1.2, 'loaded version';
is $fdf.type, 'FDF', 'loaded type';

isa-ok $fdf, FDF , 'root FDF object';
isa-ok $fdf<Root><FDF>, Hash, '$fdf<Root><FDF>';
isa-ok $fdf.Root.FDF, Hash, '$fdf.Root.FDF';

is $fdf.Root.FDF.F, 'simple.pdf', '$fdfFDF.F';

isa-ok $fdf<Root><FDF><Fields>, Array, '$fdf<Root><FDF><Fields>';
is $fdf.Root.FDF.Fields[0].T, 'status', '$fdf.Root.FDF.Fields[0].T';

done-testing;
