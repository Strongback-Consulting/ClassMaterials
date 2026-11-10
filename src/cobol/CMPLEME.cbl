
      * A simple program for testing compilation and execution
      * using RDz.
      * This application converts lengths from metric to SAE
      *
       IDENTIFICATION DIVISION.
       PROGRAM-ID. CMPLEME.
       AUTHOR. Kenny Smith, Strongback Consulting.
       DATE-WRITTEN. Jan 24, 2014.
       DATE-COMPILED. Jan 24, 2014.
       SECURITY. .

       ENVIRONMENT DIVISION.
       CONFIGURATION SECTION.
       INPUT-OUTPUT SECTION.
       FILE-CONTROL.

       DATA DIVISION.
       FILE SECTION.
       WORKING-STORAGE SECTION.
       01  MLENGTH      PIC S9(5)V99 COMP-3.
       01  MLENGTH-CHAR PIC 9(9).99- DISPLAY.

       01  SAE-LENGTH   PIC S9(5)V99 COMP-3.
       01  CONSTANT     PIC S9(5)V99 COMP-3 VALUE 1.53.

       LOCAL-STORAGE SECTION.
       LINKAGE SECTION.

       PROCEDURE DIVISION.
           DISPLAY "Converting SAE to Metric".
           COMPUTE MLENGTH = SAE-LENGTH * CONSTANT.
           MOVE MLENGTH to MLENGTH-CHAR.
           DISPLAY " These are equivalent to " MLENGTH-CHAR.
       END PROGRAM CMPLEME.