use Test;
use FDF;
use FDF::Field;
use PDF::Class;

my PDF::Class $pdf .= open: "t/pdf/samples/OoPdfFormExample.pdf";

constant Height = 'Height Formatted Field';
constant Country = 'Country Combo Box';

my %fill = (Height) => '170';
my FDF $fdf .= create(from => $pdf, :%fill);

my %fields = $fdf.fields-hash;
is %fields{Height}.V, '170';
is %fields{Country}.V, 'New Zealand';

%fill{Height} = '160';
$fdf.merge(to => $pdf, :%fill);

%fields = $pdf.fields-hash;
is %fields{Height}.V, '160';
is %fields{Country}.V, 'New Zealand';

done-testing();
