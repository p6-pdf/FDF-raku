unit role FDF::JavaScript;

use PDF::COS::Tie::Hash;
also does PDF::COS::Tie::Hash;

use ISO_32000::Table_245-Entries_in_the_JavaScript_dictionary;
also does ISO_32000::Table_245-Entries_in_the_JavaScript_dictionary;

use ISO_32000_2::Table_248-Entries_in_the_ECMAScript_dictionary;
also does ISO_32000_2::Table_248-Entries_in_the_ECMAScript_dictionary;

=begin pod
=head1 role FDF::JavaScript

=head2 Description

The JavaScript entry in the FDF dictionary holds a JavaScript dictionary containing JavaScript scripts that
shall be defined globally at the document level, rather than associated with individual fields. The dictionary may
contain scripts defining JavaScript functions for use by other scripts in the document, as well as scripts that
are executed immediately before and after the FDF file is imported.

=head2 Methods
=end pod


# See [PDF 32000 Table 245 - Entries in the JavaScript dictionary]

use PDF::COS::Tie;
use PDF::Class::Defs :TextOrStream;

#| (Optional) A text string or text stream containing a JavaScript script to be executed just before the FDF file is imported.
has TextOrStream $.Before is entry;

#| (Optional) A text string or text stream containing a JavaScript script to be executed just after the FDF file is imported.
has TextOrStream $.After is entry;

#| (Optional; PDF 1.6) A text string or text stream containing a JavaScript script to be executed after the FDF file is imported and the usage rights in the PDF document have been determined.
has TextOrStream $.AfterPermsReady is entry;
# Note: Verification of usage rights requires the entire file to be present, in which case this script defers execution until that requirement is met.

# to be completed

#| An array defining additional JavaScript scripts that is added to those defined in the JavaScript entry of the document’s name dictionary. The array contains an even number of elements, organized in pairs. The first element of each pair is a name and the second is a text string or text stream defining the script corresponding to that name. Each of the defined scripts is added to those already defined in the name dictionary and is then executed before the script defined in the Before entry is executed.
has @.Doc is entry;

