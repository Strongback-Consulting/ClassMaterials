       CBL CICS('COBOL3') APOST                                         00300000
      ***************************************************************** 00600000
      *                                                               * 00900000
      *  MODULE NAME = DFH0XCMN                                       * 01200000
      *                                                               * 01500000
      *  DESCRIPTIVE NAME = CICS     (Samples) Example Application -  * 01800000
      *                     Catalog Manager Program                   * 02100000
      *                                                               * 02400000
      *  @BANNER_START                           01                   * 02450000
      *  Licensed Materials - Property of IBM                         * 02500000
      *                                                               * 02550000
      *  5655-M15              DFH0XCMN                               * 02600000
      *                                                               * 02650000
      *  (C) Copyright IBM Corp. 2004, 2005                           * 02700000
      *                                                               * 02750000
      *  CICS                                                         * 02800000
      *  (Element of CICS Transaction Server                          * 02850000
      *  for z/OS, Version 3 Release 1)                               * 02900000
      *  @BANNER_END                                                  * 02950000
      *                                                               * 03000000
      * STATUS = 6.4.0                                                * 03300000
      *                                                               * 03600000
      *  TRANSACTION NAME = n/a                                       * 03900000
      *                                                               * 04200000
      *  FUNCTION =                                                   * 04500000
      *  This module is the controller for the Catalog application,   * 04800000
      *  all requests pass through this module                        * 05100000
      *                                                               * 05400000
      *-------------------------------------------------------------  * 05700000
      *                                                               * 06000000
      *  ENTRY POINT = DFH0XCMN                                       * 06300000
      *                                                               * 06600000
      *-------------------------------------------------------------  * 06900000
      *                                                               * 07200000
      *  CHANGE ACTIVITY :                                            * 07500000
      *                                                               * 07800000
      *  $MOD(DFH0XCMN),COMP(PIPELINE),PROD(CICS    ):                * 08100000
      *                                                               * 08400000
      *  PN= REASON REL YYMMDD HDXXIII : REMARKS                      * 08700000
      * $D0= I07544 640 041126 HDIPCB  : ExampleApp: Outbound support * 08800000
      * $P1= D13727 640 050217 HDIPCB  : Minor fixes to the web servic* 08900000
      *  $D0= I07544 640 040910 HDIPCB  : EXAMPLE - BASE APPLICATION  * 09000000
      *                                                               * 09300000
      ***************************************************************** 09600000
       IDENTIFICATION DIVISION.                                         09900000
       PROGRAM-ID. DFH0XCMN.                                            10200000
       ENVIRONMENT DIVISION.                                            10500000
       CONFIGURATION SECTION.                                           10800000
       DATA DIVISION.                                                   11100000
       WORKING-STORAGE SECTION.                                         11400000
      *----------------------------------------------------------------*11700000
      * Common defintions                                              *12000000
      *----------------------------------------------------------------*12300000
      * Run time (debug) infomation for this invocation                 12600000
        01  WS-HEADER.                                                  12900000
           03 WS-EYECATCHER            PIC X(16)                        13200000
                                        VALUE 'DFH0XCMN------WS'.       13500000
           03 WS-TRANSID               PIC X(4).                        13800000
           03 WS-TERMID                PIC X(4).                        14100000
           03 WS-TASKNUM               PIC 9(7).                        14400000
           03 WS-CALEN                 PIC S9(4) COMP.                  14700000
                                                                        15000000
      * Variables for time/date processing                              15300000
       01  ABS-TIME                    PIC S9(8) COMP VALUE +0.         15600000
       01  TIME1                       PIC X(8)  VALUE SPACES.          15900000
       01  DATE1                       PIC X(10) VALUE SPACES.          16200000
                                                                        16500000
      * Error Message structure                                         16800000
       01  ERROR-MSG.                                                   17100000
           03 EM-DATE                  PIC X(8)  VALUE SPACES.          17400000
           03 FILLER                   PIC X     VALUE SPACES.          17700000
           03 EM-TIME                  PIC X(6)  VALUE SPACES.          18000000
           03 FILLER                   PIC X(9)  VALUE ' EXMPCMAN'.     18300000
           03 FILLER                   PIC X(11) VALUE ' REQUESTID='.   18600000
           03 EM-REQUEST-ID            PIC X(6)  VALUE SPACES.          18900000
           03 FILLER                   PIC X     VALUE SPACES.          19200000
           03 EM-DETAIL                PIC X(50) VALUE SPACES.          19500000
                                                                        19800000
      * Working variables                                               20100000
       01 WORKING-VARIABLES.                                            20400000
           03 WS-RETURN-CODE           PIC S9(8) COMP.                  20700000
                                                                        21000000
      * Key into the configuration file                                 21300000
       01 EXAMPLE-APP-CONFIG       PIC X(9)                             21600000
               VALUE 'EXMP-CONF'.                                       21900000
                                                                        22200000
      * Format of the configuration file                                22500000
       01 APP-CONFIG.                                                   22800000
           03 FILE-KEY             PIC X(9).                            23100000
           03 FILLER               PIC X.                               23400000
           03 DATASTORE            PIC X(4).                            23700000
           03 FILLER               PIC X.                               24000000
           03 DO-OUTBOUND-WS       PIC X.                               24300000
           03 FILLER               PIC X.                               24600000
           03 CATMAN-PROG          PIC X(8).                            24900000
           03 FILLER               PIC X.                               25200000
           03 DSSTUB-PROG          PIC X(8).                            25500000
           03 FILLER               PIC X.                               25800000
           03 DSVSAM-PROG          PIC X(8).                            26100000
           03 FILLER               PIC X.                               26400000
           03 ODSTUB-PROG          PIC X(8).                            26700000
           03 FILLER               PIC X.                               27000000
           03 ODWEBS-PROG          PIC X(8).                            27300000
           03 FILLER               PIC X.                               27600000
           03 STKMAN-PROG          PIC X(8).                            27900000
           03 FILLER               PIC X.                               28200000
           03 OUTBOUND-URL         PIC X(255).                          28500000
           03 FILLER               PIC X(10).                           28800000
                                                                        29100000
      * Flag for Data Store program to call                             29400000
       01 WS-DATASTORE-INUSE-FLAG         PIC X(4).                     29700000
           88 DATASTORE-STUB                         VALUE 'STUB'.      30000000
           88 DATASTORE-VSAM                         VALUE 'VSAM'.      30300000
                                                                        30600000
      * Switch For OutBound WebService on Order Dispatch                30900000
       01 WS-DISPATCHER-AS-WS-SWITCH       PIC X     VALUE 'N'.         31200000
           88 WS-DO-DISPATCHER-AS-WS                 VALUE 'Y'.         31500000
                                                                        31800000
      * Program Names to LINK to                                        32100000
       01 WS-PROGRAM-NAMES.                                             32400000
           03  FILLER                      PIC X(8)  VALUE 'HHHHHHHH'.  32700000
           03  WS-DATASTORE-PROG           PIC X(8).                    33000000
           03  WS-DISPATCH-PROG            PIC X(8).                    33300000
           03  WS-STOCKMANAGER-PROG        PIC X(8).                    33600000
                                                                        33900000
      * Commarea structure for Order Dispatcher and Stock Manager Progs 34200000
       01 WS-STOCK-COMMAREA.                                            34500000
           COPY DFH0XCP2.                                               34800000
                                                                        35100000
      *----------------------------------------------------------------*35400000
                                                                        35700000
      ******************************************************************36000000
      *    L I N K A G E   S E C T I O N                                36300000
      ******************************************************************36600000
       LINKAGE SECTION.                                                 36900000
       01 DFHCOMMAREA.                                                  37200000
           COPY DFH0XCP1.                                               37500000
                                                                        37800000
      ******************************************************************38100000
      *    P R O C E D U R E S                                          38400000
      ******************************************************************38700000
       PROCEDURE DIVISION.                                              39000000
                                                                        39300000
      *----------------------------------------------------------------*39600000
       MAINLINE SECTION.                                                39900000
                                                                        40200000
      *----------------------------------------------------------------*40500000
      * Common code                                                    *40800000
      *----------------------------------------------------------------*41100000
      * initialize working storage variables                            41400000
           INITIALIZE APP-CONFIG.                                       41700000
           INITIALIZE WS-PROGRAM-NAMES.                                 42000000
           INITIALIZE ERROR-MSG.                                        42300000
                                                                        42600000
      * set up general variable                                         42900000
           MOVE EIBTRNID TO WS-TRANSID.                                 43200000
           MOVE EIBTRMID TO WS-TERMID.                                  43500000
           MOVE EIBTASKN TO WS-TASKNUM.                                 43800000
                                                                        44100000
      *---------------------------------------------------------------* 44400000
      * Check commarea and obtain required details                    * 44700000
      *---------------------------------------------------------------* 45000000
      * If NO commarea received issue an ABEND                          45300000
           IF EIBCALEN IS EQUAL TO ZERO                                 45600000
               MOVE ' NO COMMAREA RECEIVED' TO EM-DETAIL                45900000
               PERFORM WRITE-ERROR-MESSAGE                              46200000
               EXEC CICS ABEND ABCODE('EXCA') NODUMP END-EXEC           46500000
           END-IF                                                       46800000
                                                                        47100000
      * Initalize commarea return code to zero                          47400000
           MOVE '00' TO CA-RETURN-CODE                                  47700000
           MOVE EIBCALEN TO WS-CALEN.                                   48000000
                                                                        48300000
      *----------------------------------------------------------------*48600000
      * Read in configuration file and set up program names             48900000
      *----------------------------------------------------------------*49200000
           EXEC CICS READ FILE('EXMPCONF')                              49500000
                          INTO(APP-CONFIG)                              49800000
                          RIDFLD(EXAMPLE-APP-CONFIG)                    50100000
                          RESP(WS-RETURN-CODE)                          50400000
           END-EXEC                                                     50700000
                                                                        51000000
           IF WS-RETURN-CODE NOT EQUAL DFHRESP(NORMAL)                  51300000
               MOVE '51' TO CA-RETURN-CODE                              51600000
               MOVE 'APPLICATION ERROR OPENING CONFIGURATION FILE'      51900000
                   TO CA-RESPONSE-MESSAGE                               52200000
               EXEC CICS RETURN END-EXEC                                52500000
           END-IF                                                       52800000
                                                                        53100000
           MOVE DATASTORE TO WS-DATASTORE-INUSE-FLAG                    53400000
                                                                        53700000
           EVALUATE DATASTORE                                           54000000
               WHEN 'STUB'                                              54300000
                   MOVE DSSTUB-PROG TO WS-DATASTORE-PROG                54600000
               WHEN 'VSAM'                                              54900000
                   MOVE DSVSAM-PROG TO WS-DATASTORE-PROG                55200000
               WHEN OTHER                                               55500000
                   MOVE '52' TO CA-RETURN-CODE                          55800000
                   MOVE 'DATASTORE TYPE INCORRECT IN CONFIGURATION FILE'56100000
                       TO CA-RESPONSE-MESSAGE                           56400000
                   EXEC CICS RETURN END-EXEC                            56700000
           END-EVALUATE                                                 57000000
                                                                        57300000
           EVALUATE DO-OUTBOUND-WS                                      57600000
               WHEN 'Y'                                                 57900000
                   MOVE ODWEBS-PROG TO WS-DISPATCH-PROG                 58200000
               WHEN 'N'                                                 58500000
                   MOVE ODSTUB-PROG TO WS-DISPATCH-PROG                 58800000
               WHEN OTHER                                               59100000
                   MOVE '53' TO CA-RETURN-CODE                          59400000
                   MOVE 'DISPATCHER SWITCH INCORRECT IN CONFIG FILE'    59700000
                       TO CA-RESPONSE-MESSAGE                           60000000
                   EXEC CICS RETURN END-EXEC                            60300000
           END-EVALUATE                                                 60600000
                                                                        60900000
           MOVE STKMAN-PROG TO WS-STOCKMANAGER-PROG                     61200000
                                                                        61500000
      *----------------------------------------------------------------*61800000
      * Check which operation in being requested                        62100000
      *----------------------------------------------------------------*62400000
      * Uppercase the value passed in the Request Id field              62700000
           MOVE FUNCTION UPPER-CASE(CA-REQUEST-ID) TO CA-REQUEST-ID     63000000
                                                                        63300000
           EVALUATE CA-REQUEST-ID                                       63600000
               WHEN '01INQC'                                            63900000
      *        Call routine to perform for inquire                      64200000
                   PERFORM CATALOG-INQUIRE                              64500000
                                                                        64800000
               WHEN '01INQS'                                            65100000
      *        Call routine to perform for inquire for single item      65400000
                   PERFORM CATALOG-INQUIRE                              65700000
                                                                        66000000
               WHEN '01ORDR'                                            66300000
      *        Call routine to place order                              66600000
                   PERFORM PLACE-ORDER                                  66900000
                                                                        67200000
               WHEN OTHER                                               67500000
      *        Request is not recognised or supported                   67800000
                   PERFORM REQUEST-NOT-RECOGNISED                       68100000
                                                                        68400000
           END-EVALUATE                                                 68700000
                                                                        69000000
      * Return to caller                                                69300000
           EXEC CICS RETURN END-EXEC.                                   69600000
                                                                        69900000
       MAINLINE-EXIT.                                                   70200000
           EXIT.                                                        70500000
      *----------------------------------------------------------------*70800000
                                                                        71100000
      *================================================================*71400000
      * Procedure to write error message to TD QUEUE(CSMT)             *71700000
      *   message will include Date, Time, Program Name,               *72000000
      *   and error details.                                           *72300000
      *================================================================*72600000
       WRITE-ERROR-MESSAGE.                                             72900000
      * Obtain and format current time and date                         73200000
           EXEC CICS ASKTIME ABSTIME(ABS-TIME)                          73500000
           END-EXEC                                                     73800000
           EXEC CICS FORMATTIME ABSTIME(ABS-TIME)                       74100000
                     MMDDYYYY(DATE1)                                    74400000
                     TIME(TIME1)                                        74700000
           END-EXEC                                                     75000000
           MOVE DATE1 TO EM-DATE                                        75300000
           MOVE TIME1 TO EM-TIME                                        75600000
      * Write output message to TDQ                                     75900000
           EXEC CICS WRITEQ TD QUEUE('CSMT')                            76200000
                     FROM(ERROR-MSG)                                    76500000
                     LENGTH(LENGTH OF ERROR-MSG)                        76800000
           END-EXEC.                                                    77100000
           EXIT.                                                        77400000
                                                                        77700000
      *================================================================*78000000
      * Procedure to link to Datastore program to inquire              *78300000
      *   on the catalog data                                          *78600000
      *================================================================*78900000
        CATALOG-INQUIRE.                                                79200000
           MOVE 'EXCATMAN: CATALOG-INQUIRE' TO CA-RESPONSE-MESSAGE      79500000
           EXEC CICS LINK   PROGRAM(WS-DATASTORE-PROG)                  79800000
                            COMMAREA(DFHCOMMAREA)                       80100000
           END-EXEC                                                     80400000
           EXIT.                                                        80700000
                                                                        81000000
      *================================================================*81300000
      * Procedure to link to Datastore program to place order,         *81600000
      *   send request to dispatcher and notify stock manager          *82000000
      *   an order has been placed                                     *82400000
      *================================================================*82800000
        PLACE-ORDER.                                                    83200000
           MOVE 'EXCATMAN: PLACE-ORDER' TO CA-RESPONSE-MESSAGE          83600000
           EXEC CICS LINK PROGRAM(WS-DATASTORE-PROG)                    84000000
                          COMMAREA(DFHCOMMAREA)                         84400000
           END-EXEC                                                     84800000
                                                                        85200000
           IF CA-RETURN-CODE EQUAL 00                                   85600000
      * Link to the Order dispatch program with details                 86000000
      *        Set up commarea for request                              86400000
               INITIALIZE WS-STOCK-COMMAREA                             86800000
               MOVE '01DSPO' TO CA-ORD-REQUEST-ID                       87200000
               MOVE CA-USERID TO CA-ORD-USERID                          87600000
               MOVE CA-CHARGE-DEPT TO CA-ORD-CHARGE-DEPT                88000000
               MOVE CA-ITEM-REF-NUMBER TO CA-ORD-ITEM-REF-NUMBER        88400000
               MOVE CA-QUANTITY-REQ TO CA-ORD-QUANTITY-REQ              88800000
               EXEC CICS LINK PROGRAM (WS-DISPATCH-PROG)                89200000
                              COMMAREA(WS-STOCK-COMMAREA)               89600000
               END-EXEC                                                 90000000
                                                                        90400000
               IF CA-ORD-RETURN-CODE NOT EQUAL ZERO                     90450000
                   MOVE SPACES TO CA-RESPONSE-MESSAGE                   90500000
                   MOVE CA-ORD-RESPONSE-MESSAGE                         90560000
                         TO CA-RESPONSE-MESSAGE                         90620000
               END-IF                                                   90680000
                                                                        90740000
      * Notify the stock manager program of the order details           90800000
               MOVE '01STKO' TO CA-ORD-REQUEST-ID                       91200000
               EXEC CICS LINK PROGRAM (WS-STOCKMANAGER-PROG)            91600000
                              COMMAREA(WS-STOCK-COMMAREA)               92000000
               END-EXEC                                                 92400000
           END-IF                                                       92800000
           EXIT.                                                        93200000
                                                                        93600000
      *================================================================*94000000
      * Procedure to handle unknown requests                           *94400000
      *================================================================*94800000
        REQUEST-NOT-RECOGNISED.                                         95200000
           MOVE '99' TO CA-RETURN-CODE                                  95600000
                                                                        96000000
           STRING ' UNKNOWN REQUEST ID RECEIVED - ' CA-REQUEST-ID       96400000
               DELIMITED BY SIZE                                        96800000
               INTO EM-DETAIL                                           97200000
           END-STRING                                                   97600000
                                                                        98000000
           MOVE 'OPERATION UNKNOWN' TO CA-RESPONSE-MESSAGE              98400000
           EXIT.                                                        98800000
                                                                        99200000
                                                                        99600000