
      * A simple program for testing compilation and execution
      * using RDz.
      * This application converts lengths from metric to SAE
      *
       IDENTIFICATION DIVISION.
       PROGRAM-ID. CMPLEME.
       AUTHOR. Kenny Smith, Strongback Consulting.
       ENVIRONMENT DIVISION.
       DATA DIVISION.
       WORKING-STORAGE SECTION.
       01  MLENGTH      PIC S9(5)V99 COMP-3.
       01  MLENGTH-CHAR PIC 9(9).99- DISPLAY.

       01  SAE-LENGTH   PIC S9(5)V99 COMP-3 VALUE 32.
       01  CONSTANT     PIC S9(5)V99 COMP-3 VALUE 25.4.

       PROCEDURE DIVISION.
       000-MAIN.
           DISPLAY " Converting SAE to Metric ".
           COMPUTE MLENGTH = SAE-LENGTH * CONSTANT.
           MOVE MLENGTH to MLENGTH-CHAR.
           DISPLAY " inches are equivalent in MM to " MLENGTH-CHAR.
           GOBACK .