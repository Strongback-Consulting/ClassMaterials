       CBL CICS('COBOL3') APOST                                         00100000
      ******************************************************************00200000
      *                                                                *00300000
      * MODULE NAME = DFH0XCFG                                         *00400000
      *                                                                *00500000
      * DESCRIPTIVE NAME = CICS     (Samples) Example Application -    *00600000
      *                                       Configuration Program    *00700000
      *                                                                *00800000
      * @BANNER_START                           01                     *00816600
      * Licensed Materials - Property of IBM                           *00833200
      *                                                                *00849800
      * 5655-M15              DFH0XCFG                                 *00866400
      *                                                                *00883000
      * (C) Copyright IBM Corp. 2004, 2005                             *00899600
      *                                                                *00916200
      * CICS                                                           *00932800
      * (Element of CICS Transaction Server                            *00949400
      * for z/OS, Version 3 Release 1)                                 *00966000
      * @BANNER_END                                                    *00982600
      *                                                                *01000000
      * STATUS = 6.4.0                                                 *01100000
      *                                                                *01200000
      * TRANSACTION NAME = n/a                                         *01300000
      *                                                                *01400000
      * FUNCTION =                                                     *01500000
      *      This program accesses and updates the VSAM configuration  *01600000
      *      file used by the example application allowing uses to     *01700000
      *      set the program names etc. used.                          *01800000
      *                                                                *01900000
      *                                                                *02000000
      *                                                                *02100000
      * ENTRY POINT = DFH0XCFG                                         *02200000
      *                                                                *02300000
      * CHANGE ACTIVITY :                                              *02400000
      *      $MOD(DFH0XCFG),COMP(SAMPLES),PROD(CICS    ):              *02500000
      *                                                                *02600000
      *   PN= REASON REL YYMMDD HDXXIII : REMARKS                      *02700000
      *  $D0= I07544 640 040917 HDIPCB  : BMS MAPS FOR THE EXAMPLE APP *02800000
      *  $D1= I07544 640 041126 HDIPCB  : ExampleApp: Outbound support *02900000
      *  $D2= I07544 640 050114 HDIPCB  : ExampleApp CICS client code  *03000000
      *  $D3= I07544 640 050121 HDIPCB  : ExampleApp Add sample JCL and*03050000
      *  $D0= I07544 640 040910 HDIPCB  : EXAMPLE APP CONFIG APP       *03100000
      *                                                                *03200000
      ******************************************************************03300000
       IDENTIFICATION DIVISION.                                         03400000
       PROGRAM-ID. DFH0XCFG.                                            03500000
       ENVIRONMENT DIVISION.                                            03600000
       CONFIGURATION SECTION.                                           03700000
       DATA DIVISION.                                                   03800000
       WORKING-STORAGE SECTION.                                         03900000
      *----------------------------------------------------------------*04000000
      * Common defintions                                              *04100000
      *----------------------------------------------------------------*04200000
      * Run time (debug) infomation for this invocation                 04300000
        01  WS-HEADER.                                                  04400000
           03 WS-EYECATCHER            PIC X(16)                        04500000
                                        VALUE 'DFH0XCFG------WS'.       04600000
           03 WS-TRANSID               PIC X(4).                        04700000
           03 WS-TERMID                PIC X(4).                        04800000
           03 WS-TASKNUM               PIC 9(7).                        04900000
           03 WS-CALEN                 PIC S9(4) COMP.                  05000000
                                                                        05100000
      * Variables for time/date processing                              05200000
       01  ABS-TIME                    PIC S9(8) COMP VALUE +0.         05300000
       01  TIME1                       PIC X(8)  VALUE SPACES.          05400000
       01  DATE1                       PIC X(10) VALUE SPACES.          05500000
                                                                        05600000
      * Error Message structure                                         05700000
       01  ERROR-MSG.                                                   05800000
           03 EM-DATE                  PIC X(8)  VALUE SPACES.          05900000
           03 FILLER                   PIC X     VALUE SPACES.          06000000
           03 EM-TIME                  PIC X(6)  VALUE SPACES.          06100000
           03 FILLER                   PIC X(9)  VALUE ' EXCONFIG'.     06200000
           03 EM-DETAIL                PIC X(50) VALUE SPACES.          06300000
                                                                        06400000
      * Key into the configuration file                                 06500000
       01 APP-CONFIG-KEYS.                                              06600000
           03 APP-CONFIG-PROGS-KEY     PIC X(9)  VALUE 'EXMP-CONF'.     06700000
           03 APP-CONFIG-URL-KEY       PIC X(9)  VALUE 'OUTBNDURL'.     06800000
           03 APP-CONFIG-VSAM-KEY      PIC X(9)  VALUE 'VSAM-NAME'.     06900000
           03 APP-CONFIG-SERVER-KEY    PIC X(9)  VALUE 'WS-SERVER'.     07000000
                                                                        07100000
       01 APP-EXIT-MESSAGE             PIC X(30)                        07200000
                            VALUE 'EXAMPLE APPLICATION CONFIGURED'.     07300000
                                                                        07400000
      * Switches                                                        07500000
       01 SWITCHES.                                                     07600000
            03 SEND-SWITCH             PIC X   VALUE '1'.               07700000
                88 SEND-ERASE                  VALUE '1'.               07800000
                88 SEND-DATAONLY               VALUE '2'.               07900000
                88 SEND-ALARM                  VALUE '3'.               08000000
                                                                        08100000
      * Working variables                                               08200000
       01 WORKING-VARIABLES.                                            08300000
           03 WS-RESPONSE-CODE                 PIC S9(8) COMP.          08400000
           03 WS-FULL-URL.                                              08500000
               05 URL1                         PIC X(44).               08600000
               05 URL2                         PIC X(44).               08700000
               05 URL3                         PIC X(44).               08800000
               05 URL4                         PIC X(44).               08900000
               05 URL5                         PIC X(44).               09000000
               05 URL6                         PIC X(35).               09100000
           03 DATA-VALID-FLAG                  PIC X   VALUE '1'.       09200000
               88 DATA-VALID                           VALUE '1'.       09300000
               88 DATA-INVALID                         VALUE '2'.       09400000
           03 APP-CONFIG-NEW.                                           09500000
               05 APP-CONFIG-PROG-DATA-NEW.                             09600000
                   07 PROGS-KEY-NEW            PIC X(9).                09700000
                   07 FILLER                   PIC X.                   09800000
                   07 DATASTORE-NEW            PIC X(4).                09900000
                   07 FILLER                   PIC X.                   10000000
                   07 DO-OUTBOUND-WS-NEW       PIC X.                   10100000
                   07 FILLER                   PIC X.                   10200000
                   07 CATMAN-PROG-NEW          PIC X(8).                10300000
                   07 FILLER                   PIC X.                   10400000
                   07 DSSTUB-PROG-NEW          PIC X(8).                10500000
                   07 FILLER                   PIC X.                   10600000
                   07 DSVSAM-PROG-NEW          PIC X(8).                10700000
                   07 FILLER                   PIC X.                   10800000
                   07 ODSTUB-PROG-NEW          PIC X(8).                10900000
                   07 FILLER                   PIC X.                   11000000
                   07 ODWEBS-PROG-NEW          PIC X(8).                11100000
                   07 FILLER                   PIC X.                   11200000
                   07 STKMAN-PROG-NEW          PIC X(8).                11300000
                   07 FILLER                   PIC X(10).               11400000
               05 APP-CONFIG-URL-DATA-NEW.                              11500000
                   07 URL-KEY-NEW              PIC X(9).                11600000
                   07 FILLER                   PIC X.                   11700000
                   07 OUTBOUND-URL-NEW         PIC X(255).              11800000
               05 APP-CONFIG-CAT-NAME-DATA-NEW.                         11900000
                   07 URL-FILE-KEY-NEW         PIC X(9).                12000000
                   07 FILLER                   PIC X.                   12100000
                   07 CATALOG-FILE-NAME-NEW    PIC X(8).                12200000
                   07 FILLER                   PIC X(62).               12300000
               05 APP-CONFIG-WS-SERVERNAME-NEW.                         12400000
                   07 WS-SERVER-KEY-NEW        PIC X(9).                12500000
                   07 FILLER                   PIC X.                   12600000
                   07 WS-SERVER-NEW            PIC X(70).               12700000
                                                                        12800000
                                                                        12900000
      * Working storage copy of Commarea                                13000000
      * Format of the configuration file                                13100000
       01 WS-COMMAREA.                                                  13200000
           03 APP-CONFIG.                                               13300000
               05 APP-CONFIG-PROG-DATA.                                 13400000
                   07 PROGS-KEY                PIC X(9).                13500000
                   07 FILLER                   PIC X.                   13600000
                   07 DATASTORE                PIC X(4).                13700000
                   07 FILLER                   PIC X.                   13800000
                   07 DO-OUTBOUND-WS           PIC X.                   13900000
                   07 FILLER                   PIC X.                   14000000
                   07 CATMAN-PROG              PIC X(8).                14100000
                   07 FILLER                   PIC X.                   14200000
                   07 DSSTUB-PROG              PIC X(8).                14300000
                   07 FILLER                   PIC X.                   14400000
                   07 DSVSAM-PROG              PIC X(8).                14500000
                   07 FILLER                   PIC X.                   14600000
                   07 ODSTUB-PROG              PIC X(8).                14700000
                   07 FILLER                   PIC X.                   14800000
                   07 ODWEBS-PROG              PIC X(8).                14900000
                   07 FILLER                   PIC X.                   15000000
                   07 STKMAN-PROG              PIC X(8).                15100000
                   07 FILLER                   PIC X(10).               15200000
               05 APP-CONFIG-URL-DATA.                                  15300000
                   07 URL-KEY                  PIC X(9).                15400000
                   07 FILLER                   PIC X.                   15500000
                   07 OUTBOUND-URL             PIC X(255).              15600000
               05 APP-CONFIG-CAT-NAME-DATA.                             15700000
                   07 URL-FILE-KEY             PIC X(9).                15800000
                   07 FILLER                   PIC X.                   15900000
                   07 CATALOG-FILE-NAME        PIC X(8).                16000000
                   07 FILLER                   PIC X(62).               16100000
               05 APP-CONFIG-WS-SERVERNAME.                             16200000
                   07 WS-SERVER-KEY            PIC X(9).                16300000
                   07 FILLER                   PIC X.                   16400000
                   07 WS-SERVER                PIC X(70).               16500000
                                                                        16600000
       COPY DFH0XM3.                                                    16700000
       COPY DFHAID.                                                     16800000
                                                                        16900000
      *----------------------------------------------------------------*17000000
                                                                        17100000
      ******************************************************************17200000
      *    L I N K A G E   S E C T I O N                                17300000
      ******************************************************************17400000
       LINKAGE SECTION.                                                 17500000
       01 DFHCOMMAREA.                                                  17600000
           03 CONFIG-DATA                             PIC X(483).       17700000
                                                                        17800000
                                                                        17900000
      ******************************************************************18000000
      *    P R O C E D U R E S                                          18100000
      ******************************************************************18200000
       PROCEDURE DIVISION.                                              18300000
                                                                        18400000
      *----------------------------------------------------------------*18500000
       MAINLINE SECTION.                                                18600000
                                                                        18700000
      *----------------------------------------------------------------*18800000
      * Common code                                                    *18900000
      *----------------------------------------------------------------*19000000
      * initialize working storage variables                            19100000
           INITIALIZE APP-CONFIG.                                       19200000
           INITIALIZE WORKING-VARIABLES.                                19300000
           INITIALIZE ERROR-MSG.                                        19400000
           INITIALIZE EXCONFO.                                          19500000
                                                                        19600000
      * set up general variable                                         19700000
           MOVE EIBTRNID TO WS-TRANSID.                                 19800000
           MOVE EIBTRMID TO WS-TERMID.                                  19900000
           MOVE EIBTASKN TO WS-TASKNUM.                                 20000000
                                                                        20100000
           MOVE LOW-VALUE TO EXCONFO.                                   20200000
                                                                        20300000
           IF EIBCALEN GREATER THAN ZERO                                20400000
               MOVE DFHCOMMAREA TO WS-COMMAREA                          20500000
           END-IF                                                       20600000
                                                                        20700000
      *----------------------------------------------------------------*20800000
      * Check commarea and obtain required details                     *20900000
      *----------------------------------------------------------------*21000000
                                                                        21100000
           EVALUATE TRUE                                                21200000
               WHEN EIBCALEN EQUAL ZERO                                 21300000
      *        First invocation                                         21400000
      *        Read current data from files                             21500000
                   PERFORM READ-CONFIGURATION                           21600000
                                                                        21700000
      *            Populate map and send config panel                   21800000
                   PERFORM POPULATE-CONFIG-DATA                         21900000
                   PERFORM SEND-CONFIG-PANEL                            22000000
                                                                        22100000
               WHEN EIBAID EQUAL DFHCLEAR                               22200000
      *        Clear key pressed - reset panel                          22300000
                   PERFORM POPULATE-CONFIG-DATA                         22400000
                   PERFORM SEND-CONFIG-PANEL                            22500000
                                                                        22600000
               WHEN EIBAID EQUAL DFHPA1 OR DFHPA2 OR DFHPA3             22700000
      *        Attention keys - do nothing special                      22800000
                                                                        22900000
               WHEN EIBAID EQUAL DFHPF3 OR DFHPF12                      23000000
      *        Exit application                                         23100000
                   PERFORM APPLICATION-EXIT                             23200000
                                                                        23300000
               WHEN EIBAID EQUAL DFHENTER                               23400000
                                                                        23500000
                   PERFORM READ-NEW-CONFIG                              23600000
                   PERFORM VALIDATE-INPUT                               23700000
                                                                        23800000
                   IF DATA-VALID                                        23900000
                       PERFORM UPDATE-CONFIGURATION                     24000000
                       PERFORM POPULATE-CONFIG-DATA                     24100000
                                                                        24200000
                       MOVE 'APPLICATION CONFIGURATION UPDATED' TO MSGO 24300000
                       SET SEND-ERASE TO TRUE                           24400000
                       PERFORM SEND-CONFIG-PANEL                        24600000
                   ELSE                                                 24800000
                       SET SEND-ALARM TO TRUE                           25000000
                       PERFORM SEND-CONFIG-PANEL                        25200000
                   END-IF                                               25400000
                                                                        25600000
           END-EVALUATE                                                 25800000
                                                                        26000000
                                                                        26200000
      * Return to caller                                                26400000
           EXEC CICS RETURN TRANSID(WS-TRANSID)                         26600000
                            COMMAREA(WS-COMMAREA)                       26800000
           END-EXEC.                                                    27000000
                                                                        27200000
           EXIT.                                                        27400000
                                                                        27600000
       MAINLINE-EXIT.                                                   27800000
           EXIT.                                                        28000000
      *----------------------------------------------------------------*28200000
                                                                        28400000
      *================================================================*28600000
      * Procedure to write error message to TD QUEUE(CSMT)             *28800000
      *   message will include Date, Time, Program Name,               *29000000
      *   and error details.                                           *29200000
      *================================================================*29400000
       WRITE-ERROR-MESSAGE.                                             29600000
      * Obtain and format current time and date                         29800000
           EXEC CICS ASKTIME ABSTIME(ABS-TIME)                          30000000
           END-EXEC                                                     30200000
           EXEC CICS FORMATTIME ABSTIME(ABS-TIME)                       30400000
                     MMDDYYYY(DATE1)                                    30600000
                     TIME(TIME1)                                        30800000
           END-EXEC                                                     31000000
           MOVE DATE1 TO EM-DATE                                        31200000
           MOVE TIME1 TO EM-TIME                                        31400000
      * Write output message to TDQ                                     31600000
           EXEC CICS WRITEQ TD QUEUE('CSMT')                            31800000
                     FROM(ERROR-MSG)                                    32000000
                     LENGTH(LENGTH OF ERROR-MSG)                        32200000
           END-EXEC.                                                    32400000
           EXIT.                                                        32600000
                                                                        32800000
                                                                        33000000
      *================================================================*33200000
      * Procedure to send the config panel BMS map                     *33400000
      *================================================================*33600000
        SEND-CONFIG-PANEL.                                              33800000
           EVALUATE TRUE                                                34000000
               WHEN SEND-ERASE                                          34200000
                   EXEC CICS SEND MAP('EXCONF')                         34400000
                                  MAPSET('DFH0XS3')                     34600000
                                  FROM(EXCONFO)                         34800000
                                  ERASE                                 35000000
                   END-EXEC                                             35200000
               WHEN SEND-DATAONLY                                       35400000
                   EXEC CICS SEND MAP('EXCONF')                         35600000
                                  MAPSET('DFH0XS3')                     35800000
                                  FROM(EXCONFO)                         36000000
                                  DATAONLY                              36200000
                   END-EXEC                                             36400000
               WHEN SEND-ALARM                                          36600000
                   EXEC CICS SEND MAP('EXCONF')                         36800000
                                  MAPSET('DFH0XS3')                     37000000
                                  FROM(EXCONFO)                         37200000
                                  DATAONLY                              37400000
                                  ALARM                                 37600000
                   END-EXEC                                             37800000
           END-EVALUATE                                                 38000000
           EXIT.                                                        38200000
                                                                        38400000
                                                                        38600000
      *================================================================*38800000
      * Procedure to read the current configuration                    *39000000
      *================================================================*39200000
        READ-CONFIGURATION.                                             39400000
      *    Read program names and options                               39600000
           EXEC CICS READ FILE('EXMPCONF')                              39800000
                          INTO(APP-CONFIG-PROG-DATA)                    40000000
                          RIDFLD(APP-CONFIG-PROGS-KEY)                  40200000
                          RESP(WS-RESPONSE-CODE)                        40400000
           END-EXEC                                                     40600000
           IF WS-RESPONSE-CODE NOT EQUAL DFHRESP(NORMAL)                40800000
               MOVE 'ERROR READING FILE' TO MSGO                        41000000
               SET SEND-ERASE TO TRUE                                   41200000
               PERFORM SEND-CONFIG-PANEL                                41400000
               EXEC CICS RETURN END-EXEC                                41600000
           END-IF                                                       41800000
                                                                        42000000
      *    Read URL for outbound web service call                       42200000
           EXEC CICS READ FILE('EXMPCONF')                              42400000
                          INTO(APP-CONFIG-URL-DATA)                     42600000
                          RIDFLD(APP-CONFIG-URL-KEY)                    42800000
                          RESP(WS-RESPONSE-CODE)                        43000000
           END-EXEC                                                     43200000
           IF WS-RESPONSE-CODE NOT EQUAL DFHRESP(NORMAL)                43400000
               MOVE 'ERROR READING FILE' TO MSGO                        43600000
               SET SEND-ERASE TO TRUE                                   43800000
               PERFORM SEND-CONFIG-PANEL                                44000000
               EXEC CICS RETURN END-EXEC                                44200000
           END-IF                                                       44400000
                                                                        44600000
      *    Read VSAM file name for catalog file                         44800000
           EXEC CICS READ FILE('EXMPCONF')                              45000000
                          INTO(APP-CONFIG-CAT-NAME-DATA)                45200000
                          RIDFLD(APP-CONFIG-VSAM-KEY)                   45400000
                          RESP(WS-RESPONSE-CODE)                        45600000
           END-EXEC                                                     45800000
           IF WS-RESPONSE-CODE NOT EQUAL DFHRESP(NORMAL)                46000000
               MOVE 'ERROR READING FILE' TO MSGO                        46200000
               SET SEND-ERASE TO TRUE                                   46400000
               PERFORM SEND-CONFIG-PANEL                                46600000
               EXEC CICS RETURN END-EXEC                                46800000
           END-IF                                                       47000000
                                                                        47200000
      *    Read CICS server name and port                               47400000
           EXEC CICS READ FILE('EXMPCONF')                              47600000
                          INTO(APP-CONFIG-WS-SERVERNAME)                47800000
                          RIDFLD(APP-CONFIG-SERVER-KEY)                 48000000
                          RESP(WS-RESPONSE-CODE)                        48200000
           END-EXEC                                                     48400000
           IF WS-RESPONSE-CODE NOT EQUAL DFHRESP(NORMAL)                48600000
               MOVE 'ERROR READING FILE' TO MSGO                        48800000
               SET SEND-ERASE TO TRUE                                   49000000
               PERFORM SEND-CONFIG-PANEL                                49200000
               EXEC CICS RETURN END-EXEC                                49400000
           END-IF                                                       49600000
                                                                        49800000
           EXIT.                                                        50000000
                                                                        50200000
                                                                        50400000
      *================================================================*50600000
      * Procedure to update the current configuration                  *50800000
      *================================================================*51000000
        UPDATE-CONFIGURATION.                                           51200000
      *    Read program names and options                               51400000
           EXEC CICS READ FILE('EXMPCONF')                              51600000
                          INTO(APP-CONFIG-PROG-DATA)                    51800000
                          RIDFLD(APP-CONFIG-PROGS-KEY)                  52000000
                          RESP(WS-RESPONSE-CODE)                        52200000
                          UPDATE                                        52400000
           END-EXEC                                                     52600000
           IF WS-RESPONSE-CODE NOT EQUAL DFHRESP(NORMAL)                52800000
               MOVE 'ERROR UPDATING FILE' TO MSGO                       53000000
               SET SEND-ERASE TO TRUE                                   53200000
               PERFORM SEND-CONFIG-PANEL                                53400000
               EXEC CICS RETURN END-EXEC                                53600000
           END-IF                                                       53800000
      *    Update program names and options                             54000000
           EXEC CICS REWRITE FILE('EXMPCONF')                           54200000
                             FROM(APP-CONFIG-PROG-DATA-NEW)             54400000
                             RESP(WS-RESPONSE-CODE)                     54600000
           END-EXEC                                                     54800000
           IF WS-RESPONSE-CODE NOT EQUAL DFHRESP(NORMAL)                55000000
               MOVE 'ERROR UPDATING FILE' TO MSGO                       55200000
               SET SEND-ERASE TO TRUE                                   55400000
               PERFORM SEND-CONFIG-PANEL                                55600000
               EXEC CICS RETURN END-EXEC                                55800000
           END-IF                                                       56000000
                                                                        56200000
                                                                        56400000
      *    Read URL for outbound web service call                       56600000
           EXEC CICS READ FILE('EXMPCONF')                              56800000
                          INTO(APP-CONFIG-URL-DATA)                     57000000
                          RIDFLD(APP-CONFIG-URL-KEY)                    57200000
                          RESP(WS-RESPONSE-CODE)                        57400000
                          UPDATE                                        57600000
           END-EXEC                                                     57800000
           IF WS-RESPONSE-CODE NOT EQUAL DFHRESP(NORMAL)                58000000
               MOVE 'ERROR UPDATING FILE' TO MSGO                       58200000
               SET SEND-ERASE TO TRUE                                   58400000
               PERFORM SEND-CONFIG-PANEL                                58600000
               EXEC CICS RETURN END-EXEC                                58800000
           END-IF                                                       59000000
                                                                        59200000
      *    Update URL for outbounf web service call                     59400000
           EXEC CICS REWRITE FILE('EXMPCONF')                           59600000
                             FROM(APP-CONFIG-URL-DATA-NEW)              59800000
                             RESP(WS-RESPONSE-CODE)                     60000000
           END-EXEC                                                     60200000
           IF WS-RESPONSE-CODE NOT EQUAL DFHRESP(NORMAL)                60400000
               MOVE 'ERROR UPDATING FILE' TO MSGO                       60600000
               SET SEND-ERASE TO TRUE                                   60800000
               PERFORM SEND-CONFIG-PANEL                                61000000
               EXEC CICS RETURN END-EXEC                                61200000
           END-IF                                                       61400000
                                                                        61600000
      *    Read VSAM file name for catalog file                         61800000
           EXEC CICS READ FILE('EXMPCONF')                              62000000
                          INTO(APP-CONFIG-CAT-NAME-DATA)                62200000
                          RIDFLD(APP-CONFIG-VSAM-KEY)                   62400000
                          RESP(WS-RESPONSE-CODE)                        62600000
                          UPDATE                                        62800000
           END-EXEC                                                     63000000
           IF WS-RESPONSE-CODE NOT EQUAL DFHRESP(NORMAL)                63200000
               MOVE 'ERROR UPDATING FILE' TO MSGO                       63400000
               SET SEND-ERASE TO TRUE                                   63600000
               PERFORM SEND-CONFIG-PANEL                                63800000
               EXEC CICS RETURN END-EXEC                                64000000
           END-IF                                                       64200000
                                                                        64400000
      *    Update VSAM file name for catalog file                       64600000
           EXEC CICS REWRITE FILE('EXMPCONF')                           64800000
                             FROM(APP-CONFIG-CAT-NAME-DATA-NEW)         65000000
                             RESP(WS-RESPONSE-CODE)                     65200000
           END-EXEC                                                     65400000
           IF WS-RESPONSE-CODE NOT EQUAL DFHRESP(NORMAL)                65600000
               MOVE 'ERROR UPDATING FILE' TO MSGO                       65800000
               SET SEND-ERASE TO TRUE                                   66000000
               PERFORM SEND-CONFIG-PANEL                                66200000
               EXEC CICS RETURN END-EXEC                                66400000
           END-IF                                                       66600000
                                                                        66800000
      *    Read Server and and port                                     67000000
           EXEC CICS READ FILE('EXMPCONF')                              67200000
                          INTO(APP-CONFIG-WS-SERVERNAME)                67400000
                          RIDFLD(APP-CONFIG-SERVER-KEY)                 67600000
                          RESP(WS-RESPONSE-CODE)                        67800000
                          UPDATE                                        68000000
           END-EXEC                                                     68200000
           IF WS-RESPONSE-CODE NOT EQUAL DFHRESP(NORMAL)                68400000
               MOVE 'ERROR UPDATING FILE' TO MSGO                       68600000
               SET SEND-ERASE TO TRUE                                   68800000
               PERFORM SEND-CONFIG-PANEL                                69000000
               EXEC CICS RETURN END-EXEC                                69200000
           END-IF                                                       69400000
                                                                        69600000
      *    Update Server and port                                       69800000
           EXEC CICS REWRITE FILE('EXMPCONF')                           70000000
                             FROM(APP-CONFIG-WS-SERVERNAME-NEW)         70200000
                             RESP(WS-RESPONSE-CODE)                     70400000
           END-EXEC                                                     70600000
           IF WS-RESPONSE-CODE NOT EQUAL DFHRESP(NORMAL)                70800000
               MOVE 'ERROR UPDATING FILE' TO MSGO                       71000000
               SET SEND-ERASE TO TRUE                                   71200000
               PERFORM SEND-CONFIG-PANEL                                71400000
               EXEC CICS RETURN END-EXEC                                71600000
           END-IF                                                       71800000
                                                                        72000000
           MOVE APP-CONFIG-NEW TO APP-CONFIG                            72200000
                                                                        72400000
           EXIT.                                                        72600000
                                                                        72800000
      *================================================================*73000000
      * Procedure to read in the changed to the configuration          *73200000
      *================================================================*73400000
        READ-NEW-CONFIG.                                                73600000
                                                                        73800000
           EXEC CICS IGNORE CONDITION MAPFAIL END-EXEC                  74000000
           INITIALIZE EXCONFI                                           74200000
           EXEC CICS RECEIVE MAP('EXCONF')                              74400000
                             MAPSET('DFH0XS3')                          74600000
                             INTO(EXCONFI)                              74800000
           END-EXEC                                                     75000000
                                                                        75200000
           PERFORM EXTRACT-CONFIG-DATA.                                 75400000
                                                                        75600000
                                                                        75800000
           EXIT.                                                        76000000
                                                                        76200000
      *================================================================*76400000
      * Procedure populate the bms map with the config data            *76600000
      *================================================================*76800000
        POPULATE-CONFIG-DATA.                                           77000000
                                                                        77200000
           MOVE DATASTORE TO DS-TYPEO                                   77400000
                                                                        77600000
           IF DO-OUTBOUND-WS EQUAL 'Y'                                  77800000
               MOVE 'YES' TO WS-OUTBOUNDO                               78000000
           ELSE                                                         78200000
               MOVE 'NO' TO WS-OUTBOUNDO                                78400000
           END-IF                                                       78600000
                                                                        78800000
           MOVE CATMAN-PROG TO CATMAN-PROGO                             79000000
                                                                        79200000
           MOVE DSSTUB-PROG TO DSSTUB-PROGO                             79400000
           MOVE DSVSAM-PROG TO DSVSAM-PROGO                             79600000
           MOVE ODSTUB-PROG TO ODSTUB-PROGO                             79800000
           MOVE ODWEBS-PROG TO ODWS-PROGO                               80000000
           MOVE STKMAN-PROG TO STKMAN-PROGO                             80200000
           MOVE CATALOG-FILE-NAME TO VSAM-FILEO                         80400000
           MOVE WS-SERVER TO WS-SERVERO                                 80600000
           MOVE OUTBOUND-URL TO WS-FULL-URL                             80800000
               MOVE URL1 TO OUT-WS-URI1O                                81000000
               MOVE URL2 TO OUT-WS-URI2O                                81200000
               MOVE URL3 TO OUT-WS-URI3O                                81400000
               MOVE URL4 TO OUT-WS-URI4O                                81600000
               MOVE URL5 TO OUT-WS-URI5O                                81800000
               MOVE URL6 TO OUT-WS-URI6O                                82000000
                                                                        82200000
           EXIT.                                                        82400000
                                                                        82600000
      *================================================================*82800000
      * Procedure populate the config data from the bms map            *83000000
      *================================================================*83200000
        EXTRACT-CONFIG-DATA.                                            83400000
                                                                        83600000
           MOVE APP-CONFIG TO APP-CONFIG-NEW                            83800000
                                                                        84000000
           IF DS-TYPEL NOT EQUAL ZERO                                   84200000
               MOVE FUNCTION UPPER-CASE(DS-TYPEI) TO DS-TYPEI           84400000
               MOVE DS-TYPEI TO DATASTORE-NEW                           84600000
           END-IF                                                       84800000
                                                                        85000000
           IF WS-OUTBOUNDL NOT EQUAL ZERO                               85200000
               MOVE FUNCTION UPPER-CASE(WS-OUTBOUNDI) TO WS-OUTBOUNDI   85400000
               IF WS-OUTBOUNDI EQUAL 'YES'                              85600000
                   MOVE 'Y' TO DO-OUTBOUND-WS-NEW                       85800000
               ELSE                                                     86000000
                   MOVE 'N' TO DO-OUTBOUND-WS-NEW                       86200000
               END-IF                                                   86400000
           END-IF                                                       86600000
                                                                        86800000
           IF CATMAN-PROGL NOT EQUAL ZERO                               87000000
               MOVE CATMAN-PROGI TO CATMAN-PROG-NEW                     87200000
           END-IF                                                       87400000
           IF DSSTUB-PROGL NOT EQUAL ZERO                               87600000
               MOVE DSSTUB-PROGI TO DSSTUB-PROG-NEW                     87800000
           END-IF                                                       88000000
           IF DSVSAM-PROGL NOT EQUAL ZERO                               88200000
               MOVE DSVSAM-PROGI TO DSVSAM-PROG-NEW                     88400000
           END-IF                                                       88600000
           IF ODSTUB-PROGL NOT EQUAL ZERO                               88800000
               MOVE ODSTUB-PROGI TO ODSTUB-PROG-NEW                     89000000
           END-IF                                                       89200000
           IF ODWS-PROGL NOT EQUAL ZERO                                 89400000
               MOVE ODWS-PROGI TO ODWEBS-PROG-NEW                       89600000
           END-IF                                                       89800000
           IF STKMAN-PROGL NOT EQUAL ZERO                               90000000
               MOVE STKMAN-PROGI TO STKMAN-PROG-NEW                     90200000
           END-IF                                                       90400000
           IF VSAM-FILEL NOT EQUAL ZERO                                 90600000
               MOVE VSAM-FILEI TO CATALOG-FILE-NAME-NEW                 90800000
           END-IF                                                       91000000
           IF WS-SERVERL NOT EQUAL ZERO                                 91200000
               MOVE WS-SERVERI TO WS-SERVER-NEW                         91400000
           END-IF                                                       91600000
                                                                        91800000
           IF OUT-WS-URI1L NOT EQUAL ZERO                               92000000
               STRING OUT-WS-URI1I                                      92200000
                      OUT-WS-URI2I                                      92400000
                      OUT-WS-URI3I                                      92600000
                      OUT-WS-URI4I                                      92800000
                      OUT-WS-URI5I                                      93000000
                      OUT-WS-URI6I                                      93200000
                   DELIMITED BY SIZE                                    93400000
                   INTO OUTBOUND-URL-NEW                                93600000
               END-STRING                                               93800000
           END-IF                                                       94000000
                                                                        94200000
           EXIT.                                                        94400000
                                                                        94600000
      *================================================================*94800000
      * Check values enteres are valid                                 *95000000
      *================================================================*95200000
        VALIDATE-INPUT.                                                 95400000
           IF DATASTORE-NEW EQUAL 'VSAM' OR 'STUB'                      95600000
               SET DATA-VALID TO TRUE                                   95800000
           ELSE                                                         96000000
               SET DATA-INVALID TO TRUE                                 96200000
               MOVE 'PLEASE ENTER A VALID DATASTORE VALUE' TO MSGO      96400000
           END-IF                                                       96600000
                                                                        96800000
           EXIT.                                                        97000000
                                                                        97200000
                                                                        97400000
      *================================================================*97600000
      * Application Exit procedure                                     *97800000
      *================================================================*98000000
        APPLICATION-EXIT.                                               98200000
           EXEC CICS SEND TEXT FROM(APP-EXIT-MESSAGE)                   98400000
                     ERASE                                              98600000
                     FREEKB                                             98800000
           END-EXEC                                                     99000000
           EXEC CICS RETURN END-EXEC                                    99200000
           EXIT.                                                        99400000
                                                                        99600000
                                                                        99800000