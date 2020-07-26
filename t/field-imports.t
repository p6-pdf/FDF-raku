use v6;
use Test;
plan 8;
use PDF::Field;
use PDF::Field::Text;
use FDF::Field;
use PDF::COS;

my %pdf-dict =
 :FT<Tx>,
 :T<surname-fld>,
 :TU<Surname>,
 :V<Warring>,
 :Ff(123),
;

my PDF::Field $pdf-field .= coerce: %pdf-dict;
my FDF::Field $fdf-field .= coerce: { } ;

does-ok $fdf-field, FDF::Field;
does-ok $pdf-field, PDF::Field::Text;
lives-ok { $pdf-field.check }, 'PDF::Field.check()';
lives-ok { $fdf-field.check }, 'FDF::Field.check()';

lives-ok {$fdf-field.import: $pdf-field;}

for <T V Ff> {
    is $fdf-field."$_"(), %pdf-dict{$_}, "export of $_";
}

done-testing;
