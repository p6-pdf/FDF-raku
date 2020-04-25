NAME
====

FDF::JavaScript

DESCRIPTION
===========

The JavaScript entry in the FDF dictionary holds a JavaScript dictionary containing JavaScript scripts that shall be defined globally at the document level, rather than associated with individual fields. The dictionary may contain scripts defining JavaScript functions for use by other scripts in the document, as well as scripts that shall be executed immediately before and after the FDF file is imported.

METHODS
=======

class PDF::Class::Defs::TextOrStream $.Before
---------------------------------------------

(Optional) A text string or text stream containing a JavaScript script to be executed just before the FDF file is imported.

class PDF::Class::Defs::TextOrStream $.After
--------------------------------------------

(Optional) A text string or text stream containing a JavaScript script to be executed just after the FDF file is imported.

class PDF::Class::Defs::TextOrStream $.AfterPermsReady
------------------------------------------------------

(Optional; PDF 1.6) A text string or text stream containing a JavaScript script to be executed after the FDF file is imported and the usage rights in the PDF document have been determined.

class Positional $.Doc
----------------------

An array defining additional JavaScript scripts that is added to those defined in the JavaScript entry of the document’s name dictionary. The array contains an even number of elements, organized in pairs. The first element of each pair is a name and the second is a text string or text stream defining the script corresponding to that name. Each of the defined scripts is added to those already defined in the name dictionary and is then executed before the script defined in the Before entry is executed.

