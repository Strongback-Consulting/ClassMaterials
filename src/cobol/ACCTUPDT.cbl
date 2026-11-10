       IDENTIFICATION DIVISION.
       PROGRAM-ID.  ACCTUPDT.
       AUTHOR. Kenny Smith, Strongback Consulting.
       INSTALLATION. COBOL DEVELOPMENT CENTER.
       DATE-WRITTEN. 09/15/26.
       DATE-COMPILED. 09/15/26.
       SECURITY. NON-CONFIDENTIAL.

      ******************************************************************
      *REMARKS.
      *
      *   ACCTUPDT is a daily batch update for MERIDIAN TRUST BANK, a
      *   fictitious retail bank used for class exercises only.
      *
      *   It reads a sorted file of one day's account transactions
      *   (deposits, withdrawals, and service fees), validates each
      *   one against the account master, posts the good ones, and
      *   writes every rejected transaction plus an end-of-run
      *   summary to the transaction log.
      *
      *   This program is a fresh practice file for the "Work with
      *   COBOL Snippets" lab - safe to edit, break, and reload.
      *
      ******************************************************************

             INPUT FILE            - TRANFILE  (daily transactions)

             VSAM MASTER FILE      - ACCTMSTR  (account balances)

             OUTPUT FILE PRODUCED  - ACCTRPT   (transaction log)

      ******************************************************************

       ENVIRONMENT DIVISION.
       CONFIGURATION SECTION.
       SOURCE-COMPUTER. IBM-390.
       OBJECT-COMPUTER. IBM-390.

       INPUT-OUTPUT SECTION.
       FILE-CONTROL.
           SELECT TRANFILE
           ASSIGN TO UT-S-TRANFILE
             ACCESS MODE IS SEQUENTIAL
             FILE STATUS IS TRANFILE-STATUS.

           SELECT ACCTMSTR
                  ASSIGN       TO ACCTMSTR
                  ORGANIZATION IS INDEXED
                  ACCESS MODE  IS RANDOM
                  RECORD KEY   IS ACCT-NBR
                  FILE STATUS  IS ACCTMSTR-STATUS.

           SELECT ACCTRPT
           ASSIGN TO UT-S-ACCTRPT
             ACCESS MODE IS SEQUENTIAL
             FILE STATUS IS ACCTRPT-STATUS.

       DATA DIVISION.
       FILE SECTION.

      ****** ONE RECORD PER TRANSACTION, SORTED BY ACCOUNT NUMBER
       FD  TRANFILE
           RECORDING MODE IS F
           LABEL RECORDS ARE STANDARD
           RECORD CONTAINS 80 CHARACTERS
           BLOCK CONTAINS 0 RECORDS
           DATA RECORD IS TRAN-RECORD.
       01  TRAN-RECORD.
           05  TRAN-ACCOUNT-NBR       PIC X(10).
           05  TRAN-CODE              PIC X(01).
               88  TRAN-IS-DEPOSIT        VALUE "D".
               88  TRAN-IS-WITHDRAWAL     VALUE "W".
               88  TRAN-IS-FEE            VALUE "F".
           05  TRAN-DATE              PIC 9(08).
           05  TRAN-AMOUNT            PIC S9(7)V99.
           05  TRAN-DESCRIPTION       PIC X(20).
           05  FILLER                 PIC X(32).

      ****** VSAM KSDS KEYED ON ACCT-NBR - ONE ROW PER OPEN ACCOUNT
       FD  ACCTMSTR
           RECORD CONTAINS 100 CHARACTERS
           DATA RECORD IS ACCTMSTR-REC.
       01  ACCTMSTR-REC.
           05  ACCT-NBR               PIC X(10).
           05  ACCT-CUSTOMER-NAME     PIC X(30).
           05  ACCT-TYPE              PIC X(01).
               88  ACCT-IS-CHECKING       VALUE "C".
               88  ACCT-IS-SAVINGS        VALUE "S".
           05  ACCT-STATUS            PIC X(01).
               88  ACCT-IS-ACTIVE         VALUE "A".
               88  ACCT-IS-CLOSED         VALUE "X".
           05  ACCT-BALANCE           PIC S9(9)V99 COMP-3.
           05  ACCT-MIN-BALANCE       PIC S9(7)V99 COMP-3.
           05  ACCT-LAST-TRAN-DATE    PIC 9(08).
           05  FILLER                 PIC X(39).

       FD  ACCTRPT
           RECORDING MODE IS F
           LABEL RECORDS ARE STANDARD
           RECORD CONTAINS 133 CHARACTERS
           BLOCK CONTAINS 0 RECORDS
           DATA RECORD IS ACCTRPT-LINE.
       01  ACCTRPT-LINE               PIC X(133).

       WORKING-STORAGE SECTION.

       01  FILE-STATUS-CODES.
           05  TRANFILE-STATUS        PIC X(02).
               88  TRANFILE-OK            VALUE "00".
               88  TRANFILE-EOF           VALUE "10".
           05  ACCTMSTR-STATUS        PIC X(02).
               88  ACCTMSTR-OK            VALUE "00".
               88  ACCTMSTR-NOT-FOUND     VALUE "23".
           05  ACCTRPT-STATUS         PIC X(02).
               88  ACCTRPT-OK             VALUE "00".

       01  PROGRAM-SWITCHES.
           05  WS-EOF-TRANFILE-SW     PIC X(01) VALUE "N".
               88  NO-MORE-TRANSACTIONS   VALUE "Y".
           05  WS-TRAN-REJECTED-SW    PIC X(01) VALUE "N".
               88  TRAN-REJECTED          VALUE "Y".

       01  COUNTERS-AND-ACCUMULATORS.
           05  WS-TRANS-READ          PIC S9(7) COMP VALUE ZERO.
           05  WS-DEPOSITS-COUNT      PIC S9(7) COMP VALUE ZERO.
           05  WS-DEPOSITS-AMOUNT     PIC S9(9)V99 COMP-3 VALUE ZERO.
           05  WS-WITHDRAWALS-COUNT   PIC S9(7) COMP VALUE ZERO.
           05  WS-WITHDRAWALS-AMOUNT  PIC S9(9)V99 COMP-3 VALUE ZERO.
           05  WS-FEES-COUNT          PIC S9(7) COMP VALUE ZERO.
           05  WS-FEES-AMOUNT         PIC S9(9)V99 COMP-3 VALUE ZERO.
           05  WS-REJECTS-COUNT       PIC S9(7) COMP VALUE ZERO.
           05  WS-ACCTS-UPDATED       PIC S9(7) COMP VALUE ZERO.

       01  WORK-FIELDS.
           05  PARA-NAME              PIC X(40) VALUE SPACES.
           05  WS-RUN-DATE            PIC 9(08) VALUE ZERO.
           05  WS-REJECT-REASON       PIC X(30) VALUE SPACES.
           05  WS-ABEND-REASON        PIC X(50) VALUE SPACES.

      ****** WORKING-STORAGE COPY OF THE VSAM RECORD - READ INTO IT,
      ****** POST TO IT, THEN REWRITE ACCTMSTR-REC FROM IT
       01  WS-ACCTMSTR-REC.
           05  WS-ACCT-NBR            PIC X(10).
           05  WS-ACCT-CUSTOMER-NAME  PIC X(30).
           05  WS-ACCT-TYPE           PIC X(01).
               88  WS-ACCT-IS-CHECKING    VALUE "C".
               88  WS-ACCT-IS-SAVINGS     VALUE "S".
           05  WS-ACCT-STATUS         PIC X(01).
               88  WS-ACCT-IS-ACTIVE      VALUE "A".
               88  WS-ACCT-IS-CLOSED      VALUE "X".
           05  WS-ACCT-BALANCE        PIC S9(9)V99 COMP-3.
           05  WS-ACCT-MIN-BALANCE    PIC S9(7)V99 COMP-3.
           05  WS-ACCT-LAST-TRAN-DATE PIC 9(08).
           05  FILLER                 PIC X(39).

       01  WS-RPT-TITLE-LINE.
           05  FILLER                 PIC X(40) VALUE SPACES.
           05  FILLER                 PIC X(46)
               VALUE "MERIDIAN TRUST BANK - DAILY TRANSACTION LOG".
           05  FILLER                 PIC X(47) VALUE SPACES.

       01  WS-RPT-COLUMN-HEADINGS.
           05  FILLER                 PIC X(14) VALUE "ACCOUNT NBR".
           05  FILLER                 PIC X(06) VALUE "TYPE".
           05  FILLER                 PIC X(18) VALUE "AMOUNT".
           05  FILLER                 PIC X(30) VALUE "REASON".
           05  FILLER                 PIC X(65) VALUE SPACES.

       01  WS-RPT-REJECT-LINE.
           05  FILLER                 PIC X(04) VALUE "*** ".
           05  RPT-REJ-ACCOUNT-NBR    PIC X(10).
           05  FILLER                 PIC X(02) VALUE SPACES.
           05  RPT-REJ-TRAN-CODE      PIC X(01).
           05  FILLER                 PIC X(03) VALUE SPACES.
           05  RPT-REJ-AMOUNT         PIC $$$,$$$,$$9.99-.
           05  FILLER                 PIC X(02) VALUE SPACES.
           05  RPT-REJ-REASON         PIC X(30).
           05  FILLER                 PIC X(66) VALUE SPACES.

       01  WS-RPT-TOTAL-LINE.
           05  FILLER                 PIC X(04) VALUE SPACES.
           05  RPT-TOTAL-LABEL        PIC X(22).
           05  FILLER                 PIC X(02) VALUE SPACES.
           05  RPT-TOTAL-COUNT        PIC ZZZ,ZZ9.
           05  FILLER                 PIC X(06) VALUE " FOR $".
           05  RPT-TOTAL-AMOUNT       PIC $$$,$$$,$$9.99.
           05  FILLER                 PIC X(78) VALUE SPACES.

       PROCEDURE DIVISION.
           PERFORM 000-INITIALIZE THRU 000-EXIT.
           PERFORM 100-PROCESS-ONE-TRANSACTION THRU 100-EXIT
                   UNTIL NO-MORE-TRANSACTIONS.
           PERFORM 800-PRODUCE-SUMMARY-REPORT THRU 800-EXIT.
           PERFORM 900-CLEANUP THRU 900-EXIT.
           MOVE ZERO TO RETURN-CODE.
           GOBACK.

       000-INITIALIZE.
           MOVE "000-INITIALIZE" TO PARA-NAME.
           DISPLAY "***** ACCTUPDT - DAILY TRANSACTION UPDATE *****".

           ACCEPT WS-RUN-DATE FROM DATE YYYYMMDD.

           OPEN INPUT TRANFILE.
           IF NOT TRANFILE-OK
               MOVE "UNABLE TO OPEN TRANFILE" TO WS-ABEND-REASON
               PERFORM 1000-ABEND-RTN THRU 1000-EXIT
           END-IF.

           OPEN I-O ACCTMSTR.
           IF NOT ACCTMSTR-OK
               MOVE "UNABLE TO OPEN ACCTMSTR" TO WS-ABEND-REASON
               PERFORM 1000-ABEND-RTN THRU 1000-EXIT
           END-IF.

           OPEN OUTPUT ACCTRPT.
           IF NOT ACCTRPT-OK
               MOVE "UNABLE TO OPEN ACCTRPT" TO WS-ABEND-REASON
               PERFORM 1000-ABEND-RTN THRU 1000-EXIT
           END-IF.

           PERFORM 050-WRITE-REPORT-HEADERS THRU 050-EXIT.
           PERFORM 200-READ-TRANFILE THRU 200-EXIT.
       000-EXIT.
           EXIT.

       050-WRITE-REPORT-HEADERS.
           MOVE "050-WRITE-REPORT-HEADERS" TO PARA-NAME.
           WRITE ACCTRPT-LINE FROM WS-RPT-TITLE-LINE.
           MOVE SPACES TO ACCTRPT-LINE.
           WRITE ACCTRPT-LINE.
           WRITE ACCTRPT-LINE FROM WS-RPT-COLUMN-HEADINGS.
       050-EXIT.
           EXIT.

       100-PROCESS-ONE-TRANSACTION.
           MOVE "100-PROCESS-ONE-TRANSACTION" TO PARA-NAME.
           ADD 1 TO WS-TRANS-READ.

           PERFORM 300-VALIDATE-TRANSACTION THRU 300-EXIT.

           IF TRAN-REJECTED
               PERFORM 700-WRITE-REJECT-LINE THRU 700-EXIT
           ELSE
               EVALUATE TRUE
                   WHEN TRAN-IS-DEPOSIT
                       PERFORM 400-POST-DEPOSIT THRU 400-EXIT
                   WHEN TRAN-IS-WITHDRAWAL
                       PERFORM 500-POST-WITHDRAWAL THRU 500-EXIT
                   WHEN TRAN-IS-FEE
                       PERFORM 600-POST-FEE THRU 600-EXIT
               END-EVALUATE
           END-IF.

           PERFORM 200-READ-TRANFILE THRU 200-EXIT.
       100-EXIT.
           EXIT.

       200-READ-TRANFILE.
           MOVE "200-READ-TRANFILE" TO PARA-NAME.
           READ TRANFILE
               AT END
                   MOVE "Y" TO WS-EOF-TRANFILE-SW
           END-READ.
       200-EXIT.
           EXIT.

       300-VALIDATE-TRANSACTION.
           MOVE "300-VALIDATE-TRANSACTION" TO PARA-NAME.
           MOVE "N" TO WS-TRAN-REJECTED-SW.
           MOVE SPACES TO WS-REJECT-REASON.
           EXEC CICS INQUIRE
                     PROGRAM(abc123)
                     ENTRYPOINT(ACCT-BALANCE )
                     LOADPOINT(ACCT-BALANCE )
                     LENGTH(dfheigdi )
                     NOHANDLE
           END-EXEC.
           IF NOT TRAN-IS-DEPOSIT AND NOT TRAN-IS-WITHDRAWAL
                                   AND NOT TRAN-IS-FEE
               MOVE "Y" TO WS-TRAN-REJECTED-SW
               MOVE "INVALID TRANSACTION CODE" TO WS-REJECT-REASON
               GO TO 300-EXIT
           END-IF.

           IF TRAN-AMOUNT NOT > ZERO
               MOVE "Y" TO WS-TRAN-REJECTED-SW
               MOVE "INVALID TRANSACTION AMOUNT" TO WS-REJECT-REASON
               GO TO 300-EXIT
           END-IF.
                      EXIT.
           MOVE TRAN-ACCOUNT-NBR TO ACCT-NBR.
           READ ACCTMSTR INTO WS-ACCTMSTR-REC
               INVALID KEY
                   MOVE "Y" TO WS-TRAN-REJECTED-SW
                   MOVE "ACCOUNT NOT ON FILE" TO WS-REJECT-REASON
           END-READ.
           IF TRAN-REJECTED
               GO TO 300-EXIT
           END-IF.

           IF NOT WS-ACCT-IS-ACTIVE
               MOVE "Y" TO WS-TRAN-REJECTED-SW
               MOVE "ACCOUNT IS CLOSED" TO WS-REJECT-REASON
               GO TO 300-EXIT
           END-IF.

           IF (TRAN-IS-WITHDRAWAL OR TRAN-IS-FEE)
              AND (WS-ACCT-BALANCE - TRAN-AMOUNT) < WS-ACCT-MIN-BALANCE
               MOVE "Y" TO WS-TRAN-REJECTED-SW
               MOVE "INSUFFICIENT FUNDS" TO WS-REJECT-REASON
           END-IF.
       300-EXIT.
           EXIT.

       400-POST-DEPOSIT.
           MOVE "400-POST-DEPOSIT" TO PARA-NAME.
           ADD TRAN-AMOUNT TO WS-ACCT-BALANCE.
           MOVE WS-RUN-DATE TO WS-ACCT-LAST-TRAN-DATE.
           PERFORM 650-REWRITE-ACCTMSTR-REC THRU 650-EXIT.
           ADD 1 TO WS-DEPOSITS-COUNT.
           ADD TRAN-AMOUNT TO WS-DEPOSITS-AMOUNT.
       400-EXIT.
           EXIT.

       500-POST-WITHDRAWAL.
           MOVE "500-POST-WITHDRAWAL" TO PARA-NAME.
           SUBTRACT TRAN-AMOUNT FROM WS-ACCT-BALANCE.
           MOVE WS-RUN-DATE TO WS-ACCT-LAST-TRAN-DATE.
           PERFORM 650-REWRITE-ACCTMSTR-REC THRU 650-EXIT.
           ADD 1 TO WS-WITHDRAWALS-COUNT.
           ADD TRAN-AMOUNT TO WS-WITHDRAWALS-AMOUNT.
       500-EXIT.
           EXIT.

       600-POST-FEE.
           MOVE "600-POST-FEE" TO PARA-NAME.
           SUBTRACT TRAN-AMOUNT FROM WS-ACCT-BALANCE.
           MOVE WS-RUN-DATE TO WS-ACCT-LAST-TRAN-DATE.
           PERFORM 650-REWRITE-ACCTMSTR-REC THRU 650-EXIT.
           ADD 1 TO WS-FEES-COUNT.
           ADD TRAN-AMOUNT TO WS-FEES-AMOUNT.
       600-EXIT.
           EXIT.

       650-REWRITE-ACCTMSTR-REC.
           MOVE "650-REWRITE-ACCTMSTR-REC" TO PARA-NAME.
           REWRITE ACCTMSTR-REC FROM WS-ACCTMSTR-REC
               INVALID KEY
                   MOVE "UNABLE TO REWRITE ACCTMSTR" TO WS-ABEND-REASON
                   PERFORM 1000-ABEND-RTN THRU 1000-EXIT
           END-REWRITE.
           ADD 1 TO WS-ACCTS-UPDATED.
       650-EXIT.
           EXIT.

       700-WRITE-REJECT-LINE.
           MOVE "700-WRITE-REJECT-LINE" TO PARA-NAME.
           MOVE SPACES               TO WS-RPT-REJECT-LINE.
           MOVE TRAN-ACCOUNT-NBR      TO RPT-REJ-ACCOUNT-NBR.
           MOVE TRAN-CODE             TO RPT-REJ-TRAN-CODE.
           MOVE TRAN-AMOUNT           TO RPT-REJ-AMOUNT.
           MOVE WS-REJECT-REASON      TO RPT-REJ-REASON.
           WRITE ACCTRPT-LINE FROM WS-RPT-REJECT-LINE.
           ADD 1 TO WS-REJECTS-COUNT.
       700-EXIT.
           EXIT.

       800-PRODUCE-SUMMARY-REPORT.
           MOVE "800-PRODUCE-SUMMARY-REPORT" TO PARA-NAME.
           MOVE SPACES TO ACCTRPT-LINE.
           WRITE ACCTRPT-LINE.

           MOVE "DEPOSITS POSTED"      TO RPT-TOTAL-LABEL.
           MOVE WS-DEPOSITS-COUNT      TO RPT-TOTAL-COUNT.
           MOVE WS-DEPOSITS-AMOUNT     TO RPT-TOTAL-AMOUNT.
           WRITE ACCTRPT-LINE FROM WS-RPT-TOTAL-LINE.

           MOVE "WITHDRAWALS POSTED"   TO RPT-TOTAL-LABEL.
           MOVE WS-WITHDRAWALS-COUNT   TO RPT-TOTAL-COUNT.
           MOVE WS-WITHDRAWALS-AMOUNT  TO RPT-TOTAL-AMOUNT.
           WRITE ACCTRPT-LINE FROM WS-RPT-TOTAL-LINE.

           MOVE "FEES POSTED"          TO RPT-TOTAL-LABEL.
           MOVE WS-FEES-COUNT          TO RPT-TOTAL-COUNT.
           MOVE WS-FEES-AMOUNT         TO RPT-TOTAL-AMOUNT.
           WRITE ACCTRPT-LINE FROM WS-RPT-TOTAL-LINE.

           MOVE "TRANSACTIONS REJECTED" TO RPT-TOTAL-LABEL.
           MOVE WS-REJECTS-COUNT        TO RPT-TOTAL-COUNT.
           MOVE ZERO                    TO RPT-TOTAL-AMOUNT.
           WRITE ACCTRPT-LINE FROM WS-RPT-TOTAL-LINE.
       800-EXIT.
           EXIT.

       900-CLEANUP.
           MOVE "900-CLEANUP" TO PARA-NAME.
           CLOSE TRANFILE, ACCTMSTR, ACCTRPT.

           DISPLAY "** TRANSACTIONS READ **      " WS-TRANS-READ.
           DISPLAY "** ACCOUNTS UPDATED **       " WS-ACCTS-UPDATED.
           DISPLAY "** TRANSACTIONS REJECTED **  " WS-REJECTS-COUNT.
           DISPLAY "******** NORMAL END OF JOB ACCTUPDT ********".
       900-EXIT.
           EXIT.

       1000-ABEND-RTN.
           DISPLAY "*** ABNORMAL END - ACCTUPDT ***" UPON CONSOLE.
           DISPLAY WS-ABEND-REASON UPON CONSOLE.
           MOVE 16 TO RETURN-CODE.
           GOBACK.
       1000-EXIT.
           EXIT.
