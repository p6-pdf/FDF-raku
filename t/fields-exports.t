use v6;
use Test;
plan 11;
use PDF::Field;
use PDF::Field::Text;
use FDF::Field;
use PDF::COS;

my %fdf-dict = 
 :T<surname-fld>,
 :TU<Surname>,
 :V<Warring>,
 :SetF(1 + 2 + 4),
 :ClrF(2 + 8),
;

my $FT = 'Tx';

my FDF::Field $fdf-field .= coerce: %fdf-dict;
my PDF::Field $pdf-field .= coerce: { :$FT, :Ff(1 + 4 + 8), };

does-ok $fdf-field, FDF::Field;
does-ok $pdf-field, PDF::Field::Text;
lives-ok { $pdf-field.check }, 'PDF::Field.check()';
lives-ok { $fdf-field.check }, 'FDF::Field.check()';


lives-ok {$fdf-field.export: $pdf-field;}

for <T V> {
    is $pdf-field{$_}, $fdf-field."$_"(), "import of $_";
}
is $fdf-field.SetF, 1+2+4;
is $fdf-field.ClrF, 2+8;
is $pdf-field<F>, 1+4, "import of F";
is $pdf-field<Ff>, 1+4+8, "import of Ff";

done-testing;
