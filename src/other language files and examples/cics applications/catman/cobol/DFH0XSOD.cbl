       CBL CICS('COBOL3') APOST                                         00700000
      ******************************************************************01400000
      *                                                                *02100000
      * MODULE NAME = DFH0XSOD                                         *02800000
      *                                                                *03500000
      * DESCRIPTIVE NAME = CICS     (Samples) Example Application -    *04200000
      *                                       Stubbed Order Dispatcher *04900000
      *                                                                *05600000
      *  @BANNER_START                           01                    *05716600
      *  Licensed Materials - Property of IBM                          *05833200
      *                                                                *05949800
      *  5655-M15              DFH0XSOD                                *06066400
      *                                                                *06183000
      *  (C) Copyright IBM Corp. 2004                                  *06299600
      *                                                                *06416200
      *  CICS                                                          *06532800
      *  (Element of CICS Transaction Server                           *06649400
      *  for z/OS, Version 3 Release 1)                                *06766000
      *  @BANNER_END                                                   *06882600
      *                                                                *07000000
      * STATUS = 6.4.0                                                 *07700000
      *                                                                *08400000
      * TRANSACTION NAME = n/a                                         *09100000
      *                                                                *09800000
      * FUNCTION =                                                     *10500000
      *      This program is a stubbed version of the order dispatcher *11200000
      *      program used when outbound webservices are not required   *11900000
      *                                                                *12600000
      *----------------------------------------------------------------*13300000
      *                                                                *14000000
      * ENTRY POINT = DFH0XSOD                                         *14700000
      *                                                                *15400000
      *----------------------------------------------------------------*16100000
      *                                                                *16800000
      * CHANGE ACTIVITY :                                              *17500000
      *                                                                *18200000
      *      $MOD(DFH0XSOD),COMP(SAMPLES),PROD(CICS    ):              *18900000
      *                                                                *19600000
      *   PN= REASON REL YYMMDD HDXXIII : REMARKS                      *20300000
      *   $D0= I07544 640 040910 HDIPCB  : EXAMPLE - BASE APPLICATION  *21000000
      *                                                                *21700000
      ******************************************************************22400000
       IDENTIFICATION DIVISION.                                         23100000
       PROGRAM-ID. DFH0XSOD.                                            23800000
       ENVIRONMENT DIVISION.                                            24500000
       CONFIGURATION SECTION.                                           25200000
       DATA DIVISION.                                                   25900000
       WORKING-STORAGE SECTION.                                         26600000
      *----------------------------------------------------------------*27300000
      * Common defintions                                              *28000000
      *----------------------------------------------------------------*28700000
      * Run time (debug) infomation for this invocation                 29400000
        01  WS-HEADER.                                                  30100000
           03 WS-EYECATCHER            PIC X(16)                        30800000
                                        VALUE 'DFH0XSOD------WS'.       31500000
           03 WS-TRANSID               PIC X(4).                        32200000
           03 WS-TERMID                PIC X(4).                        32900000
           03 WS-TASKNUM               PIC 9(7).                        33600000
           03 WS-CALEN                 PIC S9(4) COMP.                  34300000
                                                                        35000000
      * Variables for time/date processing                              35700000
       01  ABS-TIME                    PIC S9(8) COMP VALUE +0.         36400000
       01  TIME1                       PIC X(8)  VALUE SPACES.          37100000
       01  DATE1                       PIC X(10) VALUE SPACES.          37800000
                                                                        38500000
      * Error Message structure                                         39200000
       01  ERROR-MSG.                                                   39900000
           03 EM-DATE                  PIC X(8)  VALUE SPACES.          40600000
           03 FILLER                   PIC X     VALUE SPACES.          41300000
           03 EM-TIME                  PIC X(6)  VALUE SPACES.          42000000
           03 FILLER                   PIC X(9)  VALUE ' EXMPCMAN'.     42700000
           03 EM-DETAIL                PIC X(50) VALUE SPACES.          43400000
                                                                        44100000
      *----------------------------------------------------------------*44800000
                                                                        45500000
      ******************************************************************46200000
      *    L I N K A G E   S E C T I O N                                46900000
      ******************************************************************47600000
       LINKAGE SECTION.                                                 48300000
       01 DFHCOMMAREA.                                                  49000000
           COPY DFH0XCP2.                                               49700000
                                                                        50400000
      ******************************************************************51100000
      *    P R O C E D U R E S                                          51800000
      ******************************************************************52500000
       PROCEDURE DIVISION.                                              53200000
                                                                        53900000
      *----------------------------------------------------------------*54600000
       MAINLINE SECTION.                                                55300000
                                                                        56000000
      *----------------------------------------------------------------*56700000
      * Common code                                                    *57400000
      *----------------------------------------------------------------*58100000
      * initialize working storage variables                            58800000
           INITIALIZE WS-HEADER.                                        59500000
                                                                        60200000
      * set up general variable                                         60900000
           MOVE EIBTRNID TO WS-TRANSID.                                 61600000
           MOVE EIBTRMID TO WS-TERMID.                                  62400000
           MOVE EIBTASKN TO WS-TASKNUM.                                 63200000
                                                                        64000000
      *---------------------------------------------------------------* 64800000
      * Check commarea and obtain required details                    * 65600000
      *---------------------------------------------------------------* 66400000
      * If NO commarea received issue an ABEND                          67200000
           IF EIBCALEN IS EQUAL TO ZERO                                 68000000
               MOVE ' NO COMMAREA RECEIVED' TO EM-DETAIL                68800000
               PERFORM WRITE-ERROR-MESSAGE                              69600000
               EXEC CICS ABEND ABCODE('EXCA') NODUMP END-EXEC           70400000
           END-IF                                                       71200000
                                                                        72000000
      * Initalize commarea return code to zero                          72800000
           MOVE '00' TO CA-ORD-RETURN-CODE                              73600000
                                                                        74400000
                                                                        75200000
                                                                        76000000
      * Return to caller                                                76800000
           EXEC CICS RETURN END-EXEC.                                   77600000
                                                                        78400000
       MAINLINE-EXIT.                                                   79200000
           EXIT.                                                        80000000
      *----------------------------------------------------------------*80800000
                                                                        81600000
      *================================================================*82400000
      * Procedure to write error message to TD QUEUE(CSMT)             *83200000
      *   message will include Date, Time, Program Name,               *84000000
      *   and error details.                                           *84800000
      *================================================================*85600000
       WRITE-ERROR-MESSAGE.                                             86400000
      * Obtain and format current time and date                         87200000
           EXEC CICS ASKTIME ABSTIME(ABS-TIME)                          88000000
           END-EXEC                                                     88800000
           EXEC CICS FORMATTIME ABSTIME(ABS-TIME)                       89600000
                     MMDDYYYY(DATE1)                                    90400000
                     TIME(TIME1)                                        91200000
           END-EXEC                                                     92000000
           MOVE DATE1 TO EM-DATE                                        92800000
           MOVE TIME1 TO EM-TIME                                        93600000
      * Write output message to TDQ                                     94400000
           EXEC CICS WRITEQ TD QUEUE('CSMT')                            95200000
                     FROM(ERROR-MSG)                                    96000000
                     LENGTH(LENGTH OF ERROR-MSG)                        96800000
           END-EXEC.                                                    97600000
           EXIT.                                                        98400000
                                                                        99200000