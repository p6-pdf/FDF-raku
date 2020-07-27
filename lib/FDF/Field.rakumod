use v6;

=begin pod
=head1 role FDF::Field

=head2 Description

Each field in an FDF file is described by an FDF field dictionary.  Most of the entries have the same form and meaning as the corresponding entries in a field (PDF::Field)
dictionary or a widget annotation dictionary (PDF::Widget). Unless otherwise indicated in the table, importing a field causes the values of the entries in the FDF
field dictionary to replace those of the corresponding entries in the field with the same fully qualified name in the
target document.

=head2 Methods

=end pod

use PDF::COS::Tie::Hash;

role FDF::Field
    does PDF::COS::Tie::Hash {

    # See [PDF 32000 Table 246 - Entries in an FDF field dictionary]

    use PDF::COS;
    use PDF::COS::Tie;
    use PDF::COS::Name;
    use PDF::COS::Dict;
    use PDF::COS::Stream;
    # PDF::Class
    use PDF::Class::Defs :TextOrStream;
    use PDF::Annot;
    use PDF::Field;
    use PDF::Field::Button;

    my subset FormLike of PDF::COS::Stream where .<Subtype> ~~ 'Form'; # autoloaded PDF::XObject::Form
    my role APDict
        does PDF::COS::Tie::Hash {

        has FormLike $.N is entry(:required);   # The annotation’s normal appearance.
        has FormLike $.R is entry;              # (Optional) The annotation’s rollover appearance. Default value: the value of the N entry.
        has FormLike $.D is entry;              # (Optional) The annotation’s down appearance. Default value: the value of the entry.
    }

    my role APRefDict
        does PDF::COS::Tie::Hash {

        has PDF::COS::Name $.N is entry(:required);     # The annotation’s normal appearance.
        has PDF::COS::Name $.R is entry;                # (Optional) The annotation’s rollover appearance. Default value: the value of the N entry. 
        has PDF::COS::Name $.D is entry;                # (Optional) The annotation’s down appearance. Default value: the value of the entry. 
    }

    # FDF Field definition

    #| (Optional) An array containing the immediate children of this field.
    has FDF::Field @.Kids is entry;
    # Note: Unlike the children of fields in a PDF file, which must be specified as indirect object references, those of an FDF field may be either direct or indirect objects.

    #| return ourself, if terminal, any children otherwise
    method fields(--> Array) {
	my @fields;
	if !self.Kids {
	    @fields.push: self
	}
	else {
	    for self.Kids.keys {
		my $kid = self.Kids[$_];
		@fields.append: $kid.fields;
	    }
	}
	@fields;
    }

    #| (Required) The partial field name
    has Str $.T is entry(:required, :alias<key>);

    #| (Optional) The field’s value, whose format varies depending on the field type
    has $.V is entry(:alias<value>);

    #| (Optional) A set of flags specifying various characteristics of the field. When imported into an interactive form, the value of this entry replaces that of the Ff entry in the form’s corresponding field dictionary. If this field is present, the SetFf and ClrFf entries, if any, are ignored.
    has UInt $.Ff is entry(:alias<field-flags>);

    #| (Optional) A set of flags to be set (turned on) in the Ff entry of the form’s corresponding field dictionary. Bits equal to 1 in SetFf cause the corresponding bits in Ff to be set to 1. This entry is ignored if an Ff entry is present in the FDF field dictionary.
    has UInt $.SetFf is entry(:alias<set-field-flags>);

    #| (Optional) A set of flags to be cleared (turned off) in the Ff entry of the form’s corresponding field dictionary. Bits equal to 1 in ClrFf cause the corresponding bits in Ff to be set to 0. If a SetFf entry is also present in the FDF field dictionary, it is applied before this entry. This entry is ignored if an Ff entry is present in the FDF field dictionary.
    has UInt $.ClrFf is entry(:alias<clear-field-flags>);

    #| (Optional) A set of flags specifying various characteristics of the field’s widget annotation. When imported into an interactive form, the value of this entry replaces that of the F entry in the form’s corresponding annotation dictionary. If this field is present, the SetF and ClrF entries, if any, are ignored.
    has UInt $.F is entry(:alias<annot-flags>);

    #| (Optional) A set of flags to be set (turned on) in the F entry of the form’s corresponding widget annotation dictionary. Bits equal to 1 in SetF cause the corresponding bits in F to be set to 1. This entry is ignored if an F entry is present in the FDF field dictionary.
    has UInt $.SetF is entry(:alias<set-annot-flags>);

    #| (Optional) A set of flags to be cleared (turned off) in the F entry of the form’s corresponding widget annotation dictionary. Bits equal to 1 in ClrF cause the corresponding bits in F to be set to 0. If a SetF entry is also present in the FDF field dictionary, it is applied before this entry. This entry is ignored if an F entry is present in the FDF field dictionary.
    has UInt $.ClrF is entry(:alias<clear-annot-flags>);

    #| (Optional) An appearance dictionary specifying the appearance of a pushbutton field. The appearance dictionary’s contents are as shown in Table 8.19 on page 614, except that the values of the N, R, and D entries must all be streams.
    has APDict $.AP is entry(:alias<appearance>);

    #| (Optional; PDF 1.3) A dictionary holding references to external PDF files containing the pages to use for the appearances of a pushbutton field. This dictionary is similar to an appearance dictionary, except that the values of the N,R and D entries must all be named page reference dictionaries. This entry is ignored if an AP entry is present.
    has APRefDict $.ApRef is entry(:alias<appearance-ref>);

    use FDF::IconFit;
    #| (Optional; PDF 1.3; button fields only) An icon fit dictionary (see Table 8.97) specifying how to display a button field’s icon within the annotation rectangle of its widget annotation.
    has FDF::IconFit $.IF is entry(:alias<icon-fit>);

    use PDF::Action;
    #| (Optional) An action to be performed when this field’s widget annotation is activated 
    has PDF::Action $.A is entry(:alias<actions>);
    use PDF::AdditionalActions;
    #| (Optional) An additional-actions dictionary defining the field’s behavior in response to various trigger events
    has PDF::AdditionalActions $.AA is entry(:alias<additional-actions>);

    #| (Optional; PDF 1.5) A rich text string
    has TextOrStream $.RV is entry(:alias<rich-text>, :coerce(&coerce-text-or-stream));

    sub set-key($dest-fld, $src-fld) {
        with $src-fld<T> -> $pk {
            with $dest-fld<T> {
                warn "field keys do not  match: FDF={$dest-fld<T>} PDF:$pk"
                    unless $dest-fld<T> eq $pk;
            }
            else {
                $dest-fld<T> = $_;
            }
        }
        else {
            with $dest-fld<T> {
                $src-fld<T> = $_;
            }
            else {
                warn "no Form keys found /T entry";
            }
        }
    }

    #| export values into a PDF field from this FDF field
    method export(PDF::Field:D :$to!, Bool :$appearances = True, Bool :$actions = True) {
        set-key(self, $to);

        $to.V = $_ with self.V;
        $to.RV = $_ with self.RV;

        with self.F {
            $to<F> = $_;
        }
        else {
            given ($to<F> //= 0) -> $f is rw {
                $f +|= $_ with self.SetF;
                $f -= ($f +& $_) with self.ClrF;
            }
        }

        with $to.Ff {
            $to<Ff> = $_;
        }
        else {
            given $to<Ff> //= 0 -> $f is rw {
                $f +|= $_ with self.SetFf;
                $f -= ($f +& $_) with self.ClrFf;
            }
        }

        if $appearances {
            $to.AP = $_ with self.AP;
            warn "todo apply icon-fit (/IF)" with self.IF;
        }

        if $actions {
            $to.A = $_ with self.A;
            $to.AA = $_ with self.AA;
        }
    }

    #| Populate this FDF field from the PDF field
    multi method import(PDF::Field:D :$from!, Bool :$appearances, Bool :$actions) {
        set-key($from, self);

        self.V = $from.V // '';
        self.RV = $_ with $from.RV;

        unless self.SetF || self.ClrF {
            self.F = $_ with $from<F>;
        }

        unless self.SetFf || self.ClrFf {
            self.Ff = $_ with $from.Ff;
        }

        if $appearances {
            self.AP = $_ with $from.AP;
        }

        if $$actions {
            self.A  = $_ with $from.A;
            self.AA = $_ with $from.AA;
        }
    }

    method coerce(Hash $dict) { PDF::COS.coerce($dict, FDF::Field) }
}
