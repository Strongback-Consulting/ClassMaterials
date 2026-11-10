       IDENTIFICATION DIVISION.
       PROGRAM-ID. PROGRAM_ID.
       AUTHOR. Kenny Smith, Strongback Consulting.
      *This is an example of the new JSON GENERATE command
      *available in COBOL v6.1.
       DATE-WRITTEN. June 10, 2016.
       DATE-COMPILED. June 10, 2016.
       DATA DIVISION.
       WORKING-STORAGE SECTION.

       01  GREETING.
           02 MSG PIC X(80) VALUE 'Hello, World!'.
       01 JTEXT NATIONAL PIC N(80).
       01 I BINARY PIC 99.

       PROCEDURE DIVISION.
       100-GENERATE-JSON.

           JSON generate Jtext from greeting count in i
                      on exception
                      display 'JSON generation error: ' json-code
                      not on exception
                      display function display-of(Jtext(1:i))

            End-JSON.