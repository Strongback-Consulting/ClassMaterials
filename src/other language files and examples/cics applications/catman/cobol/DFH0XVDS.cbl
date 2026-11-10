       CBL CICS('COBOL3') APOST                                         00200000
      ******************************************************************00400000
      *                                                                *00600000
      * MODULE NAME = DFH0XVDS                                         *00800000
      *                                                                *01000000
      * DESCRIPTIVE NAME = CICS     (Samples) Example Application -    *01200000
      *                                       VSAM Data Store          *01400000
      *                                                                *01600000
      *  @BANNER_START                           01                    *01633300
      *  Licensed Materials - Property of IBM                          *01666600
      *                                                                *01699900
      *  5655-M15              DFH0XVDS                                *01733200
      *                                                                *01766500
      *  (C) Copyright IBM Corp. 2004, 2005                            *01799800
      *                                                                *01833100
      *  CICS                                                          *01866400
      *  (Element of CICS Transaction Server                           *01899700
      *  for z/OS, Version 3 Release 1)                                *01933000
      *  @BANNER_END                                                   *01966300
      *                                                                *02000000
      * STATUS = 6.4.0                                                 *02200000
      *                                                                *02400000
      * TRANSACTION NAME = n/a                                         *02600000
      *                                                                *02800000
      * FUNCTION =                                                     *03000000
      *      This accesses the VSAM file for the example application   *03200000
      *      to perform reads and updates of the catalog               *03400000
      *                                                                *03600000
      *----------------------------------------------------------------*03800000
      *                                                                *04000000
      * ENTRY POINT = DFH0XVDS                                         *04200000
      *                                                                *04400000
      *----------------------------------------------------------------*04600000
      *                                                                *04800000
      * CHANGE ACTIVITY :                                              *05000000
      *                                                                *05200000
      *      $MOD(DFH0XVDS),COMP(SAMPLES),PROD(CICS    ):              *05400000
      *                                                                *05600000
      *   PN= REASON REL YYMMDD HDXXIII : REMARKS                      *05800000
      *  $P0= D13727 640 050217 HDIPCB  : Minor fixes to the web servic*05900000
      *   $D0= I07544 640 040910 HDIPCB  : EXAMPLE - BASE APPLICATION  *06000000
      *                                                                *06200000
      ******************************************************************06400000
       IDENTIFICATION DIVISION.                                         06600000
       PROGRAM-ID. DFH0XVDS.                                            06800000
       ENVIRONMENT DIVISION.                                            07000000
       CONFIGURATION SECTION.                                           07200000
       DATA DIVISION.                                                   07400000
       WORKING-STORAGE SECTION.                                         07600000
      *----------------------------------------------------------------*07800000
      * Common defintions                                              *08000000
      *----------------------------------------------------------------*08200000
      * Run time (debug) infomation for this invocation                 08400000
        01  WS-HEADER.                                                  08600000
           03 WS-EYECATCHER            PIC X(16)                        08800000
                                        VALUE 'DFH0XVDS------WS'.       09000000
           03 WS-TRANSID               PIC X(4).                        09200000
           03 WS-TERMID                PIC X(4).                        09400000
           03 WS-TASKNUM               PIC 9(7).                        09600000
           03 WS-CALEN                 PIC S9(4) COMP.                  09800000
                                                                        10000000
      * Variables for time/date processing                              10200000
       01  ABS-TIME                    PIC S9(8) COMP VALUE +0.         10400000
       01  TIME1                       PIC X(8)  VALUE SPACES.          10600000
       01  DATE1                       PIC X(10) VALUE SPACES.          10800000
                                                                        11000000
      * Error Message structure                                         11200000
       01  ERROR-MSG.                                                   11400000
           03 EM-DATE                  PIC X(8)  VALUE SPACES.          11600000
           03 FILLER                   PIC X     VALUE SPACES.          11800000
           03 EM-TIME                  PIC X(6)  VALUE SPACES.          12000000
           03 FILLER                   PIC X(9)  VALUE ' EXMPCMAN'.     12200000
           03 FILLER                   PIC X(11) VALUE ' REQUESTID='.   12400000
           03 EM-REQUEST-ID            PIC X(6)  VALUE SPACES.          12600000
           03 FILLER                   PIC X     VALUE SPACES.          12800000
           03 EM-DETAIL                PIC X(50) VALUE SPACES.          13000000
                                                                        13200000
                                                                        13400000
      * Switches                                                        13600000
       01 SWITCHES.                                                     13800000
           03 CATALOG-EOF-SW           PIC X(1)  VALUE 'N'.             14000000
               88 CATALOG-EOF                    VALUE 'Y'.             14200000
                                                                        14400000
      * Work fields                                                     14600000
       01 WORKFIELDS.                                                   14800000
           03 WS-CURRENT-ITEM-REF      PIC 9(4).                        15000000
           03 WS-RESPONSE-CODE         PIC S9(8) COMP.                  15200000
           03 WS-LOOP-COUNTER          PIC S9(2) COMP.                  15400000
           03 WS-RECORD-COUNT          PIC S9(2) COMP.                  15600000
           03 WS-RECORD-COUNT-DISPLAY  PIC +9(2) USAGE DISPLAY.         15800000
           03 WS-CAT-ITEM.                                              16000000
               05 WS-ITEM-REF          PIC 9(4).                        16200000
               05 WS-DESCRIPTION       PIC X(40).                       16400000
               05 WS-DEPARTMENT        PIC 9(3).                        16600000
               05 WS-COST              PIC ZZZ.99.                      16800000
               05 WS-IN-STOCK          PIC 9(4).                        17000000
               05 WS-ON-ORDER          PIC 9(3).                        17200000
               05 FILLER               PIC X(20).                       17400000
                                                                        17600000
      * Configuration File Data                                         17800000
       01 WS-CONF-FILE-KEY             PIC X(9) VALUE 'VSAM-NAME'.      18000000
       01 WS-CONF-DATA.                                                 18200000
           03 FILLER                   PIC X(10).                       18400000
           03 WS-FILENAME-CONF         PIC X(8).                        18600000
           03 FILLER                   PIC X(62).                       18800000
                                                                        19000000
      * Constants                                                       19200000
       01 WS-FILENAME                  PIC X(8)  VALUE 'EXMPCAT '.      19400000
                                                                        19600000
      * Debug                                                           19800000
       01 DEBUG-VARS.                                                   20000000
           03 DEBUG-Q                  PIC X(7) VALUE 'DEBUG-Q'.        20200000
           03 DEBUG-STRING             PIC X(80).                       20400000
                                                                        20600000
      *----------------------------------------------------------------*20800000
                                                                        21000000
      ******************************************************************21200000
      *    L I N K A G E   S E C T I O N                                21400000
      ******************************************************************21600000
       LINKAGE SECTION.                                                 21800000
       01 DFHCOMMAREA.                                                  22000000
           COPY DFH0XCP1.                                               22200000
                                                                        22400000
      ******************************************************************22600000
      *    P R O C E D U R E S                                          22800000
      ******************************************************************23000000
       PROCEDURE DIVISION.                                              23200000
                                                                        23400000
      *----------------------------------------------------------------*23600000
       MAINLINE SECTION.                                                23800000
                                                                        24000000
                                                                        24200000
                                                                        24400000
      *----------------------------------------------------------------*24600000
      * Common code                                                    *24800000
      *----------------------------------------------------------------*25000000
      * initialize working storage variables                            25200000
           INITIALIZE WS-HEADER.                                        25400000
           INITIALIZE WORKFIELDS.                                       25600000
                                                                        25800000
      * set up general variable                                         26000000
           MOVE EIBTRNID TO WS-TRANSID.                                 26200000
           MOVE EIBTRMID TO WS-TERMID.                                  26400000
           MOVE EIBTASKN TO WS-TASKNUM.                                 26600000
                                                                        26800000
      *---------------------------------------------------------------* 27000000
      * Check commarea and obtain required details                    * 27200000
      *---------------------------------------------------------------* 27400000
      * If NO commarea received issue an ABEND                          27600000
           IF EIBCALEN IS EQUAL TO ZERO                                 27800000
               MOVE ' NO COMMAREA RECEIVED' TO EM-DETAIL                28000000
               PERFORM WRITE-ERROR-MESSAGE                              28200000
               EXEC CICS ABEND ABCODE('EXCA') NODUMP END-EXEC           28400000
           END-IF                                                       28600000
                                                                        28800000
      * initalize commarea return code to zero                          29000000
           MOVE '00' TO CA-RETURN-CODE                                  29200000
           MOVE EIBCALEN TO WS-CALEN.                                   29400000
                                                                        29600000
      *----------------------------------------------------------------*29800000
      * Read in VSAM file name from config file                         30000000
      *----------------------------------------------------------------*30200000
           EXEC CICS READ FILE('EXMPCONF')                              30400000
                          INTO(WS-CONF-DATA)                            30600000
                          RIDFLD(WS-CONF-FILE-KEY)                      30800000
           END-EXEC                                                     31000000
                                                                        31200000
           MOVE WS-FILENAME-CONF TO WS-FILENAME                         31400000
                                                                        31600000
      *----------------------------------------------------------------*31800000
      * Check which operation in being requested                        32000000
      *----------------------------------------------------------------*32200000
      * Uppercase the value passed in the Request Id field              32400000
           MOVE FUNCTION UPPER-CASE(CA-REQUEST-ID) TO CA-REQUEST-ID     32600000
                                                                        32800000
           EVALUATE CA-REQUEST-ID                                       33000000
               WHEN '01INQC'                                            33200000
      *        Call routine to read catalog for inquire                 33400000
                   PERFORM CATALOG-INQUIRE                              33600000
                                                                        33800000
               WHEN '01INQS'                                            34000000
      *        Call routine to perform for inquire for single item      34200000
                   PERFORM CATALOG-INQUIRE-SINGLE                       34400000
                                                                        34600000
               WHEN '01ORDR'                                            34800000
      *        Call routine to place order                              35000000
                   PERFORM PLACE-ORDER                                  35200000
                                                                        35400000
               WHEN OTHER                                               35600000
      *        Request is not recognised or supported                   35800000
                   PERFORM REQUEST-NOT-RECOGNISED                       36000000
                                                                        36200000
           END-EVALUATE                                                 36400000
                                                                        36600000
      * Return to caller                                                36800000
           EXEC CICS RETURN END-EXEC.                                   37000000
                                                                        37200000
       MAINLINE-EXIT.                                                   37400000
           EXIT.                                                        37600000
      *----------------------------------------------------------------*37800000
                                                                        38000000
      *================================================================*38200000
      * Procedure to write error message to TD QUEUE(CSMT)             *38400000
      *   message will include Date, Time, Program Name,               *38600000
      *   and error details.                                           *38800000
      *================================================================*39000000
       WRITE-ERROR-MESSAGE.                                             39200000
      * Obtain and format current time and date                         39400000
           EXEC CICS ASKTIME ABSTIME(ABS-TIME)                          39600000
           END-EXEC                                                     39800000
           EXEC CICS FORMATTIME ABSTIME(ABS-TIME)                       40000000
                     MMDDYYYY(DATE1)                                    40200000
                     TIME(TIME1)                                        40400000
           END-EXEC                                                     40600000
           MOVE DATE1 TO EM-DATE                                        40800000
           MOVE TIME1 TO EM-TIME                                        41000000
      * Write output message to TDQ                                     41200000
           EXEC CICS WRITEQ TD QUEUE('CSMT')                            41400000
                     FROM(ERROR-MSG)                                    41600000
                     LENGTH(LENGTH OF ERROR-MSG)                        41800000
           END-EXEC.                                                    42000000
           EXIT.                                                        42200000
      *================================================================*42400000
      * Procedure to link to Datastore program to inquire              *42600000
      *   on the catalog data                                          *42800000
      *================================================================*43000000
        CATALOG-INQUIRE.                                                43200000
                                                                        43400000
                                                                        43600000
           INITIALIZE CA-INQUIRY-RESPONSE-DATA                          43800000
                                                                        44000000
           MOVE 'EXDSVSAM: CATALOG-INQUIRE' TO CA-RESPONSE-MESSAGE      44200000
                                                                        44400000
           MOVE CA-LIST-START-REF TO WS-CURRENT-ITEM-REF                44600000
                                                                        44800000
      * Start browse of file                                            45000000
           EXEC CICS STARTBR FILE(WS-FILENAME)                          45200000
                             RIDFLD(WS-CURRENT-ITEM-REF)                45400000
                             RESP(WS-RESPONSE-CODE)                     45600000
           END-EXEC                                                     45800000
                                                                        46000000
           IF WS-RESPONSE-CODE EQUAL DFHRESP(NOTFND)                    46200000
      *    Item not found                                               46400000
               MOVE 20 TO CA-RETURN-CODE                                46600000
               MOVE 'ITEM NOT FOUND' TO CA-RESPONSE-MESSAGE             46800000
               EXEC CICS RETURN END-EXEC                                47000000
           ELSE                                                         47200000
               IF WS-RESPONSE-CODE NOT EQUAL DFHRESP(NORMAL)            47400000
                   MOVE 21 TO CA-RETURN-CODE                            47600000
                   STRING  'ERROR OPENING FILE ' WS-FILENAME            47800000
                                               DELIMITED BY SIZE        48000000
                           INTO CA-RESPONSE-MESSAGE                     48200000
                   END-STRING                                           48400000
                   EXEC CICS RETURN END-EXEC                            48600000
               END-IF                                                   48800000
           END-IF                                                       49000000
                                                                        49200000
                                                                        49400000
      * Loop thru file read in records until EOF or 15 records read     49600000
           PERFORM                                                      49800000
               WITH TEST AFTER                                          50000000
               VARYING  WS-LOOP-COUNTER FROM 1 BY 1                     50200000
               UNTIL CATALOG-EOF                                        50400000
                  OR WS-LOOP-COUNTER EQUAL 15                           50600000
                                                                        50800000
               EXEC CICS READNEXT FILE(WS-FILENAME)                     51000000
                                  INTO(WS-CAT-ITEM)                     51200000
                                  RIDFLD(WS-CURRENT-ITEM-REF)           51400000
                                  LENGTH(LENGTH OF WS-CAT-ITEM)         51600000
                                  RESP(WS-RESPONSE-CODE)                51800000
               END-EXEC                                                 52000000
                                                                        52200000
               EVALUATE WS-RESPONSE-CODE                                52400000
                   WHEN DFHRESP(NORMAL)                                 52600000
                       MOVE WS-LOOP-COUNTER TO WS-RECORD-COUNT          52800000
                                                                        53000000
                       MOVE WS-CAT-ITEM TO CA-CAT-ITEM(WS-LOOP-COUNTER) 53200000
                                                                        53400000
                       MOVE WS-RECORD-COUNT TO CA-ITEM-COUNT            53600000
                       MOVE WS-CURRENT-ITEM-REF TO CA-LAST-ITEM-REF     53800000
                                                                        54000000
                   WHEN DFHRESP(ENDFILE)                                54200000
                       MOVE 'Y' TO CATALOG-EOF-SW                       54400000
                   WHEN OTHER                                           54600000
                       MOVE 21 TO CA-RETURN-CODE                        54800000
                       MOVE 'ERROR OCCURED READING FILE'                55000000
                         TO CA-RESPONSE-MESSAGE                         55200000
                       EXEC CICS RETURN END-EXEC                        55400000
               END-EVALUATE                                             55600000
           END-PERFORM                                                  55800000
                                                                        56000000
           MOVE SPACES TO CA-RESPONSE-MESSAGE                           56200000
           MOVE WS-RECORD-COUNT TO WS-RECORD-COUNT-DISPLAY              56400000
           STRING WS-RECORD-COUNT-DISPLAY                               56600000
                  ' ITEMS RETURNED'                                     56800000
                       DELIMITED BY SIZE                                57000000
               INTO CA-RESPONSE-MESSAGE                                 57200000
           END-STRING                                                   57400000
                                                                        57600000
      * End browse of file                                              57800000
           EXEC CICS ENDBR FILE(WS-FILENAME)                            58000000
                           RESP(WS-RESPONSE-CODE)                       58200000
           END-EXEC                                                     58400000
           IF WS-RESPONSE-CODE NOT EQUAL DFHRESP(NORMAL)                58600000
               MOVE 21 TO CA-RETURN-CODE                                58800000
               MOVE 'ERROR ENDING BROWSE SESSION' TO CA-RESPONSE-MESSAGE59000000
               EXEC CICS RETURN END-EXEC                                59200000
           END-IF                                                       59400000
           EXIT.                                                        59600000
        CATALOG-INQUIRE-END.                                            59800000
           EXIT.                                                        60000000
      *================================================================*60200000
      * Procedure to link to Datastore program to inquire for a single *60400000
      *   item from the catalog data                                   *60600000
      *================================================================*60800000
        CATALOG-INQUIRE-SINGLE.                                         61000000
                                                                        61200000
           EXEC CICS READ FILE(WS-FILENAME)                             61400000
                          INTO(WS-CAT-ITEM)                             61600000
                          RIDFLD(CA-ITEM-REF-REQ)                       61800000
                          RESP(WS-RESPONSE-CODE)                        62000000
           END-EXEC                                                     62200000
                                                                        62400000
           IF WS-RESPONSE-CODE = DFHRESP(NOTFND)                        62600000
      *    Item not found                                               62800000
               MOVE 20 TO CA-RETURN-CODE                                63000000
               MOVE 'ITEM NOT FOUND' TO CA-RESPONSE-MESSAGE             63200000
               EXEC CICS RETURN END-EXEC                                63400000
           ELSE                                                         63600000
               IF WS-RESPONSE-CODE NOT EQUAL DFHRESP(NORMAL)            63800000
                   MOVE 21 TO CA-RETURN-CODE                            64000000
                   STRING  'ERROR OPENING FILE ' WS-FILENAME            64300000
                       DELIMITED BY SIZE                                64600000
                       INTO CA-RESPONSE-MESSAGE                         64900000
                   END-STRING                                           65200000
                   EXEC CICS RETURN END-EXEC                            65500000
               END-IF                                                   65800000
           END-IF                                                       66100000
                                                                        66400000
      *    Populate commarea to return single item                      66700000
                                                                        67000000
           MOVE WS-CAT-ITEM TO CA-SINGLE-ITEM                           67300000
                                                                        67600000
           MOVE SPACES TO CA-RESPONSE-MESSAGE                           67900000
           STRING 'RETURNED ITEM: REF ='                                68200000
                  CA-ITEM-REF-REQ                                       68500000
               DELIMITED BY SIZE                                        68800000
               INTO CA-RESPONSE-MESSAGE                                 69100000
           END-STRING                                                   69400000
                                                                        69700000
                                                                        70000000
           EXIT.                                                        70300000
        CATALOG-INQUIRE-SINGLE-END.                                     70600000
           EXIT.                                                        70900000
      *================================================================*71200000
      * Procedure to link to Datastore program to place order,         *71500000
      *   send request to dispatcher and notify stock manager          *71800000
      *   an order has been placed                                     *72100000
      *================================================================*72400000
        PLACE-ORDER.                                                    72700000
           MOVE 'PLACE-ORDER' TO CA-RESPONSE-MESSAGE                    73000000
                                                                        73300000
      * Check validity of order quantity                                73600000
           IF CA-QUANTITY-REQ IS NOT GREATER THAN 0                     73900000
               MOVE 98 TO CA-RETURN-CODE                                74200000
               MOVE 'ORDER QUANTITY MUST BE POSITIVE'                   74500000
                    TO CA-RESPONSE-MESSAGE                              74800000
               EXEC CICS RETURN END-EXEC                                75100000
           END-IF                                                       75400000
                                                                        75700000
      * Read file for update                                            76000000
           EXEC CICS READ FILE(WS-FILENAME)                             76300000
                          UPDATE                                        76600000
                          INTO(WS-CAT-ITEM)                             76900000
                          RIDFLD(CA-ITEM-REF-NUMBER)                    77200000
                          RESP(WS-RESPONSE-CODE)                        77500000
           END-EXEC                                                     77800000
                                                                        78100000
           EVALUATE WS-RESPONSE-CODE                                    78400000
      *        Normal Response                                          78700000
               WHEN DFHRESP(NORMAL)                                     79000000
                   PERFORM UPDATE-FILE                                  79300000
      *        Error Conditions                                         79600000
               WHEN DFHRESP(NOTFND)                                     79900000
                   MOVE 20 TO CA-RETURN-CODE                            80200000
                   MOVE SPACES TO CA-RESPONSE-MESSAGE                   80500000
                   STRING  'ITEM - '                                    80800000
                           CA-ITEM-REF-NUMBER                           81100000
                           ' NOT FOUND'                                 81400000
                       DELIMITED BY SIZE                                81700000
                       INTO CA-RESPONSE-MESSAGE                         82000000
                   END-STRING                                           82300000
                   EXEC CICS RETURN END-EXEC                            82900000
               WHEN NOT DFHRESP(NORMAL)                                 83200000
                   MOVE 21 TO CA-RETURN-CODE                            83500000
                   MOVE 'ERROR OCCURED READING FILE'                    83800000
                        TO CA-RESPONSE-MESSAGE                          84100000
                   EXEC CICS RETURN END-EXEC                            84400000
           END-EVALUATE                                                 84700000
           EXIT.                                                        85000000
        PLACE-ORDER-END.                                                85300000
           EXIT.                                                        85600000
                                                                        85900000
        UPDATE-FILE.                                                    86200000
      *    Check there is enough stock to satisfy order                 86500000
           IF CA-QUANTITY-REQ IS GREATER THAN WS-IN-STOCK               86800000
               MOVE 97 TO CA-RETURN-CODE                                87100000
               MOVE 'INSUFFICENT STOCK TO COMPLETE ORDER'               87400000
                    TO CA-RESPONSE-MESSAGE                              87700000
      *        Unlock file                                              88000000
               EXEC CICS UNLOCK file(WS-FILENAME)END-EXEC               88300000
               EXEC CICS RETURN END-EXEC                                88600000
           END-IF                                                       88900000
      *    Update quantity on file                                      89200000
           SUBTRACT CA-QUANTITY-REQ FROM WS-IN-STOCK                    89500000
           EXEC CICS REWRITE FILE(WS-FILENAME)                          89800000
                             FROM(WS-CAT-ITEM)                          90100000
                             RESP(WS-RESPONSE-CODE)                     90400000
           END-EXEC                                                     90700000
                                                                        91000000
           EVALUATE WS-RESPONSE-CODE                                    91300000
               WHEN DFHRESP(NORMAL)                                     91600000
                   MOVE 'ORDER SUCESSFULLY PLACED'                      91900000
                        TO CA-RESPONSE-MESSAGE                          92200000
               WHEN OTHER                                               92500000
                   MOVE 22 TO CA-RETURN-CODE                            92800000
                   MOVE 'ERROR UPDATING FILE' TO CA-RESPONSE-MESSAGE    93100000
                   EXEC CICS RETURN END-EXEC                            93400000
           END-EVALUATE                                                 93700000
           EXIT.                                                        94000000
        UPDATE-FILE-END.                                                94300000
           EXIT.                                                        94600000
                                                                        94900000
      *================================================================*95200000
      * Procedure to handle unknown requests                           *95500000
      *================================================================*95800000
        REQUEST-NOT-RECOGNISED.                                         96100000
           MOVE '99' TO CA-RETURN-CODE                                  96400000
           MOVE CA-REQUEST-ID TO EM-REQUEST-ID                          96700000
           MOVE ' UNKNOWN REQUEST ID RECEIVED - ' TO EM-DETAIL          97000000
           MOVE CA-REQUEST-ID TO EM-DETAIL(31:6)                        97300000
           MOVE 'OPERATION UNKNOWN' TO CA-RESPONSE-MESSAGE              97600000
           PERFORM WRITE-ERROR-MESSAGE                                  97900000
           EXIT.                                                        98200000
        REQUEST-NOT-RECOGNISED-END.                                     98500000
           EXIT.                                                        98800000
                                                                        99100000
                                                                        99400000
                                                                        99700000