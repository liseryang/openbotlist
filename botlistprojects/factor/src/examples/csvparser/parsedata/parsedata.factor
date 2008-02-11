! ======================================
! 10/20/2007
! Invoke the csvparser
! Tested on Factor 0.90-git
! The parse-document is passed to the MAIN entry point
! ======================================

USING: kernel sequences io math.parser
	io.files namespaces combinators prettyprint ;

USE: csvparser
IN: csvparser.parsedata

: data-size ( rows -- str )
	length number>string ;	
	
: parse-document (  -- )
	"- Botlist URL Data Summary" print
	"Simple.txt" <file-reader> csv 
	data-size write nl
	"+ Parsing data complete." print

MAIN: parse-document ;
