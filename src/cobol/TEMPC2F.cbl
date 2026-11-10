       IDENTIFICATION DIVISION.
       PROGRAM-ID. FAHREN-TO-CEL.
       ENVIRONMENT DIVISION.
       INPUT-OUTPUT SECTION.
       FILE-CONTROL.
           SELECT IN1 ASSIGN TO DISK
           ORGANIZATION IS LINE SEQUENTIAL.
           SELECT OUT1 ASSIGN TO DISK
           ORGANIZATION IS LINE SEQUENTIAL.
       DATA DIVISION.
       FILE SECTION.
       FD IN1
           LABEL RECORDS ARE STANDARD
           VALUE OF FILE-ID IS "IN1.TXT".
       01 IN-REC.
          05 F1-IN PIC 9(3).
       FD OUT1
           LABEL RECORDS ARE STANDARD
           VALUE OF FILE-ID IS "OUT1.TXT".
       01 OUT-REC PIC X(80).

       WORKING-STORAGE SECTION.
       01 OUTREC.
          05 F1-OUT PIC 9(3).
          05 FILLER PIC X(10).
          05 ANS-OUT PIC 9(3).99.
       01 H1.
          05 F1 PIC X(80) VALUE ALL '*'.
       01 H2.
          05 F1 PIC X(10) VALUE "FARENNHEIT".
          05 FILLER PIC X(10).
          05 F2 PIC X(8) VALUE "CELCIUS".
       77 A-T-M-R PIC XXX VALUE 'YES'.
       77 CENT PIC 9(3)V99.
       PROCEDURE DIVISION.
       100-MAIN.
           OPEN INPUT IN1.
           OPEN OUTPUT OUT1.
           WRITE OUT-REC FROM H1.
           WRITE OUT-REC FROM H2.
           WRITE OUT-REC FROM H1.
           READ IN1
                AT END MOVE 'NO' TO A-T-M-R.
                PERFORM 200-CALC UNTIL A-T-M-R = 'NO'.
              CLOSE IN1.
              CLOSE OUT1.
              STOP RUN.
       200-CALC.
           MOVE F1-IN TO F1-OUT.
           COMPUTE ANS-OUT = ( 5 / 9 ) * ( F1-IN - 32 ).
           WRITE OUT-REC FROM OUTREC.
           READ IN1 AT END MOVE 'NO' TO A-T-M-R.