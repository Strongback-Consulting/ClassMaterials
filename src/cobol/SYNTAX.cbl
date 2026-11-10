       IDENTIFICATION DIVISION.
       PROGRAM-ID. MTCHMERG.
       AUTHOR.  IBM.
       INSTALLATION.   BIG OL MAINFRAME.
       DATE-WRITTEN.   JULY 1990.
      ******************************************************************
      *
      *
      ******************************************************************
       ENVIRONMENT DIVISION.
       CONFIGURATION SECTION.
       SOURCE-COMPUTER. IBM-3090.
       OBJECT-COMPUTER. IBM-3090.
       INPUT-OUTPUT SECTION.
       FILE-CONTROL.
           SELECT OLD-PARTS-MF-IN   ASSIGN TO UT-S-OLDPARTS.
           SELECT CUR-ACT-FILE-IN   ASSIGN TO UT-S-CURTRANS.
           SELECT PROD-LINE-FILE-IN ASSIGN TO UT-S-PRODFILE.
           SELECT SORT-WORK-FILE    ASSIGN TO UT-S-SORTFILE.
           SELECT NEW-PARTS-MF-OUT  ASSIGN TO UT-S-NEWPARTS.
           SELECT REPORT-FILE-OUT   ASSIGN TO UT-S-REPORT.
       DATA DIVISION.
       FILE SECTION.
       FD  OLD-PARTS-MF-IN
           RECORDING MODE IS F
           LABEL RECORDS ARE STANDARD
           RECORD CONTAINS 100 CHARACTERS
           BLOCK CONTAINS 0 RECORDS
           DATA RECORD IS OLD-MF-RECORD.
       01  OLD-MF-RECORD                       PIC  X(100).
       FD  CUR-ACT-FILE-IN
           RECORDING MODE IS F
           LABEL RECORDS ARE STANDARD
           RECORD CONTAINS 80 CHARACTERS
           BLOCK CONTAINS 0 RECORDS
           DATA RECORD IS CUR-ACT-RECORD.
       01  CUR-ACT-RECORD                      PIC  X(80).
       FD  PROD-LINE-FILE-IN
           RECORDING MODE IS F
           LABEL RECORDS ARE STANDARD
           RECORD CONTAINS 80 CHARACTERS
           BLOCK CONTAINS 0 RECORDS
           DATA RECORD IS PROD-LINE-RECORD.
       01  PROD-LINE-RECORD                    PIC  X(80).
      *
       SD  SORT-WORK-FILE
           RECORD CONTAINS 80 CHARACTERS
           DATA RECORD IS SORT-WORK-REC.
       01  SORT-WORK-REC.
           05  SWF-PARTNO                      PIC  X(21).
           05  SWF-REST-OF-REC                 PIC  X(43).
           05  SWF-MODEL                       PIC  X(3).
           05  FILLER                          PIC  X(12).
           05  SWF-REC-PAY-CODE                PIC  X.
      *
       FD  NEW-PARTS-MF-OUT
           RECORDING MODE IS F
           LABEL RECORDS ARE STANDARD
           RECORD CONTAINS 100 CHARACTERS
           BLOCK CONTAINS 0 RECORDS
           DATA RECORD IS NEW-MF-RECORD.
       01  NEW-MF-RECORD                       PIC  X(100).
      *
       FD  REPORT-FILE-OUT
           RECORDING MODE IS F
           LABEL RECORDS ARE STANDARD
           RECORD CONTAINS 133 CHARACTERS
           BLOCK CONTAINS 0 RECORDS
           DATA RECORD IS REPORT-OUT-RECORD.
       01  REPORT-OUT-RECORD                   PIC  X(133).
      *
       WORKING-STORAGE SECTION.
       01  WS-OLD-MF-REC.
           05  OMF-PARTNO                      PIC  X(21).
           05  OMF-PROD-LINE                   PIC  X(2).
           05  OMF-ACCOUNT                     PIC  X(9).
           05  OMF-REC-QTY                     PIC S9(7).
           05  OMF-REC-AMT                     PIC S9(8)V99.
           05  OMF-PAY-QTY                     PIC S9(7).
           05  OMF-PAY-AMT                     PIC S9(8)V99.
           05  OMF-PARTNAME                    PIC  X(15).
           05  OMF-LAST-ACTY.
               10  OMF-MON                     PIC  X(2).
               10  OMF-YR                      PIC  X(2).
               10  OMF-DAY                     PIC  X(2).
           05  FILLER                          PIC  X(13).
      *
       01  WS-CUR-ACT-REC.
           05  AF-PARTNO                       PIC  X(21).
           05  AF-REST-OF-REC.
               10  AF-PROD-LINE                PIC  X(2).
               10  AF-ACCOUNT                  PIC  X(9).
               10  AF-QTY                      PIC S9(7).
               10  AF-AMT                      PIC S9(8)V99.
               10  AF-PARTNAME                 PIC  X(15).
           05  AF-MODEL                        PIC  X(3).
           05  FILLER                          PIC  X(12) VALUE SPACE.
           05  AF-REC-PAY-CODE                 PIC  X.
      *
       01  WS-PROD-LINE-REC.
           05  PLF-PROD-LINE                   PIC  X(2).
           05  PLF-MODEL                       PIC  X(3).
           05  FILLER                          PIC  X(75).
      *
       01  WS-DATE-LINE.
           05  FILLER                          PIC  X(104) VALUE SPACE.
           05  FILLER                          PIC  X(6)
                      VALUE 'DATE  '.
           05  WS-DATE-OUT                     PIC  X(8).
           05  FILLER                          PIC  X(17) VALUE SPACE.
      *
       01  WS-TITLE-LINE.
           05  FILLER                          PIC  X(41)
                      VALUE ' REPORT 12345'.
           05  FILLER                          PIC  X(63)
                      VALUE 'PURCHASE PARTS RECEIVED-PAID REPORT'.
           05  FILLER                          PIC  X(6)
                      VALUE 'PAGE  '.
           05  WS-PAGE-OUT                     PIC  Z,ZZ9.
           05  FILLER                          PIC  X(20) VALUE SPACE.
      *
       01  WS-HEADING-LINE-1.
           05  FILLER                          PIC  X(25)
                      VALUE '   PART NUMBER'.
           05  FILLER                          PIC  X(11)
                      VALUE 'PL  MOD'.
           05  FILLER                          PIC  X(15)
                      VALUE 'PART NAME'.
           05  FILLER                          PIC  X(10)
                      VALUE 'ACCOUNT'.
           05  FILLER                          PIC  X(28)
                      VALUE '******* RECEIPTS *******'.
           05  FILLER                          PIC  X(27)
                      VALUE '******* PAYMENTS *******'.
           05  FILLER                          PIC  X(17)
                      VALUE 'LAST ACTY'.
      *
       01  WS-HEADING-LINE-2.
           05  FILLER                          PIC  X(62) VALUE SPACE.
           05  FILLER                          PIC  X(13)
                      VALUE 'QUANTITY'.
           05  FILLER                          PIC  X(15)
                      VALUE 'DOLLARS'.
           05  FILLER                          PIC  X(13)
                      VALUE 'QUANTITY'.
           05  FILLER                          PIC  X(30)
                      VALUE 'DOLLARS'.
      *
       01  WS-DETAIL-LINE.
           05  FILLER                          PIC  X(1) VALUE SPACE.
           05  DL-PARTNO-OUT                   PIC  X(21).
           05  FILLER                          PIC  X(3) VALUE SPACE.
           05  DL-PROD-LINE-OUT                PIC  X(2).
           05  FILLER                          PIC  X(2) VALUE SPACE.
           05  DL-MODEL-OUT                    PIC  X(3).
           05  FILLER                          PIC  X(2) VALUE SPACE.
           05  DL-PARTNAME-OUT                 PIC  X(15).
           05  FILLER                          PIC  X VALUE SPACE.
           05  DL-ACCOUNT-OUT                  PIC  X(9).
           05  FILLER                          PIC  X(2) VALUE SPACE.
           05  DL-REC-QTY-OUT                  PIC  Z,ZZZ,ZZ9-.
           05  FILLER                          PIC  X VALUE SPACE.
           05  DL-REC-AMT-OUT                  PIC  ZZ,ZZZ,ZZ9.99-.
           05  FILLER                          PIC  X(3) VALUE SPACE.
           05  DL-PAY-QTY-OUT                  PIC  Z,ZZZ,ZZ9-.
           05  FILLER                          PIC  X VALUE SPACE.
           05  DL-PAY-AMT-OUT                  PIC  ZZ,ZZZ,ZZ9.99-.
           05  FILLER                          PIC  X(19) VALUE SPACE.
      *
       01  WS-TOTAL-LINE.
           05  FILLER                          PIC  X(3) VALUE SPACE.
           05  TL-TYPE-OUT                     PIC  X(7).
           05  FILLER                          PIC  X(28)
                      VALUE ' PART NUMBER TOTAL FOR PART '.
           05  TL-PARTNO-OUT                   PIC  X(21).
           05  FILLER                          PIC  X(2) VALUE SPACE.
           05  TL-LINE-VALUES.
               10  TL-REC-QTY-OUT              PIC  Z,ZZZ,ZZ9-.
               10  FILLER                      PIC  X VALUE SPACE.
               10  TL-REC-AMT-OUT              PIC  ZZ,ZZZ,ZZ9.99-.
               10  FILLER                      PIC  X(3) VALUE SPACE.
               10  TL-PAY-QTY-OUT              PIC  Z,ZZZ,ZZ9-.
               10  FILLER                      PIC  X VALUE SPACE.
               10  TL-PAY-AMT-OUT              PIC  ZZ,ZZZ,ZZ9.99-.
               10  FILLER                      PIC  X(3) VALUE SPACE.
               10  TL-LAST-ACTY-OUT            PIC  X(6).
           05  FILLER                          PIC  X(11) VALUE SPACE.
      *
       01  WS-GRAND-TOTAL-LINE.
           05  FILLER                          PIC  X(3) VALUE SPACE.
           05  GTL-TYPE-OUT                    PIC  X(7).
           05  FILLER                          PIC  X(51)
                      VALUE '  GRAND TOTAL'.
           05  GTL-LINE-VALUES.
               10  GTL-REC-QTY-OUT             PIC  Z,ZZZ,ZZ9-.
               10  FILLER                      PIC  X VALUE SPACE.
               10  GTL-REC-AMT-OUT             PIC  ZZ,ZZZ,ZZ9.99-.
               10  FILLER                      PIC  X(3) VALUE SPACE.
               10  GTL-PAY-QTY-OUT             PIC  Z,ZZZ,ZZ9-.
               10  FILLER                      PIC  X VALUE SPACE.
               10  GTL-PAY-AMT-OUT             PIC  ZZ,ZZZ,ZZ9.99-.
           05  FILLER                          PIC  X(20) VALUE SPACE.
      *
       01  PRODUCT-LINE-TABLE.
           05  PROD-LINE-TBL OCCURS 50 TIMES
                         INDEXED BY PROD-NDX.
               10  PLT-PROD-LINE               PIC  X(2).
               10  PLT-MODEL                   PIC  X(3).
      *
       01  MONTH-TABLE-DEFINITION.
           05  MONTH-DATA.
               10  FILLER               PIC  X(5) VALUE '01JAN'.
               10  FILLER               PIC  X(5) VALUE '02FEB'.
               10  FILLER               PIC  X(5) VALUE '03MAR'.
               10  FILLER               PIC  X(5) VALUE '04APR'.
               10  FILLER               PIC  X(5) VALUE '05MAY'.
               10  FILLER               PIC  X(5) VALUE '06JUN'.
               10  FILLER               PIC  X(5) VALUE '07JUL'.
               10  FILLER               PIC  X(5) VALUE '08AUG'.
               10  FILLER               PIC  X(5) VALUE '09SEP'.
               10  FILLER               PIC  X(5) VALUE '10OCT'.
               10  FILLER               PIC  X(5) VALUE '11NOV'.
               10  FILLER               PIC  X(5) VALUE '12DEC'.
           05  MONTH-TABLE REDEFINES MONTH-DATA.
               10  MONTHS-TBL  OCCURS 12 TIMES  INDEXED BY MT-NDX.
                   15  MT-CODE          PIC  X(2).
                   15  MT-MONTH         PIC  X(3).
      *
       01  WS-HOLD-AREAS.
           05  WS-MF-HOLD-AREA                 PIC  X(100) VALUE SPACE.
           05  TH-DATE.
               10  WS-YR                       PIC  X(2).
               10  WS-MON                      PIC  X(2).
               10  WS-DAY                      PIC  X(2).
               10  FILLER                      PIC  X(2).
           05  MF-DATE.
               10  MF-YR                       PIC  X(2).
               10  MF-MON                      PIC  X(2).
               10  MF-DAY                      PIC  X(2).
               10  FILLER                      PIC  X(2).
           05  WS-GDATE.
               10  WS-MONTH                    PIC  X(3).
               10  FILLER                      PIC  X(1) VALUE SPACE.
               10  WS-YEARS                    PIC  X(2).
      *
       01  ACCUMULATORS.
           05  AC-CUR-REC-QTY           PIC S9(7)    COMP-3 VALUE ZERO.
           05  AC-CUR-REC-AMT           PIC S9(8)V99 COMP-3 VALUE ZERO.
           05  AC-TOD-REC-QTY           PIC S9(7)    COMP-3 VALUE ZERO.
           05  AC-TOD-REC-AMT           PIC S9(8)V99 COMP-3 VALUE ZERO.
           05  AC-CUR-PAY-QTY           PIC S9(7)    COMP-3 VALUE ZERO.
           05  AC-CUR-PAY-AMT           PIC S9(8)V99 COMP-3 VALUE ZERO.
           05  AC-TOD-PAY-QTY           PIC S9(7)    COMP-3 VALUE ZERO.
           05  AC-TOD-PAY-AMT           PIC S9(8)V99 COMP-3 VALUE ZERO.
           05  AC-GTL-CUR-REC-QTY       PIC S9(7)    COMP-3 VALUE ZERO.
           05  AC-GTL-CUR-REC-AMT       PIC S9(8)V99 COMP-3 VALUE ZERO.
           05  AC-GTL-TOD-REC-QTY       PIC S9(7)    COMP-3 VALUE ZERO.
           05  AC-GTL-TOD-REC-AMT       PIC S9(8)V99 COMP-3 VALUE ZERO.
           05  AC-GTL-CUR-PAY-QTY       PIC S9(7)    COMP-3 VALUE ZERO.
           05  AC-GTL-CUR-PAY-AMT       PIC S9(8)V99 COMP-3 VALUE ZERO.
           05  AC-GTL-TOD-PAY-QTY       PIC S9(7)    COMP-3 VALUE ZERO.
           05  AC-GTL-TOD-PAY-AMT       PIC S9(8)V99 COMP-3 VALUE ZERO.
           05  AC-RECS-REL-SRT          PIC S9(3)    COMP-3 VALUE ZERO.
           05  AC-RECS-RET-SRT          PIC S9(3)    COMP-3 VALUE ZERO.
           05  AC-PROD-IN               PIC S9(3)    COMP-3 VALUE ZERO.
           05  AC-ACT-IN                PIC S9(3)    COMP-3 VALUE ZERO.
           05  AC-ACT-BYPASS            PIC S9(3)    COMP-3 VALUE ZERO.
           05  AC-MASTER-IN             PIC S9(3)    COMP-3 VALUE ZERO.
           05  AC-MASTER-OUT            PIC S9(3)    COMP-3 VALUE ZERO.
      *
       01  REPORT-CONTROLS.
           05  RC-PAGE-NUM              PIC S9(3) COMP-3 VALUE ZERO.
           05  RC-LINE-COUNT            PIC S9(2) COMP-3 VALUE ZERO.
           05  RC-LINES-PER-PAGE        PIC  9(2) VALUE 50.
           05  RC-PROPER-SPACING        PIC  9.
           05  RC-MSG-OUT               PIC ZZ9.
           05  RC-ERR-MSG               PIC X(35).
      *
       01  SWITCHES.
           05  SW-EOF-OMF               PIC  X VALUE 'N'.
               88  EOF-OMF                     VALUE 'Y'.
           05  SW-EOF-PROD              PIC  X VALUE 'N'.
               88  EOF-PROD                    VALUE 'Y'.
           05  SW-EOF-ACT               PIC  X VALUE 'N'.
               88  EOF-ACT                     VALUE 'Y'.
           05  SW-EOF-SRT               PIC  X VALUE 'N'.
               88  EOF-SRT                     VALUE 'Y'.
           05  SW-FOUND                 PIC  X VALUE 'Y'.
               88  MODEL-FOUND                 VALUE 'Y'.
           05  SW-VALID                 PIC  X VALUE 'Y'.
               88  RECORD-VALID                VALUE 'Y'.
           05  SW-NEW-MF                PIC  X VALUE 'N'.
               88  NEW-REC-WAITING             VALUE 'Y'.
      *
       PROCEDURE DIVISION.
       000-MAINLINE.
           PERFORM 100-INITIALIZE  THRU 100-EXIT.
           PERFORM 200-PROCESS     THRU 200-EXIT.
           PERFORM 300-TERMINATION THRU 300-EXIT.
           MOVE ZERO TO RETURN-CODE.
           GOBACK.
       000-EXIT.
           EXIT.
      *
       100-INITIALIZE.
           DISPLAY '***** BEGIN B999KAD3 *****'.
           DISPLAY ' '.
           OPEN INPUT OLD-PARTS-MF-IN
                INPUT CUR-ACT-FILE-IN
                INPUT PROD-LINE-FILE-IN
               OUTPUT NEW-PARTS-MF-OUT
               OUTPUT REPORT-FILE-OUT.
           PERFORM 105-READ-PROD THRU 105-EXIT.
           IF EOF-PROD THEN
               DISPLAY '*** PROD FILE EMPTY ***'
               GOBACK.
           SET PROD-NDX TO 1.
           PERFORM 110-LOAD-PROD-TABLE THRU 110-EXIT
               UNTIL EOF-PROD.
           CLOSE PROD-LINE-FILE-IN.
           MOVE  1 TO RC-PAGE-NUM.
           MOVE 99 TO RC-LINE-COUNT.
           ACCEPT TH-DATE FROM DATE.
           ACCEPT WS-DATE-OUT FROM DATE.
           ACCEPT MF-DATE FROM DATE.
           PERFORM 229-READ-ACTIVITY THRU 229-EXIT.
           IF EOF-ACT THEN
               DISPLAY '*** DATA FILE EMPTY ***'
               GOBACK.
           PERFORM 278-HEADINGS THRU 278-EXIT.
       100-EXIT.
           EXIT.
      *
       105-READ-PROD.
           READ PROD-LINE-FILE-IN
               INTO WS-PROD-LINE-REC
                   AT END MOVE 'Y' TO SW-EOF-PROD.
           IF NOT EOF-PROD THEN
               ADD 1 TO AC-PROD-IN.
       105-EXIT.
           EXIT.
      *
       110-LOAD-PROD-TABLE.
           MOVE PLF-PROD-LINE TO PLT-PROD-LINE (PROD-NDX).
           MOVE PLF-MODEL     TO PLT-MODEL (PROD-NDX).
           SET PROD-NDX UP BY 1.
           PERFORM 105-READ-PROD THRU 105-EXIT.
       110-EXIT.
           EXIT.
      *
       200-PROCESS.
           SORT SORT-WORK-FILE
               ASCENDING KEY SWF-PARTNO
                   INPUT  PROCEDURE 220-INPUT-PROCEDURE
                   OUTPUT PROCEDURE 250-OUTPUT-PROCEDURE.
       200-EXIT.
           EXIT.
      *
      *
      *
       220-INPUT-PROCEDURE SECTION.
           PERFORM 222-SELECT-RECS  THRU 222-EXIT
               UNTIL EOF-ACT.
       220-EXIT-IP SECTION.
      *
       222-SELECT-RECS.
           PERFORM 230-EDITS THRU 230-EXIT
           IF RECORD-VALID THEN
               PERFORM 232-LOOKUP-MODEL THRU 232-EXIT
               IF MODEL-FOUND THEN
                   PERFORM 233-PREP-SRT-REC         THRU 233-EXIT
                   PERFORM 240-RELEASE-ACTIVITY-REC THRU 240-EXIT
               ELSE
                   DISPLAY 'MODEL NOT FOUND - ' WS-CUR-ACT-REC
                   ADD 1 TO AC-ACT-BYPASS
           ELSE
               DISPLAY RC-ERR-MSG WS-CUR-ACT-REC
               ADD 1 TO AC-ACT-BYPASS.
           PERFORM 229-READ-ACTIVITY THRU 229-EXIT.
       222-EXIT.
           EXIT.
      *
       229-READ-ACTIVITY.
           READ CUR-ACT-FILE-IN
               INTO WS-CUR-ACT-REC
                   AT END MOVE 'Y' TO SW-EOF-ACT.
           IF NOT EOF-ACT THEN
               ADD 1 TO AC-ACT-IN.
       229-EXIT.
           EXIT.
      *
       230-EDITS.
           MOVE 'Y' TO SW-VALID.
           IF AF-QTY NOT NUMERIC OR AF-AMT NOT NUMERIC THEN
               MOVE 'N' TO SW-VALID
               MOVE 'RECORD IN ERROR-INVALID AMT/QTY: ' TO RC-ERR-MSG
               GO TO 230-EXIT.
           IF AF-REC-PAY-CODE = 'P' OR AF-REC-PAY-CODE = 'R' THEN
               NEXT SENTENCE
           ELSE
               MOVE 'N' TO SW-VALID
               MOVE 'RECORD IN ERROR-INVALID CODE:    ' TO RC-ERR-MSG.
       230-EXIT.
           EXIT.
      *
       232-LOOKUP-MODEL.
           MOVE 'Y' TO SW-FOUND.
           SET PROD-NDX TO 1.
           SEARCH PROD-LINE-TBL
               AT END MOVE 'N' TO SW-FOUND
               WHEN AF-PROD-LINE = PLT-PROD-LINE (PROD-NDX)
                   MOVE PLT-MODEL (PROD-NDX) TO SWF-MODEL.
       232-EXIT.
           EXIT.
      *
       233-PREP-SRT-REC.
           IF MODEL-FOUND THEN
               MOVE AF-PARTNO       TO SWF-PARTNO
               MOVE AF-REST-OF-REC  TO SWF-REST-OF-REC
               MOVE AF-REC-PAY-CODE TO SWF-REC-PAY-CODE
           ELSE
               DISPLAY 'NAME NOT FOUND IN TBL - ' WS-CUR-ACT-REC.
       233-EXIT.
           EXIT.
      *
       240-RELEASE-ACTIVITY-REC.
           RELEASE SORT-WORK-REC.
           ADD 1 TO AC-RECS-REL-SRT.
       240-EXIT.
           EXIT.
      *
      *
      *
       250-OUTPUT-PROCEDURE SECTION.
           PERFORM 280-RETURN-ACTIVITY-RECORD THRU 280-EXIT.
           PERFORM 285-READ-OLD-MASTER        THRU 285-EXIT.
           PERFORM 255-PROCESS-MF             THRU 255-EXIT
               UNTIL EOF-SRT AND EOF-OMF.
       250-EXIT-OP SECTION.
      *
      *
      *
       255-PROCESS-MF.
           IF AF-PARTNO = OMF-PARTNO THEN
               PERFORM 260-UPDATE-OLD-MASTER      THRU 260-EXIT
               PERFORM 265-PREP-PRINT-LINE        THRU 265-EXIT
               PERFORM 280-RETURN-ACTIVITY-RECORD THRU 280-EXIT
           ELSE
               IF AF-PARTNO > OMF-PARTNO THEN
                   PERFORM 290-WRITE-NEW-MF    THRU 290-EXIT
                   PERFORM 275-PART-TOTALS     THRU 275-EXIT
                   PERFORM 285-READ-OLD-MASTER THRU 285-EXIT
               ELSE
                   PERFORM 262-CREATE-NEW-MF THRU 262-EXIT.
       255-EXIT.
           EXIT.
      *
       260-UPDATE-OLD-MASTER.
           IF AF-REC-PAY-CODE = 'R' THEN
               ADD  AF-QTY TO OMF-REC-QTY AC-CUR-REC-QTY AC-TOD-REC-QTY
               ADD  AF-AMT TO OMF-REC-AMT AC-CUR-REC-AMT AC-TOD-REC-AMT
               MOVE AF-QTY TO DL-REC-QTY-OUT
               MOVE AF-AMT TO DL-REC-AMT-OUT
               MOVE ZERO   TO DL-PAY-QTY-OUT DL-PAY-AMT-OUT
           ELSE
               ADD  AF-QTY TO OMF-PAY-QTY AC-CUR-PAY-QTY AC-TOD-PAY-QTY
               ADD  AF-AMT TO OMF-PAY-AMT AC-CUR-PAY-AMT AC-TOD-PAY-AMT
               MOVE AF-QTY TO DL-PAY-QTY-OUT
               MOVE AF-AMT TO DL-PAY-AMT-OUT
               MOVE ZERO   TO DL-REC-QTY-OUT DL-REC-AMT-OUT.
           MOVE AF-PROD-LINE TO OMF-PROD-LINE.
           MOVE AF-ACCOUNT   TO OMF-ACCOUNT.
           MOVE AF-PARTNAME  TO OMF-PARTNAME.
           MOVE MF-DATE      TO OMF-LAST-ACTY.
           PERFORM 276-LOOKUP-MONTH THRU 276-EXIT.
       260-EXIT.
           EXIT.
      *
       262-CREATE-NEW-MF.
           MOVE SPACES        TO WS-OLD-MF-REC.
           MOVE WS-OLD-MF-REC TO WS-MF-HOLD-AREA.
           MOVE ZERO          TO OMF-REC-QTY.
           MOVE ZERO          TO OMF-REC-AMT.
           MOVE ZERO          TO OMF-PAY-QTY.
           MOVE ZERO          TO OMF-PAY-AMT.
           MOVE AF-PARTNO     TO OMF-PARTNO.
       262-EXIT.
           EXIT.
      *
       265-PREP-PRINT-LINE.
           IF RC-LINE-COUNT > RC-LINES-PER-PAGE THEN
               PERFORM 278-HEADINGS THRU 278-EXIT.
           MOVE AF-PARTNO    TO DL-PARTNO-OUT.
           MOVE AF-PROD-LINE TO DL-PROD-LINE-OUT.
           MOVE AF-MODEL     TO DL-MODEL-OUT.
           MOVE AF-PARTNAME  TO DL-PARTNAME-OUT.
           MOVE AF-ACCOUNT   TO DL-ACCOUNT-OUT.
           WRITE REPORT-OUT-RECORD FROM WS-DETAIL-LINE
               AFTER ADVANCING RC-PROPER-SPACING.
           ADD RC-PROPER-SPACING TO RC-LINE-COUNT.
           MOVE 1 TO RC-PROPER-SPACING.
       265-EXIT.
           EXIT.
      *
       275-PART-TOTALS.
           MOVE SPACES           TO TL-LINE-VALUES.
           MOVE 'CURRENT'        TO TL-TYPE-OUT.
           MOVE OMF-PARTNO       TO TL-PARTNO-OUT.
           MOVE AC-CUR-REC-QTY   TO TL-REC-QTY-OUT.
           MOVE AC-CUR-REC-AMT   TO TL-REC-AMT-OUT.
           MOVE AC-CUR-PAY-QTY   TO TL-PAY-QTY-OUT.
           MOVE AC-CUR-PAY-AMT   TO TL-PAY-AMT-OUT.
           WRITE REPORT-OUT-RECORD FROM WS-TOTAL-LINE
               AFTER ADVANCING 2.
           MOVE 'TO-DATE'        TO TL-TYPE-OUT.
           MOVE AC-TOD-REC-QTY   TO TL-REC-QTY-OUT.
           MOVE AC-TOD-REC-AMT   TO TL-REC-AMT-OUT.
           MOVE AC-TOD-PAY-QTY   TO TL-PAY-QTY-OUT.
           MOVE AC-TOD-PAY-AMT   TO TL-PAY-AMT-OUT.
           MOVE OMF-MON          TO WS-MON.
           MOVE OMF-YR           TO WS-YR.
           PERFORM 276-LOOKUP-MONTH THRU 276-EXIT.
           MOVE WS-GDATE         TO TL-LAST-ACTY-OUT.
           WRITE REPORT-OUT-RECORD FROM WS-TOTAL-LINE
               AFTER ADVANCING 1.
           MOVE SPACES TO REPORT-OUT-RECORD.
           WRITE REPORT-OUT-RECORD
               AFTER ADVANCING 1.
           ADD  3 TO RC-LINE-COUNT.
           MOVE 2 TO RC-PROPER-SPACING.
           ADD AC-CUR-REC-QTY    TO AC-GTL-CUR-REC-QTY.
           ADD AC-CUR-REC-AMT    TO AC-GTL-CUR-REC-AMT.
           ADD AC-CUR-PAY-QTY    TO AC-GTL-CUR-PAY-QTY.
           ADD AC-CUR-PAY-AMT    TO AC-GTL-CUR-PAY-AMT.
           ADD AC-TOD-REC-QTY    TO AC-GTL-TOD-REC-QTY.
           ADD AC-TOD-REC-AMT    TO AC-GTL-TOD-REC-AMT.
           ADD AC-TOD-PAY-QTY    TO AC-GTL-TOD-PAY-QTY.
           ADD AC-TOD-PAY-AMT    TO AC-GTL-TOD-PAY-AMT.
           MOVE ZERO             TO AC-CUR-REC-QTY.
           MOVE ZERO             TO AC-CUR-REC-AMT.
           MOVE ZERO             TO AC-CUR-PAY-QTY.
           MOVE ZERO             TO AC-CUR-PAY-AMT.
           MOVE ZERO             TO AC-TOD-REC-QTY.
           MOVE ZERO             TO AC-TOD-REC-AMT.
           MOVE ZERO             TO AC-TOD-PAY-QTY.
           MOVE ZERO             TO AC-TOD-PAY-AMT.
       275-EXIT.
           EXIT.
      *
       276-LOOKUP-MONTH.
           SET MT-NDX TO 1.
           SEARCH MONTHS-TBL
               AT END DISPLAY '*** DATE ERROR ***'
               WHEN WS-MON = MT-CODE (MT-NDX)
                   MOVE MT-MONTH (MT-NDX) TO WS-MONTH.
           MOVE WS-YR TO WS-YEARS.
       276-EXIT.
           EXIT.
      *
       278-HEADINGS.
           MOVE RC-PAGE-NUM TO WS-PAGE-OUT.
           WRITE REPORT-OUT-RECORD FROM WS-DATE-LINE
               AFTER ADVANCING PAGE.
           WRITE REPORT-OUT-RECORD FROM WS-TITLE-LINE
               AFTER ADVANCING 2.
           WRITE REPORT-OUT-RECORD FROM WS-HEADING-LINE-1
               AFTER ADVANCING 3.
           WRITE REPORT-OUT-RECORD FROM WS-HEADING-LINE-2
               AFTER ADVANCING 1.
           MOVE  2  TO RC-PROPER-SPACING.
           MOVE  7  TO RC-LINE-COUNT.
           ADD   1  TO RC-PAGE-NUM.
       278-EXIT.
           EXIT.
      *
       280-RETURN-ACTIVITY-RECORD.
           RETURN SORT-WORK-FILE
               INTO WS-CUR-ACT-REC
                   AT END MOVE 'Y' TO SW-EOF-SRT
                          MOVE HIGH-VALUES TO AF-PARTNO.
           IF NOT EOF-SRT
               ADD 1 TO AC-RECS-RET-SRT.
       280-EXIT.
           EXIT.
      *
       285-READ-OLD-MASTER.
           IF WS-MF-HOLD-AREA NOT = SPACES
               MOVE WS-MF-HOLD-AREA TO WS-OLD-MF-REC
               MOVE SPACES TO WS-MF-HOLD-AREA
               MOVE OMF-REC-QTY TO AC-TOD-REC-QTY
               MOVE OMF-REC-AMT TO AC-TOD-REC-AMT
               MOVE OMF-PAY-QTY TO AC-TOD-PAY-QTY
               MOVE OMF-PAY-AMT TO AC-TOD-PAY-AMT
               GO TO 285-EXIT.
           READ OLD-PARTS-MF-IN
               INTO WS-OLD-MF-REC
                   AT END MOVE 'Y' TO SW-EOF-OMF
                          MOVE HIGH-VALUES TO OMF-PARTNO.
           IF NOT EOF-OMF THEN
               ADD 1 TO AC-MASTER-IN
               MOVE OMF-REC-QTY TO AC-TOD-REC-QTY
               MOVE OMF-REC-AMT TO AC-TOD-REC-AMT
               MOVE OMF-PAY-QTY TO AC-TOD-PAY-QTY
               MOVE OMF-PAY-AMT TO AC-TOD-PAY-AMT.
       285-EXIT.
           EXIT.
      *
       290-WRITE-NEW-MF.
           WRITE NEW-MF-RECORD FROM WS-OLD-MF-REC.
           ADD 1 TO AC-MASTER-OUT.
       290-EXIT.
           EXIT.
      *
       300-TERMINATION.
           PERFORM 275-PART-TOTALS  THRU 275-EXIT.
           PERFORM 310-GRAND-TOTALS THRU 310-EXIT.
           CLOSE OLD-PARTS-MF-IN
                 NEW-PARTS-MF-OUT
                 CUR-ACT-FILE-IN
                 REPORT-FILE-OUT.
      ****************************************
      ****     DISPLAY REPORT CONTROLS    ****
      ****************************************
           MOVE AC-PROD-IN      TO RC-MSG-OUT.
           DISPLAY 'PRODUCT LINE IN    ' RC-MSG-OUT.
           DISPLAY ' '.
           MOVE AC-ACT-IN       TO RC-MSG-OUT.
           DISPLAY 'ACTIVITY IN        ' RC-MSG-OUT.
           MOVE AC-ACT-BYPASS   TO RC-MSG-OUT.
           DISPLAY 'ACTIVITY BYPASSED  ' RC-MSG-OUT.
           DISPLAY ' '.
           MOVE AC-MASTER-IN    TO RC-MSG-OUT.
           DISPLAY 'MASTERS IN         ' RC-MSG-OUT.
           MOVE AC-MASTER-OUT   TO RC-MSG-OUT.
           DISPLAY 'MASTERS OUT        ' RC-MSG-OUT.
           DISPLAY ' '.
           MOVE AC-RECS-REL-SRT TO RC-MSG-OUT.
           DISPLAY 'RELEASED ACTIVITY  ' RC-MSG-OUT.
           MOVE AC-RECS-RET-SRT TO RC-MSG-OUT.
           DISPLAY 'RETURNED ACTIVITY  ' RC-MSG-OUT.
           DISPLAY ' '.
           DISPLAY '***** B999KAD3 EOJ *****'.
       300-EXIT.
           EXIT.
      *
       310-GRAND-TOTALS.
           MOVE 'CURRENT' TO GTL-TYPE-OUT.
           MOVE SPACES    TO GTL-LINE-VALUES.
           MOVE AC-GTL-CUR-REC-QTY TO GTL-REC-QTY-OUT.
           MOVE AC-GTL-CUR-REC-AMT TO GTL-REC-AMT-OUT.
           MOVE AC-GTL-CUR-PAY-QTY TO GTL-PAY-QTY-OUT.
           MOVE AC-GTL-CUR-PAY-AMT TO GTL-PAY-AMT-OUT.
           WRITE REPORT-OUT-RECORD FROM WS-GRAND-TOTAL-LINE
               AFTER ADVANCING 3.
           MOVE 'TO-DATE' TO GTL-TYPE-OUT.
           MOVE SPACES    TO GTL-LINE-VALUES.
           MOVE AC-GTL-TOD-REC-QTY TO GTL-REC-QTY-OUT.
           MOVE AC-GTL-TOD-REC-AMT TO GTL-REC-AMT-OUT.
           MOVE AC-GTL-TOD-PAY-QTY TO GTL-PAY-QTY-OUT.
           MOVE AC-GTL-TOD-PAY-AMT TO GTL-PAY-AMT-OUT.
           WRITE REPORT-OUT-RECORD FROM WS-GRAND-TOTAL-LINE
               AFTER ADVANCING 2.
       310-EXIT.
           EXIT.