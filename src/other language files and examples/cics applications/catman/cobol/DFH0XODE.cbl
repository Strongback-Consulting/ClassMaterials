       CBL CICS('COBOL3') APOST                                         00800000
      ***************************************************************** 01600000
      *                                                               * 02400000
      * MODULE NAME        = DFH0XODE                                 * 03200000
      *                                                               * 04000000
      * DESCRIPTIVE NAME = CICS     (Samples) Example Application -   * 04800000
      *                      CICS Endpoint for Order Dispatch service * 05600000
      *                                                               * 06400000
      *  @BANNER_START                           01                   * 06533300
      *  Licensed Materials - Property of IBM                         * 06666600
      *                                                               * 06799900
      *  5655-M15              DFH0XODE                               * 06933200
      *                                                               * 07066500
      *  (C) Copyright IBM Corp. 2004                                 * 07199800
      *                                                               * 07333100
      *  CICS                                                         * 07466400
      *  (Element of CICS Transaction Server                          * 07599700
      *  for z/OS, Version 3 Release 1)                               * 07733000
      *  @BANNER_END                                                  * 07866300
      *                                                               * 08000000
      * STATUS = 6.4.0                                                * 08800000
      *                                                               * 09600000
      * FUNCTION =                                                    * 10400000
      *      This module is a COBOL application to implement a simple * 11200000
      *      service endpoint for the order dispatcher service        * 12000000
      *                                                               * 12800000
      *                                                               * 13600000
      *  CHANGE ACTIVITY :                                            * 14400000
      *       $SEG(DFH0XODE),COMP(SAMPLES),PROD(CICS    ):            * 15200000
      *                                                               * 16000000
      *   PN= REASON REL YYMMDD HDXXIII : REMARKS                     * 16800000
      *   $D0= I07544 640 041129 HDIPCB  : ExampleApp: Outbound suppor* 17600000
      *                                                               * 18400000
      ***************************************************************** 19200000
       IDENTIFICATION DIVISION.                                         20000000
       PROGRAM-ID. DFH0XODE.                                            20800000
       ENVIRONMENT DIVISION.                                            21600000
       CONFIGURATION SECTION.                                           22400000
       DATA DIVISION.                                                   23200000
       WORKING-STORAGE SECTION.                                         24000000
      *---------------------------------------------------------------* 24800000
      * Common defintions                                             * 25600000
      *---------------------------------------------------------------* 26400000
      * Run time (debug) infomation for this invocation                 27200000
        01  WS-HEADER.                                                  28000000
           03 WS-EYECATCHER            PIC X(16)                        28800000
                                        VALUE 'DFH0XODE------WS'.       29600000
           03 WS-TRANSID               PIC X(4).                        30400000
           03 WS-TERMID                PIC X(4).                        31200000
           03 WS-TASKNUM               PIC 9(7).                        32000000
           03 WS-CALEN                 PIC S9(4) COMP.                  32800000
      * Variables for time/date processing                              33600000
       01  ABS-TIME                    PIC S9(8) COMP VALUE +0.         34400000
       01  TIME1                       PIC X(8)  VALUE SPACES.          35200000
       01  DATE1                       PIC X(10) VALUE SPACES.          36000000
      * Error Message structure                                         36800000
       01  ERROR-MSG.                                                   37600000
           03 EM-DATE                  PIC X(8)  VALUE SPACES.          38400000
           03 FILLER                   PIC X     VALUE SPACES.          39200000
           03 EM-TIME                  PIC X(6)  VALUE SPACES.          40000000
           03 FILLER                   PIC X(9)  VALUE ' DFH0XODE'.     40800000
           03 EM-DETAIL                PIC X(50) VALUE SPACES.          41600000
      * Working Storage Variables                                       42400000
       01 WORKING-STORAGE-VARIABLES.                                    43300000
           COPY DFH0XCP7.                                               44200000
           COPY DFH0XCP8.                                               45100000
                                                                        46000000
      *---------------------------------------------------------------* 46900000
      ***************************************************************** 47800000
      *    L I N K A G E   S E C T I O N                                48700000
      ***************************************************************** 49600000
       LINKAGE SECTION.                                                 50500000
       01 DFHCOMMAREA                  PIC X(23).                       51400000
                                                                        52300000
      ***************************************************************** 53200000
      *    P R O C E D U R E S                                          54100000
      ***************************************************************** 55000000
       PROCEDURE DIVISION.                                              55900000
      *---------------------------------------------------------------* 56800000
       MAINLINE SECTION.                                                57700000
      *---------------------------------------------------------------* 58600000
      * Common code                                                   * 59500000
      *---------------------------------------------------------------* 60400000
      * initialize working storage variables                            61300000
           INITIALIZE WS-HEADER.                                        62200000
      * set up general variable                                         63100000
           MOVE EIBTRNID TO WS-TRANSID.                                 64000000
           MOVE EIBTRMID TO WS-TERMID.                                  64900000
           MOVE EIBTASKN TO WS-TASKNUM.                                 65800000
      *--------------------------------------------------------------*  66700000
      * Check commarea and obtain required details                    * 67600000
      *---------------------------------------------------------------* 68500000
      * If NO commarea received issue an ABEND                          69400000
           IF EIBCALEN IS EQUAL TO ZERO                                 70300000
               MOVE ' NO COMMAREA RECEIVED' TO EM-DETAIL                71200000
               PERFORM WRITE-ERROR-MESSAGE                              72100000
               EXEC CICS ABEND ABCODE('EXCA') NODUMP END-EXEC           73000000
           END-IF                                                       73900000
      * Initalize commarea return code to zero                          74800000
           MOVE DFHCOMMAREA TO dispatchOrderRequest                     75700000
           INITIALIZE DFHCOMMAREA                                       76600000
           MOVE 'Order in dispatch' TO confirmation                     77500000
           MOVE dispatchOrderResponse TO DFHCOMMAREA                    78400000
      * Return to caller                                                79300000
           EXEC CICS RETURN END-EXEC.                                   80200000
      *===============================================================* 81100000
      * Procedure to write error message to TD QUEUE(CSMT)            * 82000000
      *   message will include Date, Time, Program Name,              * 82900000
      *   and error details.                                          * 83800000
      *===============================================================* 84700000
       WRITE-ERROR-MESSAGE.                                             85600000
      * Obtain and format current time and date                         86500000
           EXEC CICS ASKTIME ABSTIME(ABS-TIME)                          87400000
           END-EXEC                                                     88300000
           EXEC CICS FORMATTIME ABSTIME(ABS-TIME)                       89200000
                     MMDDYYYY(DATE1)                                    90100000
                     TIME(TIME1)                                        91000000
           END-EXEC                                                     91900000
           MOVE DATE1 TO EM-DATE                                        92800000
           MOVE TIME1 TO EM-TIME                                        93700000
      * Write output message to TDQ                                     94600000
           EXEC CICS WRITEQ TD QUEUE('CSMT')                            95500000
                     FROM(ERROR-MSG)                                    96400000
                     LENGTH(LENGTH OF ERROR-MSG)                        97300000
           END-EXEC.                                                    98200000
           EXIT.                                                        99100000