      * A program for debugging
       IDENTIFICATION DIVISION.
       PROGRAM-ID. SOCKY7.

       DATA DIVISION.
       WORKING-STORAGE SECTION.
       01  FIELD1       PIC S9(5)V99 COMP-3 VALUE 100.
       01  FIELD2       PIC S9(5)V99 COMP-3.
       01  FIELD2-CHAR REDEFINES FIELD2
                        PIC X(4).
       01  BALANCE    PIC S9(9)V99 COMP-3 VALUE 0.
       01  BALANCE-CHAR  PIC 9(9).99- DISPLAY.

       PROCEDURE DIVISION.
           DISPLAY "  SOCKY7: STARTING".
      *    The uninitialized FIELD2 will cause the
      *    compute statement to fail
           COMPUTE BALANCE = FIELD1 / FIELD2.
           MOVE BALANCE TO BALANCE-CHAR.
           DISPLAY "  BALANCE IS " BALANCE-CHAR.
           GOBACK.
       END PROGRAM SOCKY7.