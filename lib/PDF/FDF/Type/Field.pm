use v6;

use PDF::DAO::Tie;
use PDF::DAO::Tie::Hash;
use PDF::DAO::Name;
use PDF::DAO::Stream;
use PDF::FDF::Type::IconFit;

# FDF Field definition

my role APDict
    does PDF::DAO::Tie::Hash {

	has PDF::DAO::Stream $.N is entry(:required);   #| The annotation’s normal appearance.
	has PDF::DAO::Stream $.R is entry;              #| (Optional) The annotation’s rollover appearance. Default value: the value of the N entry. 
	has PDF::DAO::Stream $.D is entry;              #| (Optional) The annotation’s down appearance. Default value: the value of the entry. 
}

my role APRefDict
    does PDF::DAO::Tie::Hash {

	has PDF::DAO::Name $.N is entry(:required);   #| The annotation’s normal appearance.
	has PDF::DAO::Name $.R is entry;              #| (Optional) The annotation’s rollover appearance. Default value: the value of the N entry. 
	has PDF::DAO::Name $.D is entry;              #| (Optional) The annotation’s down appearance. Default value: the value of the entry. 
}

role PDF::FDF::Type::Field
    does PDF::DAO::Tie::Hash {

   # See [PDF 1.7 TABLE 8.96 Entries in an FDF field dictionary]

    use PDF::DAO::Tie;

    has PDF::FDF::Type::Field @.Kids is entry; #| (Optional) An array containing the immediate children of this field.
                                               #| Note: Unlike the children of fields in a PDF file, which must be specified as indirect object references, those of an FDF field may be either direct or indirect objects. 
    #| return ourself, if terminal, any children otherwise
    method fields {
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
	flat @fields;
    }

    has Str $.T is entry(:required);   #| (Required) The partial field name
    has $.V is entry;                  #| (Optional) The field’s value, whose format varies depending on the field type

    has UInt $.Ff is entry;            #| (Optional) A set of flags specifying various characteristics of the field. When imported into an interactive form, the value of this entry replaces that of the Ff entry in the form’s corresponding field dictionary. If this field is present, the SetFf and ClrFf entries, if any, are ignored.

    has UInt $.SetFf is entry;         #| (Optional) A set of flags to be set (turned on) in the Ff entry of the form’s corresponding field dictionary. Bits equal to 1 in SetFf cause the corresponding bits in Ff to be set to 1. This entry is ignored if an Ff entry is present in the FDF field dictionary. 

    has UInt $.ClrFf is entry;         #| (Optional) A set of flags to be cleared (turned off) in the Ff entry of the form’s corresponding field dictionary. Bits equal to 1 in ClrFf cause the corresponding bits in Ff to be set to 0. If a SetFf entry is also present in the FDF field dictionary, it is applied before this entry. This entry is ignored if an Ff entry is present in the FDF field dictionary.

    has UInt $.F is entry;             #| (Optional) A set of flags specifying various characteristics of the field’s widget annotation. When imported into an interactive form, the value of this entry replaces that of the F entry in the form’s corresponding annotation dictionary. If this field is present, the SetF and ClrF entries, if any, are ignored.

    has UInt $.SetF is entry;          #| (Optional) A set of flags to be set (turned on) in the F entry of the form’s corresponding widget annotation dictionary. Bits equal to 1 in SetF cause the corresponding bits in F to be set to 1. This entry is ignored if an F entry is present in the FDF field dictionary.

    has UInt $.ClrF is entry;          #| (Optional) A set of flags to be cleared (turned off) in the F entry of the form’s corresponding widget annotation dictionary. Bits equal to 1 in ClrF cause the corresponding bits in F to be set to 0. If a SetF entry is also present in the FDF field dictionary, it is applied before this entry. This entry is ignored if an F entry is present in the FDF field dictionary.

    has APDict $.AP is entry;          #| (Optional) An appearance dictionary specifying the appearance of a pushbutton field. The appearance dictionary’s contents are as shown in Table 8.19 on page 614, except that the values of the N, R, and D entries must all be streams.

    has APRefDict $.ApRef is entry;    #| (Optional; PDF 1.3) A dictionary holding references to external PDF files containing the pages to use for the appearances of a pushbutton field. This dictionary is similar to an appearance dictionary, except that the values of the N,R and D entries must all be named page reference dictionaries. This entry is ignored if an AP entry is present. 

    has PDF::FDF::Type::IconFit $.IF is entry;  #| (Optional; PDF 1.3; button fields only) An icon fit dictionary (see Table 8.97) specifying how to display a button field’s icon within the annotation rectangle of its widget annotation. 

## causing Rakudo to lose symbols
##    use PDF::FDF::Type::Actions;
##    has PDF::FDF::Type::Actions $.A is entry;   #| (Optional) An action to be performed when this field’s widget annotation is activated 
##    has PDF::FDF::Type::Actions $.AA is entry;  #| (Optional) An additional-actions dictionary defining the field’s behavior in response to various trigger events
    has Hash $.A is entry;
    has Hash $.AA is entry;
    has $.RV is entry;                  #| (Optional; PDF 1.5) A rich text string
}
