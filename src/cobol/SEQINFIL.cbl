       IDENTIFICATION DIVISION.
       PROGRAM-ID.    SEQINFIL.
       ENVIRONMENT DIVISION.
       INPUT-OUTPUT SECTION.
       FILE-CONTROL.
      *
           SELECT INFILE3 ASSIGN TO DDIN3
                  ORGANIZATION SEQUENTIAL
                  ACCESS MODE SEQUENTIAL.
       DATA DIVISION.
       FILE SECTION.
      *
       FD INFILE3
           RECORDING MODE IS V
           RECORD IS VARYING IN SIZE FROM 6 TO 76
           DEPENDING ON VAR-RECORD-SIZE.
       01 IN-REC3.
          05 IN-EMP-NO              PIC 9(05).
          05 IN-EMP-DATA            PIC X(71).
      *
       WORKING-STORAGE SECTION.
       01 EOF                       PIC 9.
       01 VAR-RECORD-SIZE           PIC 99.
       LINKAGE SECTION.
       PROCEDURE DIVISION.
       MAIN SECTION.
           PERFORM INIT.
           PERFORM FILE-PROC
           PERFORM TERM
           GOBACK.
       INIT SECTION.
           OPEN OUTPUT INFILE3
           MOVE ZERO TO EOF
           EXIT.
       FILE-PROC SECTION.
      *
           MOVE 6 TO VAR-RECORD-SIZE
           MOVE 12345 TO IN-EMP-NO
           MOVE 'AAAA' TO IN-EMP-DATA
           WRITE IN-REC3
      *
           MOVE 10 TO VAR-RECORD-SIZE
           MOVE 22222 TO IN-EMP-NO
           MOVE 'ABCDEFGHIJK' TO IN-EMP-DATA
           WRITE IN-REC3
           EXIT.
      *
           MOVE 20 TO VAR-RECORD-SIZE
           MOVE 33333 TO IN-EMP-NO
           MOVE 'CCCC' TO IN-EMP-DATA
           WRITE IN-REC3
           EXIT.
       TERM SECTION.
           CLOSE INFILE3
           EXIT.