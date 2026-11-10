       CBL CICS('COBOL3') APOST                                         00100000
      ******************************************************************00200000
      *                                                                *00300000
      * MODULE NAME = DFH0XGUI                                         *00400000
      *                                                                *00500000
      * DESCRIPTIVE NAME = CICS     (Samples) Example Application -    *00600000
      *                                       BMS Interfaec Manager    *00700000
      *                                                                *00800000
      *  @BANNER_START                           01                    *00816600
      *  Licensed Materials - Property of IBM                          *00833200
      *                                                                *00849800
      *  5655-M15              DFH0XGUI                                *00866400
      *                                                                *00883000
      *  (C) Copyright IBM Corp. 2004                                  *00899600
      *                                                                *00916200
      *  CICS                                                          *00932800
      *  (Element of CICS Transaction Server                           *00949400
      *  for z/OS, Version 3 Release 1)                                *00966000
      *  @BANNER_END                                                   *00982600
      *                                                                *01000000
      * STATUS = 6.4.0                                                 *01100000
      *                                                                *01200000
      * TRANSACTION NAME = n/a                                         *01300000
      *                                                                *01400000
      * FUNCTION =                                                     *01500000
      *      This program handles the view portion of the application  *01600000
      *      managing the interaction with the BMS interface           *01700000
      *                                                                *01800000
      *----------------------------------------------------------------*01900000
      *                                                                *02000000
      * ENTRY POINT = DFH0XGUI                                         *02100000
      *                                                                *02200000
      *----------------------------------------------------------------*02300000
      *                                                                *02400000
      * CHANGE ACTIVITY :                                              *02500000
      *                                                                *02600000
      *      $MOD(DFH0XGUI),COMP(SAMPLES),PROD(CICS    ):              *02700000
      *                                                                *02800000
      *   PN= REASON REL YYMMDD HDXXIII : REMARKS                      *02900000
      *  $D0= I07544 640 040917 HDIPCB  : BMS MAPS FOR THE EXAMPLE APP *02950000
      *   $D0= I07544 640 040910 HDIPCB  : EXAMPLE - BASE APPLICATION  *03000000
      *                                                                *03100000
      ******************************************************************03200000
                                                                        03300000
       IDENTIFICATION DIVISION.                                         03400000
       PROGRAM-ID. DFH0XGUI.                                            03500000
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
                                        VALUE 'DFH0XGUI------WS'.       04600000
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
           03 FILLER                   PIC X(9)  VALUE ' DFH0XGUI'.     06200000
           03 FILLER                   PIC X(11) VALUE ' REQUESTID='.   06300000
           03 EM-REQUEST-ID            PIC X(6)  VALUE SPACES.          06400000
           03 FILLER                   PIC X     VALUE SPACES.          06500000
           03 EM-DETAIL                PIC X(50) VALUE SPACES.          06600000
                                                                        06700000
      * Key into the configuration file                                 06800000
       01 EXAMPLE-APP-CONFIG           PIC X(9)                         06900000
               VALUE 'EXMP-CONF'.                                       07000000
                                                                        07100000
      * Format of the configuration file                                07200000
       01 APP-CONFIG.                                                   07300000
           03 FILE-KEY                 PIC X(9).                        07400000
           03 FILLER                   PIC X(8).                        07500000
           03 CATMAN-PROG              PIC X(8).                        07600000
           03 FILLER                   PIC X(55).                       07700000
                                                                        07800000
       01 PROGRAM-EXIT-MESSAGE         PIC X(43)                        07900000
               VALUE 'Thank You for using the Catalog Application'.     08000000
                                                                        08100000
       01 CONSTANTS.                                                    08200000
           03 LINK-COMMAREA-LENGTH     PIC S9(4) COMP VALUE 998.        08300000
                                                                        08400000
       01 WORKING-VARIABLES.                                            08500000
           03 WS-LOOP-COUNTER          PIC S9(4) COMP.                  08600000
           03 DATA-VALID-FLAG          PIC X   VALUE '1'.               08700000
               88 DATA-VALID                   VALUE '1'.               08800000
               88 DATA-INVALID                 VALUE '2'.               08900000
                                                                        09000000
      * Working storage copy of the Communication Area                  09100000
       01 WS-COMMAREA.                                                  09200000
           COPY DFH0XCP1.                                               09300000
           03 FLAGS.                                                    09400000
               05 PROCESSING-MAP-FLAG      PIC X   VALUE '1'.           09500000
                   88 PROCESSING-MENU-MAP          VALUE '1'.           09600000
                   88 PROCESSING-INQ-MAP           VALUE '2'.           09700000
                   88 PROCESSING-ORDER-MAP         VALUE '3'.           09800000
               05 ORDER-SELECT-FLAG        PIC X   VALUE '2'.           09900000
                   88 ORDER-REQ-FOUND              VALUE '1'.           10000000
                   88 ORDER-REQ-NOT-FOUND          VALUE '2'.           10100000
               05 DEBUG-FLAG               PIC X   VALUE '1'.           10200000
                   88 DEBUG-ON                     VALUE '1'.           10300000
                   88 DEBUG-OFF                    VALUE '2'.           10400000
               05 INQ-SCROLL-FLAG          PIC X   VALUE '2'.           10500000
                   88 DATA-SCROLLED                VALUE '1'.           10600000
                   88 DATA-NOT-SCROLLED            VALUE '2'.           10700000
                                                                        10800000
           03 SWITCHES.                                                 10900000
               05 SEND-SWITCH              PIC X   VALUE '1'.           11000000
                   88 SEND-ERASE                   VALUE '1'.           11100000
                   88 SEND-DATAONLY                VALUE '2'.           11200000
                   88 SEND-ALARM                   VALUE '3'.           11300000
                                                                        11400000
           03 WS-VARIABLES.                                             11500000
               05 WS-CATALOGMANAGER-PROG   PIC X(8)  VALUE SPACES.      11600000
               05 WS-ORDER-ITEM-REF        PIC X(4)  VALUE SPACES.      11700000
               05 WS-INQ-START-ITEM-REF    pIC X(4)  VALUE SPACES.      11800000
               05 WS-INQ-ITEM-LIST-DEPTH   PIC S9(4) COMP VALUE 1.      11900000
               05 WS-INQ-ITEM-LIST-CURRENT PIC S9(4) COMP VALUE 1.      12000000
               05 WS-INQ-QNAME             PIC X(10) VALUE SPACES.      12100000
                                                                        12200000
                                                                        12300000
       01 DEBUG.                                                        12400000
           03 DEBUG-STRING             PIC X(150)  VALUE SPACES.        12500000
           03 DEBUG-NUMERIC            PIC S9(4)   USAGE DISPLAY.       12600000
                                                                        12700000
                                                                        12800000
       COPY DFH0XM1.                                                    12900000
       COPY DFH0XM2U.                                                   13000000
                                                                        13100000
       COPY DFHAID.                                                     13200000
                                                                        13300000
      *----------------------------------------------------------------*13400000
                                                                        13500000
      ******************************************************************13600000
      *    L I N K A G E   S E C T I O N                                13700000
      ******************************************************************13800000
       LINKAGE SECTION.                                                 13900000
                                                                        14000000
       01 DFHCOMMAREA.                                                  14100000
           03 LINK-COMMAREA            PIC X(998).                      14200000
           03 WORKING-STORAGE-DATA     PIC X(42).                       14300000
                                                                        14400000
                                                                        14500000
      ******************************************************************14600000
      *    P R O C E D U R E S                                          14700000
      ******************************************************************14800000
       PROCEDURE DIVISION.                                              14900000
                                                                        15000000
      *----------------------------------------------------------------*15100000
       MAINLINE SECTION.                                                15200000
                                                                        15300000
      *----------------------------------------------------------------*15400000
      * Common code                                                    *15500000
      *----------------------------------------------------------------*15600000
      * initialize working storage variables                            15700000
           INITIALIZE ERROR-MSG.                                        15800000
                                                                        15900000
      * set up general variable                                         16000000
           MOVE EIBTRNID TO WS-TRANSID.                                 16100000
           MOVE EIBTRMID TO WS-TERMID.                                  16200000
           MOVE EIBTASKN TO WS-TASKNUM.                                 16300000
                                                                        16400000
           IF EIBCALEN EQUAL ZERO                                       16500000
      *    First invocation - read configuration                        16600000
               EXEC CICS READ FILE('EXMPCONF')                          16700000
                            INTO(APP-CONFIG)                            16800000
                            RIDFLD(EXAMPLE-APP-CONFIG)                  16900000
               END-EXEC                                                 17000000
                                                                        17100000
               MOVE CATMAN-PROG TO WS-CATALOGMANAGER-PROG               17200000
                                                                        17300000
      *    Set up name of inquire queue used to support scrolling       17400000
               STRING WS-TERMID 'EXIQ'                                  17500000
                   DELIMITED BY SIZE                                    17600000
                   INTO WS-INQ-QNAME                                    17700000
               END-STRING                                               17800000
                                                                        17900000
           END-IF                                                       18000000
                                                                        18100000
                                                                        18200000
           IF EIBCALEN > ZERO                                           18300000
               MOVE DFHCOMMAREA TO WS-COMMAREA                          18400000
               MOVE LOW-VALUE TO EXMENUO                                18500000
               MOVE LOW-VALUE TO EXORDRO                                18600000
               MOVE LOW-VALUE TO EXINQCO                                18700000
      *        Read in configuration file and set up program names      18800000
           END-IF                                                       18900000
                                                                        19000000
           EXEC CICS IGNORE CONDITION MAPFAIL END-EXEC                  19100000
                                                                        19200000
      *-----------------------------------------------------------------19300000
      * Check which operation is being requested                        19400000
      *----------------------------------------------------------------*19500000
                                                                        19600000
           EVALUATE TRUE                                                19700000
               WHEN EIBCALEN EQUAL ZERO                                 19800000
      *        First Invocation - set up commarea and send main menu    19900000
      *        Set up switches                                          20000000
                   SET SEND-ERASE TO TRUE                               20100000
                   MOVE LOW-VALUE TO EXMENUO                            20200000
                   PERFORM SEND-MAIN-MENU                               20300000
                                                                        20400000
               WHEN EIBAID EQUAL DFHCLEAR                               20500000
      *        Clear key pressed - clear data on map                    20600000
                   PERFORM CLEAR-MAP                                    20700000
                                                                        20800000
               WHEN EIBAID EQUAL DFHPA1 OR DFHPA2 OR DFHPA3             20900000
      *        Attention keys - do nothing special                      21000000
                                                                        21100000
               WHEN EIBAID EQUAL DFHPF3                                 21200000
      *        Exit application                                         21300000
                   PERFORM APPLICATION-EXIT                             21400000
                                                                        21500000
               WHEN EIBAID EQUAL DFHPF7                                 21600000
      *        Inquiry menu scroll backwards                            21700000
                   IF PROCESSING-INQ-MAP                                21800000
                       PERFORM PROCESS-INQUIRY-MAP-PREVIOUS             21900000
                   ELSE                                                 22000000
                       MOVE 'OPTION NOT RECOGNISED' TO MSG1O            22100000
                       PERFORM INVALID-MENU-INPUT                       22200000
                   END-IF                                               22300000
                                                                        22400000
               WHEN EIBAID EQUAL DFHPF8                                 22500000
      *        Inquiry menu scroll backwards                            22600000
                   IF PROCESSING-INQ-MAP                                22700000
                       PERFORM PROCESS-INQUIRY-MAP-NEXT                 22800000
                   ELSE                                                 22900000
                       MOVE 'OPTION NOT RECOGNISED' TO MSG1O            23000000
                       PERFORM INVALID-MENU-INPUT                       23100000
                   END-IF                                               23200000
                                                                        23300000
               WHEN EIBAID EQUAL DFHPF12                                23400000
      *        Cancel request                                           23500000
      *          If on main menu - exit                                 23600000
                   IF PROCESSING-MENU-MAP                               23700000
                       PERFORM APPLICATION-EXIT                         23800000
      *          Else - send main menu map                              23900000
                   ELSE                                                 24000000
      *                If on inquiry panel delete data used for scrolls 24100000
                       IF PROCESSING-INQ-MAP                            24200000
                           PERFORM DELETE-INQ-Q                         24300000
                       END-IF                                           24400000
                                                                        24500000
                       SET SEND-ERASE TO TRUE                           24600000
                       PERFORM SEND-MAIN-MENU                           24700000
                   END-IF                                               24800000
                                                                        24900000
                                                                        25000000
               WHEN EIBAID EQUAL DFHENTER                               25100000
      *        Process input from map                                   25200000
                   EVALUATE TRUE                                        25300000
                       WHEN PROCESSING-MENU-MAP                         25400000
                           PERFORM PROCESS-MENU-INPUT                   25500000
                       WHEN PROCESSING-INQ-MAP                          25600000
                           PERFORM PROCESS-INQUIRE-INPUT                25700000
                       WHEN PROCESSING-ORDER-MAP                        25800000
                           PERFORM PROCESS-ORDER-INPUT                  25900000
                   END-EVALUATE                                         26000000
                                                                        26100000
               WHEN OTHER                                               26200000
      *        Input not recognised - send error message                26300000
                   MOVE 'OPTION NOT RECOGNISED' TO MSG1O                26400000
                   PERFORM INVALID-MENU-INPUT                           26500000
           END-EVALUATE                                                 26600000
                                                                        26700000
      * Return to caller                                                26800000
           EXEC CICS RETURN TRANSID(WS-TRANSID)                         26900000
                            COMMAREA(WS-COMMAREA)                       27000000
           END-EXEC.                                                    27100000
                                                                        27200000
       MAINLINE-EXIT.                                                   27300000
           EXIT.                                                        27400000
      *----------------------------------------------------------------*27500000
                                                                        27600000
      *================================================================*27700000
      * Procedure to write error message to TD QUEUE(CSMT)             *27800000
      *   message will include Date, Time, Program Name,               *27900000
      *   and error details.                                           *28000000
      *================================================================*28100000
       WRITE-ERROR-MESSAGE.                                             28200000
      * Obtain and format current time and date                         28300000
           EXEC CICS ASKTIME ABSTIME(ABS-TIME)                          28400000
           END-EXEC                                                     28500000
           EXEC CICS FORMATTIME ABSTIME(ABS-TIME)                       28600000
                     MMDDYYYY(DATE1)                                    28700000
                     TIME(TIME1)                                        28800000
           END-EXEC                                                     28900000
           MOVE DATE1 TO EM-DATE                                        29000000
           MOVE TIME1 TO EM-TIME                                        29100000
      * Write output message to TDQ                                     29200000
           EXEC CICS WRITEQ TD QUEUE('CSMT')                            29300000
                     FROM(ERROR-MSG)                                    29400000
                     LENGTH(LENGTH OF ERROR-MSG)                        29500000
           END-EXEC.                                                    29600000
           EXIT.                                                        29700000
                                                                        29800000
                                                                        29900000
      *================================================================*30000000
      * Procedure to send the main menu BMS map                        *30100000
      *================================================================*30200000
        SEND-MAIN-MENU.                                                 30300000
           SET PROCESSING-MENU-MAP TO TRUE                              30400000
           EVALUATE TRUE                                                30500000
               WHEN SEND-ERASE                                          30600000
                   EXEC CICS SEND MAP('EXMENU')                         30700000
                                  MAPSET('DFH0XS1')                     30800000
                                  FROM (EXMENUO)                        30900000
                                  ERASE                                 31000000
                   END-EXEC                                             31100000
               WHEN SEND-DATAONLY                                       31200000
                   EXEC CICS SEND MAP('EXMENU')                         31300000
                                  MAPSET('DFH0XS1')                     31400000
                                  FROM(EXMENUO)                         31500000
                                  DATAONLY                              31600000
                   END-EXEC                                             31700000
               WHEN SEND-ALARM                                          31800000
                   EXEC CICS SEND MAP('EXMENU')                         31900000
                                  MAPSET('DFH0XS1')                     32000000
                                  FROM(EXMENUO)                         32100000
                                  ERASE                                 32200000
                                  ALARM                                 32300000
                   END-EXEC                                             32400000
           END-EVALUATE                                                 32500000
           EXIT.                                                        32600000
                                                                        32700000
      *================================================================*32800000
      * Procedure to send the order panel BMS map                      *32900000
      *================================================================*33000000
        SEND-ORDER-PANEL.                                               33100000
                                                                        33200000
           SET PROCESSING-ORDER-MAP TO TRUE                             33300000
           EVALUATE TRUE                                                33400000
               WHEN SEND-ERASE                                          33500000
                   EXEC CICS SEND MAP('EXORDR')                         33600000
                                  MAPSET('DFH0XS1')                     33700000
                                  FROM (EXORDRO)                        33800000
                                  ERASE                                 33900000
                   END-EXEC                                             34000000
               WHEN SEND-DATAONLY                                       34100000
                   EXEC CICS SEND MAP('EXORDR')                         34200000
                                  MAPSET('DFH0XS1')                     34300000
                                  FROM(EXORDRO)                         34400000
                                  DATAONLY                              34500000
                   END-EXEC                                             34600000
               WHEN SEND-ALARM                                          34700000
                   EXEC CICS SEND MAP('EXORDR')                         34800000
                                  MAPSET('DFH0XS1')                     34900000
                                  FROM(EXORDRO)                         35000000
                                  DATAONLY                              35100000
                                  ALARM                                 35200000
                   END-EXEC                                             35300000
           END-EVALUATE                                                 35400000
           EXIT.                                                        35500000
                                                                        35600000
      *================================================================*35700000
      * Procedure to send the inquire panel BMS map                    *35800000
      *================================================================*35900000
        SEND-INQUIRE-PANEL.                                             36000000
           SET PROCESSING-INQ-MAP TO TRUE                               36100000
           EVALUATE TRUE                                                36200000
               WHEN SEND-ERASE                                          36300000
                   EXEC CICS SEND MAP('EXINQC')                         36400000
                                  MAPSET('DFH0XS2')                     36500000
                                  FROM (EXINQCO)                        36600000
                                  ERASE                                 36700000
                   END-EXEC                                             36800000
               WHEN SEND-DATAONLY                                       36900000
                   EXEC CICS SEND MAP('EXINQC')                         37000000
                                  MAPSET('DFH0XS2')                     37100000
                                  FROM(EXINQCO)                         37200000
                                  DATAONLY                              37300000
                   END-EXEC                                             37400000
               WHEN SEND-ALARM                                          37500000
                   EXEC CICS SEND MAP('EXINQC')                         37600000
                                  MAPSET('DFH0XS2')                     37700000
                                  FROM(EXINQCO)                         37800000
                                  DATAONLY                              37900000
                                  ALARM                                 38000000
                   END-EXEC                                             38100000
           END-EVALUATE                                                 38200000
           EXIT.                                                        38300000
                                                                        38400000
                                                                        38500000
                                                                        38600000
      *================================================================*38700000
      * Procedure to terminate the application and exit                *38800000
      *================================================================*38900000
        APPLICATION-EXIT.                                               39000000
           IF PROCESSING-INQ-MAP                                        39100000
               PERFORM DELETE-INQ-Q                                     39200000
           END-IF                                                       39300000
           EXEC CICS SEND TEXT FROM(PROGRAM-EXIT-MESSAGE)               39400000
                     ERASE                                              39500000
                     FREEKB                                             39600000
           END-EXEC                                                     39700000
           EXEC CICS RETURN END-EXEC                                    39800000
           EXIT.                                                        39900000
                                                                        40000000
      *================================================================*40100000
      * Procedure to clear the user entered data and redisplay map     *40200000
      *================================================================*40300000
        CLEAR-MAP.                                                      40400000
           EVALUATE TRUE                                                40500000
               WHEN PROCESSING-MENU-MAP                                 40600000
                   MOVE LOW-VALUE TO EXMENUO                            40700000
                   SET SEND-ERASE TO TRUE                               40800000
                   PERFORM SEND-MAIN-MENU                               40900000
               WHEN PROCESSING-INQ-MAP                                  41000000
                   MOVE LOW-VALUE TO EXINQCO                            41100000
                   PERFORM POPULATE-INQUIRE-MAP                         41200000
                   SET SEND-ERASE TO TRUE                               41300000
                   PERFORM SEND-INQUIRE-PANEL                           41400000
               WHEN PROCESSING-ORDER-MAP                                41500000
                   MOVE 1 TO WS-LOOP-COUNTER                            41600000
                   MOVE LOW-VALUE TO EXORDRO                            41700000
                   MOVE CA-ITEM-REF(WS-LOOP-COUNTER) TO ORDR-ITEMREFO   41800000
                   MOVE CA-DESCRIPTION(WS-LOOP-COUNTER)                 41900000
                           TO ORDR-DESCO                                42000000
                   MOVE CA-COST(WS-LOOP-COUNTER) TO  ORDR-COSTO         42100000
                   INSPECT ORDR-COSTO REPLACING LEADING '0' BY ' '      42200000
                                                                        42300000
                   MOVE IN-STOCK(WS-LOOP-COUNTER) TO ORDR-STKO          42400000
                   MOVE ON-ORDER(WS-LOOP-COUNTER) TO ORDR-ORDO          42500000
                   SET SEND-ERASE TO TRUE                               42600000
                   PERFORM SEND-ORDER-PANEL                             42700000
           EXIT.                                                        42800000
                                                                        42900000
      *================================================================*43000000
      * Procedure to process the input from the main menu panel        *43100000
      *================================================================*43200000
        PROCESS-MENU-INPUT.                                             43300000
                                                                        43400000
           EXEC CICS RECEIVE MAP('EXMENU')                              43500000
                             MAPSET('DFH0XS1')                          43600000
                             INTO(EXMENUI)                              43700000
           END-EXEC                                                     43800000
                                                                        43900000
           IF ACTIONI EQUAL SPACES                                      44000000
               MOVE 'INVALID OPTION: PLEASE SELECT 1, 2 OR 3' TO MSG1O  44100000
                   PERFORM INVALID-MENU-INPUT                           44200000
           ELSE                                                         44300000
                                                                        44400000
                                                                        44500000
                                                                        44600000
               EVALUATE ACTIONI                                         44700000
                   WHEN '1'                                             44800000
      *            Process inquire of catalog                           44900000
                       PERFORM PROCESS-MENU-INQUIRE-REQUEST             45000000
                   WHEN '2'                                             45100000
      *            Process Order Item                                   45200000
                       PERFORM PROCESS-MENU-ORDER-REQUEST               45300000
                   WHEN '3'                                             45400000
      *            Exit application                                     45500000
                       PERFORM APPLICATION-EXIT                         45600000
                   WHEN OTHER                                           45700000
                       MOVE 'INVALID OPTION: PLEASE SELECT 1, 2 OR 3'   45800000
                               TO MSG1O                                 45900000
                       PERFORM INVALID-MENU-INPUT                       46000000
               END-EVALUATE                                             46100000
           END-IF                                                       46200000
           EXIT.                                                        46300000
      *================================================================*46400000
      * Procedure to process the input from the inquire panel          *46500000
      *================================================================*46600000
        PROCESS-MENU-INQUIRE-REQUEST.                                   46700000
           PERFORM INITIALIZE-LINK-COMMAREA                             46800000
           MOVE 0000 TO WS-INQ-START-ITEM-REF                           46900000
                                                                        47000000
           PERFORM CATALOG-INQUIRE                                      47100000
                                                                        47200000
           EXIT.                                                        47300000
                                                                        47400000
      *================================================================*47500000
      * Procedure to process the input from the order panel            *47600000
      *================================================================*47700000
        PROCESS-MENU-ORDER-REQUEST.                                     47800000
           INSPECT ITEM-REFI REPLACING LEADING ' ' BY ZERO              47900000
                                                                        48000000
           EVALUATE TRUE                                                48100000
               WHEN ITEM-REFI EQUAL LOW-VALUE OR SPACE                  48200000
                   MOVE 'TO PLACE ORDER PLEASE ENTER A VALID ITEM REF'  48300000
                       TO MSG1O                                         48400000
                   PERFORM INVALID-MENU-INPUT                           48500000
               WHEN ITEM-REFI NOT NUMERIC                               48600000
                   MOVE 'TO PLACE ORDER PLEASE ENTER A VALID ITEM REF'  48700000
                       TO MSG1O                                         48800000
                   PERFORM INVALID-MENU-INPUT                           48900000
               WHEN OTHER                                               49000000
                   PERFORM INITIALIZE-LINK-COMMAREA                     49100000
                   MOVE '01INQS' TO CA-REQUEST-ID                       49200000
                   MOVE ITEM-REFI TO CA-ITEM-REF-REQ                    49300000
                   EXEC CICS LINK PROGRAM(WS-CATALOGMANAGER-PROG)       49400000
                                  COMMAREA(WS-COMMAREA)                 49500000
                                  DATALENGTH(LINK-COMMAREA-LENGTH)      49600000
                   END-EXEC                                             49700000
                                                                        49800000
               IF CA-RETURN-CODE EQUAL '00'                             49900000
                       MOVE LOW-VALUE TO EXORDRO                        50000000
                       MOVE ITEM-REFI TO ORDR-ITEMREFO                  50100000
                       MOVE CA-SNGL-DESCRIPTION TO ORDR-DESCO           50200000
                                                                        50300000
                       MOVE CA-SNGL-COST TO  ORDR-COSTO                 50400000
                       INSPECT ORDR-COSTO REPLACING LEADING '0' BY ' '  50500000
                                                                        50600000
                       MOVE IN-SNGL-STOCK TO ORDR-STKO                  50700000
                       MOVE ON-SNGL-ORDER TO ORDR-ORDO                  50800000
                                                                        50900000
                       MOVE ITEM-REFI TO WS-ORDER-ITEM-REF              51000000
                                                                        51100000
                       SET SEND-ERASE TO TRUE                           51200000
                       PERFORM SEND-ORDER-PANEL                         51300000
                   ELSE                                                 51400000
                       MOVE CA-RESPONSE-MESSAGE TO MSG1O                51500000
                       PERFORM INVALID-MENU-INPUT                       51600000
                   END-IF                                               51700000
           END-EVALUATE                                                 51800000
                                                                        51900000
                                                                        52000000
                                                                        52100000
                                                                        52200000
           EXIT.                                                        52300000
      *================================================================*52400000
      * Procedure to handle unknown input on the main menu             *52500000
      *================================================================*52600000
        INVALID-MENU-INPUT.                                             52700000
           SET SEND-ALARM TO TRUE                                       52800000
           PERFORM SEND-MAIN-MENU                                       52900000
           EXIT.                                                        53000000
                                                                        53100000
      *================================================================*53200000
      * Procedure to handle errors from the order panel                *53300000
      *================================================================*53400000
        ORDER-ERROR.                                                    53500000
                                                                        53600000
           SET SEND-ALARM TO TRUE                                       53700000
           PERFORM SEND-ORDER-PANEL                                     53800000
           EXIT.                                                        53900000
                                                                        54000000
      *================================================================*54100000
      * Procedure to link to Datastore program to inquire              *54200000
      *   on the catalog data                                          *54300000
      *================================================================*54400000
        CATALOG-INQUIRE.                                                54500000
                                                                        54600000
           MOVE '01INQC' TO CA-REQUEST-ID                               54700000
           MOVE WS-INQ-START-ITEM-REF TO CA-LIST-START-REF              54800000
                                                                        54900000
           EXEC CICS LINK PROGRAM(WS-CATALOGMANAGER-PROG)               55000000
                          COMMAREA(WS-COMMAREA)                         55100000
                          DATALENGTH(LINK-COMMAREA-LENGTH)              55200000
           END-EXEC                                                     55300000
                                                                        55400000
           IF CA-RETURN-CODE EQUAL 00                                   55500000
                                                                        55600000
               MOVE LOW-VALUE TO EXINQCO                                55700000
               PERFORM POPULATE-INQUIRE-MAP                             55800000
                                                                        55900000
               SET SEND-ERASE TO TRUE                                   56000000
               PERFORM SEND-INQUIRE-PANEL                               56100000
           ELSE                                                         56200000
               MOVE CA-RESPONSE-MESSAGE TO MSG1O                        56300000
               PERFORM INVALID-MENU-INPUT                               56400000
           END-IF                                                       56500000
                                                                        56600000
           EXIT.                                                        56700000
                                                                        56800000
      *================================================================*56900000
      * Procedure to process the input from the inquire panel          *57000000
      *================================================================*57100000
        PROCESS-INQUIRE-INPUT.                                          57200000
      *    Receive the map                                              57300000
           EXEC CICS RECEIVE MAP('EXINQC')                              57400000
                             MAPSET('DFH0XS2')                          57500000
                             INTO(EXINQCI)                              57600000
           END-EXEC                                                     57700000
                                                                        57800000
      *    Check to see if any of the select markers have been checked  57900000
           SET ORDER-REQ-NOT-FOUND TO TRUE                              58000000
           SET DATA-VALID TO TRUE                                       58100000
           PERFORM                                                      58200000
           WITH TEST AFTER                                              58300000
           VARYING WS-LOOP-COUNTER FROM 1 BY 1                          58400000
           UNTIL ORDER-REQ-FOUND OR                                     58500000
                 WS-LOOP-COUNTER EQUAL 15                               58600000
                                                                        58700000
               IF INQ-ORDI(WS-LOOP-COUNTER) EQUAL '/'                   58800000
      *        Item selected - Inquire again to check details           58900000
                   SET ORDER-REQ-FOUND TO TRUE                          59000000
                                                                        59100000
      *            Check to make sure there is an item for this select  59200000
                   IF CA-ITEM-REF(WS-LOOP-COUNTER) NOT NUMERIC          59300000
                       SET DATA-INVALID TO TRUE                         59400000
                   ELSE                                                 59500000
                       MOVE CA-ITEM-REF(WS-LOOP-COUNTER)                59600000
                                   TO WS-ORDER-ITEM-REF                 59700000
                                                                        59800000
                       PERFORM INITIALIZE-LINK-COMMAREA                 59900000
                       MOVE '01INQS' TO CA-REQUEST-ID                   60000000
                       MOVE WS-ORDER-ITEM-REF TO CA-ITEM-REF-REQ        60100000
                       EXEC CICS LINK PROGRAM(WS-CATALOGMANAGER-PROG)   60200000
                                      COMMAREA(WS-COMMAREA)             60300000
                                      DATALENGTH(LINK-COMMAREA-LENGTH)  60400000
                       END-EXEC                                         60500000
                                                                        60600000
                       IF CA-RETURN-CODE EQUAL '00'                     60700000
                           MOVE LOW-VALUE TO EXORDRO                    60800000
                           MOVE CA-SNGL-ITEM-REF TO ORDR-ITEMREFO       60900000
                           MOVE CA-SNGL-DESCRIPTION TO ORDR-DESCO       61000000
                           MOVE CA-SNGL-COST TO  ORDR-COSTO             61100000
                           INSPECT ORDR-COSTO                           61200000
                               REPLACING LEADING '0' BY ' '             61300000
                           MOVE IN-SNGL-STOCK TO ORDR-STKO              61400000
                           MOVE ON-SNGL-ORDER TO ORDR-ORDO              61500000
                                                                        61600000
      *                    Clean up data used for scrolling inquire     61700000
                           PERFORM DELETE-INQ-Q                         61800000
                                                                        61900000
                           SET SEND-ERASE TO TRUE                       62000000
                           PERFORM SEND-ORDER-PANEL                     62100000
                       ELSE                                             62200000
                           MOVE CA-RESPONSE-MESSAGE TO MSG1O            62300000
                           PERFORM INVALID-MENU-INPUT                   62400000
                       END-IF                                           62500000
                   END-IF                                               62600000
               END-IF                                                   62700000
           END-PERFORM                                                  62800000
                                                                        62900000
           IF ORDER-REQ-NOT-FOUND OR DATA-INVALID                       63000000
               MOVE LOW-VALUE TO EXINQCO                                63100000
               PERFORM POPULATE-INQUIRE-MAP                             63200000
               MOVE 'PLEASE SELECT AN ITEM TO ORDER WITH A /'           63300000
                    TO INQC-MSGO                                        63400000
               SET SEND-ERASE TO TRUE                                   63500000
               PERFORM SEND-INQUIRE-PANEL                               63600000
           END-IF                                                       63700000
                                                                        63800000
                                                                        63900000
           EXIT.                                                        64000000
      *================================================================*64100000
      * Procedure to populate the map data from the commarea           *64200000
      *================================================================*64300000
        POPULATE-INQUIRE-MAP.                                           64400000
           PERFORM                                                      64500000
           WITH TEST AFTER                                              64600000
           VARYING  WS-LOOP-COUNTER FROM 1 BY 1                         64800000
           UNTIL WS-LOOP-COUNTER EQUAL CA-ITEM-COUNT                    65000000
              MOVE CA-ITEM-REF(WS-LOOP-COUNTER)                         65200000
                    TO INQ-ITEMREFO(WS-LOOP-COUNTER)                    65400000
              MOVE CA-DESCRIPTION(WS-LOOP-COUNTER)                      65600000
                    TO INQ-DESCO(WS-LOOP-COUNTER)                       65800000
                                                                        66000000
              MOVE CA-COST(WS-LOOP-COUNTER)                             66200000
                    TO INQ-COSTO(WS-LOOP-COUNTER)                       66400000
                                                                        66600000
              INSPECT INQ-COSTO(WS-LOOP-COUNTER)                        66800000
                    REPLACING LEADING '0' BY ' '                        67000000
                                                                        67200000
           END-PERFORM                                                  67400000
           EXIT.                                                        67600000
                                                                        67800000
                                                                        68000000
      *================================================================*68200000
      * Procedure to process the input from the order panel            *68400000
      *================================================================*68600000
        PROCESS-ORDER-INPUT.                                            68800000
           EXEC CICS RECEIVE MAP('EXORDR')                              69000000
                             MAPSET('DFH0XS1')                          69200000
                             INTO(EXORDRI)                              69400000
           END-EXEC                                                     69600000
                                                                        69800000
      * Check input data is valid                                       70000000
                                                                        70200000
           SET DATA-VALID TO TRUE                                       70400000
                                                                        70600000
           INSPECT ORDR-QUANTITYI REPLACING LEADING ' ' BY ZERO         70800000
                                                                        71000000
           IF ORDR-QUANTITYI NOT NUMERIC                                71200000
            OR ORDR-QUANTITYI NOT GREATER THAN ZERO                     71400000
               MOVE 'TO PLACE ORDER PLEASE ENTER A VALID QUANTITY'      71600000
                   TO ORDR-MSGO                                         71800000
               SET DATA-INVALID TO TRUE                                 72000000
           END-IF                                                       72200000
                                                                        72400000
           IF ORDR-USERIDL EQUAL ZERO                                   72600000
               OR ORDR-DEPTL EQUAL ZERO                                 72800000
               OR ORDR-USERIDI EQUAL SPACE                              73000000
               OR ORDR-DEPTI EQUAL SPACE                                73200000
               MOVE 'TO PLACE ORDER PLEASE ENTER A VALID USERID AND DEPA73400000
      -             'RTMENT'                                            73600000
                   TO ORDR-MSGO                                         73800000
               SET DATA-INVALID TO TRUE                                 74000000
           END-IF                                                       74200000
                                                                        74400000
                                                                        74600000
           IF DATA-VALID                                                74800000
               PERFORM INITIALIZE-LINK-COMMAREA                         75000000
                                                                        75200000
               MOVE '01ORDR' TO CA-REQUEST-ID                           75400000
                                                                        75600000
               MOVE ORDR-USERIDI TO CA-USERID                           75800000
               MOVE ORDR-DEPTI TO CA-CHARGE-DEPT                        76000000
               MOVE WS-ORDER-ITEM-REF TO CA-ITEM-REF-NUMBER             76200000
               MOVE ORDR-QUANTITYI TO CA-QUANTITY-REQ                   76400000
                                                                        76600000
               EXEC CICS LINK PROGRAM(WS-CATALOGMANAGER-PROG)           76800000
                              COMMAREA(WS-COMMAREA)                     77000000
                              DATALENGTH(LINK-COMMAREA-LENGTH)          77200000
               END-EXEC                                                 77400000
                                                                        77600000
               IF CA-RETURN-CODE EQUAL '97'                             77800000
      *        Insufficient stock to complete order                     78000000
                   MOVE 'INSUFFICIENT STOCK TO COMPLETE ORDER'          78200000
                       TO ORDR-MSGO                                     78400000
                   PERFORM ORDER-ERROR                                  78600000
               ELSE                                                     78800000
                   MOVE CA-RESPONSE-MESSAGE TO MSG1O                    79000000
                   SET SEND-ERASE TO TRUE                               79200000
                   PERFORM SEND-MAIN-MENU                               79400000
               END-IF                                                   79600000
           ELSE                                                         79800000
               PERFORM ORDER-ERROR                                      80000000
           END-IF                                                       80200000
                                                                        80400000
           EXIT.                                                        80600000
                                                                        80800000
      *================================================================*81000000
      * Procedure to initialize the commarea prior to requests         *81200000
      *================================================================*81400000
        INITIALIZE-LINK-COMMAREA.                                       81600000
           MOVE LOW-VALUE TO CA-REQUEST-ID                              81800000
           MOVE 00 TO CA-RETURN-CODE                                    82000000
           MOVE LOW-VALUE TO CA-RESPONSE-MESSAGE                        82200000
           INITIALIZE CA-REQUEST-SPECIFIC                               82400000
           EXIT.                                                        82600000
                                                                        82800000
      *================================================================*83000000
      * Procedure to scroll forwards on the inquire map                *83200000
      *================================================================*83400000
        PROCESS-INQUIRY-MAP-PREVIOUS.                                   83600000
           IF WS-INQ-ITEM-LIST-CURRENT EQUAL 1                          83800000
      *        We are on the first panel so cannot scroll back          84000000
               PERFORM POPULATE-INQUIRE-MAP                             84200000
               MOVE 'START OF DATA' TO INQC-MSGO                        84400000
               SET SEND-ERASE TO TRUE                                   84600000
               PERFORM SEND-INQUIRE-PANEL                               84800000
           ELSE                                                         85000000
      *        Scroll back to previous panel                            85200000
               SUBTRACT 1 FROM WS-INQ-ITEM-LIST-CURRENT                 85400000
               EXEC CICS READQ TS QUEUE(WS-INQ-QNAME)                   85600000
                                  ITEM(WS-INQ-ITEM-LIST-CURRENT)        85800000
                                  INTO(WS-INQ-START-ITEM-REF)           86000000
               END-EXEC                                                 86200000
                                                                        86400000
               PERFORM CATALOG-INQUIRE                                  86600000
                                                                        86800000
                                                                        87000000
           END-IF                                                       87200000
                                                                        87400000
           EXIT.                                                        87600000
                                                                        87800000
      *================================================================*88000000
      * Procedure to scroll forwards on the inquire map                *88200000
      *================================================================*88400000
        PROCESS-INQUIRY-MAP-NEXT.                                       88600000
           IF DATA-NOT-SCROLLED                                         88800000
      *    First time scrolling - set flag and inital value in list     89000000
               SET DATA-SCROLLED TO TRUE                                89200000
               EXEC CICS WRITEQ TS QUEUE(WS-INQ-QNAME)                  89400000
                                FROM(WS-INQ-START-ITEM-REF)             89600000
               END-EXEC                                                 89800000
           END-IF                                                       90000000
                                                                        90200000
           IF CA-ITEM-COUNT LESS THAN 15                                90400000
               PERFORM POPULATE-INQUIRE-MAP                             90600000
               MOVE 'END OF DATA' TO INQC-MSGO                          90800000
               SET SEND-ERASE TO TRUE                                   91000000
               PERFORM SEND-INQUIRE-PANEL                               91200000
           ELSE                                                         91400000
               IF WS-INQ-ITEM-LIST-CURRENT EQUAL WS-INQ-ITEM-LIST-DEPTH 91600000
                   MOVE CA-LAST-ITEM-REF TO WS-INQ-START-ITEM-REF       91800000
      *            Add current first item in list to the inq queue      92000000
                   EXEC CICS WRITEQ TS QUEUE(WS-INQ-QNAME)              92200000
                                    FROM(WS-INQ-START-ITEM-REF)         92400000
                   END-EXEC                                             92600000
                   ADD 1 TO WS-INQ-ITEM-LIST-DEPTH                      92800000
                   ADD 1 TO WS-INQ-ITEM-LIST-CURRENT                    93000000
               ELSE                                                     93200000
                   ADD 1 TO WS-INQ-ITEM-LIST-CURRENT                    93400000
      *            Read the item-ref to start inquire from the ts queue 93600000
                   EXEC CICS READQ TS QUEUE(WS-INQ-QNAME)               93800000
                                      ITEM(WS-INQ-ITEM-LIST-CURRENT)    94000000
                                      INTO(WS-INQ-START-ITEM-REF)       94200000
                   END-EXEC                                             94400000
               END-IF                                                   94600000
               PERFORM CATALOG-INQUIRE                                  94800000
           END-IF                                                       95000000
                                                                        95200000
           EXIT.                                                        95400000
                                                                        95600000
      *================================================================*95800000
      * Procedure to delete the TS queue of inquiry item refs          *96000000
      *================================================================*96200000
        DELETE-INQ-Q.                                                   96400000
           IF DATA-SCROLLED                                             96600000
                SET DATA-NOT-SCROLLED TO TRUE                           96800000
                MOVE 1 TO WS-INQ-ITEM-LIST-CURRENT                      97000000
                MOVE 1 TO WS-INQ-ITEM-LIST-DEPTH                        97200000
                                                                        97400000
                EXEC CICS DELETEQ TS QUEUE(WS-INQ-QNAME)                97600000
                END-EXEC                                                97800000
           END-IF                                                       98000000
           EXIT.                                                        98200000
                                                                        98400000
        DEBUG-OUT.                                                      98600000
           IF DEBUG-ON                                                  98800000
               EXEC CICS WRITEQ TS  QUEUE('DEBUG-Q')                    99000000
                                    FROM (DEBUG-STRING)                 99200000
               END-EXEC                                                 99400000
           END-IF                                                       99600000
           EXIT.                                                        99800000