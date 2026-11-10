       CBL CICS('COBOL3') APOST                                         00200000
      ******************************************************************00400000
      *                                                                *00600000
      * MODULE NAME = DFH0XSDS                                         *00800000
      *                                                                *01000000
      * DESCRIPTIVE NAME = CICS     (Samples) Example Application -    *01200000
      *                                       Data Store Stub          *01400000
      *                                                                *01600000
      *  @BANNER_START                           01                    *01633300
      *  Licensed Materials - Property of IBM                          *01666600
      *                                                                *01699900
      *  5655-M15              DFH0XSDS                                *01733200
      *                                                                *01766500
      *  (C) Copyright IBM Corp. 2004                                  *01799800
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
      *      This program is a stubbed, dummy, version of the data     *03200000
      *      store for the example application to allow it to work     *03400000
      *      without having to set up the VSAM file                    *03600000
      *                                                                *03800000
      *----------------------------------------------------------------*04000000
      *                                                                *04200000
      * ENTRY POINT = DFH0XSDS                                         *04400000
      *                                                                *04600000
      *----------------------------------------------------------------*04800000
      * CHANGE ACTIVITY :                                              *05000000
      *      $MOD(DFH0XSDS),COMP(SAMPLES),PROD(CICS    ):              *05200000
      *                                                                *05400000
      *   PN= REASON REL YYMMDD HDXXIII : REMARKS                      *05600000
      *   $D0= I07544 640 040910 HDIPCB  : EXAMPLE - BASE APPLICATION  *05800000
      *                                                                *06000000
      ******************************************************************06200000
       IDENTIFICATION DIVISION.                                         06400000
       PROGRAM-ID. DFH0XSDS.                                            06600000
       ENVIRONMENT DIVISION.                                            06800000
       CONFIGURATION SECTION.                                           07000000
       DATA DIVISION.                                                   07200000
       WORKING-STORAGE SECTION.                                         07400000
      *----------------------------------------------------------------*07600000
      * Common defintions                                              *07800000
      *----------------------------------------------------------------*08000000
      * Run time (debug) infomation for this invocation                 08200000
        01  WS-HEADER.                                                  08400000
           03 WS-EYECATCHER            PIC X(16)                        08600000
                                        VALUE 'DFH0XSDS------WS'.       08800000
           03 WS-TRANSID               PIC X(4).                        09000000
           03 WS-TERMID                PIC X(4).                        09200000
           03 WS-TASKNUM               PIC 9(7).                        09400000
           03 WS-CALEN                 PIC S9(4) COMP.                  09600000
                                                                        09800000
      * Variables for time/date processing                              10000000
       01  ABS-TIME                    PIC S9(8) COMP VALUE +0.         10200000
       01  TIME1                       PIC X(8)  VALUE SPACES.          10400000
       01  DATE1                       PIC X(10) VALUE SPACES.          10600000
                                                                        10800000
      * Program Names to LINK to                                        11000000
       01  WS-DATASTORE-PROG           PIC X(8)  VALUE SPACES.          11200000
       01  WS-DISPATCH-PROG            PIC X(8)  VALUE SPACES.          11400000
       01  WS-STOREMANAGER-PROG        PIC X(8)  VALUE SPACES.          11600000
                                                                        11800000
      * Error Message structure                                         12000000
       01  ERROR-MSG.                                                   12200000
           03 EM-DATE                  PIC X(8)  VALUE SPACES.          12400000
           03 FILLER                   PIC X     VALUE SPACES.          12600000
           03 EM-TIME                  PIC X(6)  VALUE SPACES.          12800000
           03 FILLER                   PIC X(9)  VALUE ' EXMPCMAN'.     13000000
           03 FILLER                   PIC X(11) VALUE ' REQUESTID='.   13200000
           03 EM-REQUEST-ID            PIC X(6)  VALUE SPACES.          13400000
           03 FILLER                   PIC X     VALUE SPACES.          13600000
           03 EM-DETAIL                PIC X(50) VALUE SPACES.          13800000
                                                                        14000000
      * Working Variables                                               14200000
       01 WORKING-VARIABLES.                                            14400000
           03 WS-TABLE-INDEX           PIC 9(4)  VALUE 0.               14600000
           03 WS-COMMDATA-INDEX        PIC 9(4)  VALUE 0.               14800000
                                                                        15000000
      * Constants                                                       15200000
       01 CONSTANTS.                                                    15400000
           03 WS-NUM-ITEMS             PIC 9(4)  VALUE 15.              15600000
                                                                        15800000
      * Dummy data to return on an inquire request                      16000000
       01 WS-INQUIRE-RESPONSE.                                          16200000
           03 WS-REQUEST-ID            PIC X(6).                        16400000
           03 WS-RETURN-CODE           PIC 9(2).                        16600000
           03 WS-RESPONSE-MESSAGE      PIC X(79).                       16800000
           03 WS-INQUIRE-REQUEST.                                       17000000
               05 WS-LIST-START-NUM        PIC 9(4)    VALUE 0010.      17200000
               05 WS-LAST-ITEM-NUM         PIC 9(4)    VALUE 0150.      17400000
               05 WS-ITEM-COUNT            PIC 9(3)    VALUE 015.       17600000
               05 WS-ITEM-TABLE-DATA.                                   17800000
                   07 WS-WST-ITEM-1.                                    18000000
                       09 WS-ITEM-REF          PIC 9(4)    VALUE 0010.  18200000
                       09 WS-DESCRIPTION       PIC X(40)                18400000
                       VALUE 'Ball Pens Black 24pk                    '.18600000
                       09 WS-DEPARTMENT        PIC 9(3)    VALUE 010.   18800000
                       09 WS-COST              PIC ZZZ.99               19000000
                                                       VALUE '002.90'.  19200000
                       09 WS-IN-STOCK          PIC 9(4)    VALUE 0135.  19400000
                       09 WS-ON-ORDER          PIC 9(3)    VALUE 000.   19600000
                   07 WS-CAT-ITEM-2.                                    19800000
                       09 WS-ITEM-REF          PIC 9(4)    VALUE 0020.  20000000
                       09 WS-DESCRIPTION       PIC X(40)                20200000
                       VALUE 'Ball Pens Blue 24pk                     '.20400000
                       09 WS-DEPARTMENT        PIC 9(3)    VALUE 010.   20600000
                       09 WS-COST              PIC ZZZ.99               20800000
                                                   VALUE '002.90'.      21000000
                       09 WS-IN-STOCK          PIC 9(4)    VALUE 0010.  21200000
                       09 WS-ON-ORDER          PIC 9(3)    VALUE 050.   21400000
                   07 WS-CAT-ITEM-3.                                    21600000
                       09 WS-ITEM-REF          PIC 9(4)    VALUE 0030.  21800000
                       09 WS-DESCRIPTION       PIC X(40)                22000000
                       VALUE 'Ball Pens Red 24pk                      '.22200000
                       09 WS-DEPARTMENT        PIC 9(3)    VALUE 010.   22400000
                       09 WS-COST              PIC ZZZ.99               22600000
                                                   VALUE '002.90'.      22800000
                       09 WS-IN-STOCK          PIC 9(4)    VALUE 0113.  23000000
                       09 WS-ON-ORDER          PIC 9(3)    VALUE 000.   23200000
                   07 WS-CAT-ITEM-4.                                    23400000
                       09 WS-ITEM-REF          PIC 9(4)    VALUE 0040.  23600000
                       09 WS-DESCRIPTION       PIC X(40)                23800000
                       VALUE 'Ball Pens Green 24pk                    '.24000000
                       09 WS-DEPARTMENT        PIC 9(3)    VALUE 010.   24200000
                       09 WS-COST              PIC ZZZ.99               24400000
                                                   VALUE '002.90'.      24600000
                       09 WS-IN-STOCK          PIC 9(4)    VALUE 0087.  24800000
                       09 WS-ON-ORDER          PIC 9(3)    VALUE 000.   25000000
                   07 WS-CAT-ITEM-5.                                    25200000
                       09 WS-ITEM-REF          PIC 9(4)    VALUE 0050.  25400000
                       09 WS-DESCRIPTION       PIC X(40)                25600000
                       VALUE 'Pencil with eraser 12pk                 '.25800000
                       09 WS-DEPARTMENT        PIC 9(3)    VALUE 010.   26000000
                       09 WS-COST              PIC ZZZ.99               26200000
                                                   VALUE '001.78'.      26400000
                       09 WS-IN-STOCK          PIC 9(4)    VALUE 0093.  26600000
                       09 WS-ON-ORDER          PIC 9(3)    VALUE 000.   26800000
                   07 WS-CAT-ITEM-6.                                    27000000
                       09 WS-ITEM-REF          PIC 9(4)    VALUE 0060.  27200000
                       09 WS-DESCRIPTION       PIC X(40)                27400000
                       VALUE 'Highlighters Assorted 5pk               '.27600000
                       09 WS-DEPARTMENT        PIC 9(3)    VALUE 010.   27800000
                       09 WS-COST              PIC ZZZ.99               28000000
                                                   VALUE '003.89'.      28200000
                       09 WS-IN-STOCK          PIC 9(4)    VALUE 0014.  28400000
                       09 WS-ON-ORDER          PIC 9(3)    VALUE 040.   28600000
                   07 WS-CAT-ITEM-7.                                    28800000
                       09 WS-ITEM-REF          PIC 9(4)    VALUE 0070.  29000000
                       09 WS-DESCRIPTION       PIC X(40)                29200000
                       VALUE 'Laser Paper 28-lb 108 Bright 500/ream   '.29400000
                       09 WS-DEPARTMENT        PIC 9(3)    VALUE 010.   29600000
                       09 WS-COST              PIC ZZZ.99               29800000
                                                   VALUE '009.44'.      30000000
                       09 WS-IN-STOCK          PIC 9(4)    VALUE 0104.  30200000
                       09 WS-ON-ORDER          PIC 9(3)    VALUE 020.   30400000
                   07 WS-CAT-ITEM-8.                                    30600000
                       09 WS-ITEM-REF          PIC 9(4)    VALUE 0080.  30800000
                       09 WS-DESCRIPTION       PIC X(40)                31000000
                       VALUE 'Laser Paper 28-lb 108 Bright 2500/case  '.31200000
                       09 WS-DEPARTMENT        PIC 9(3)    VALUE 010.   31400000
                       09 WS-COST              PIC ZZZ.99               31600000
                                                   VALUE '033.54'.      31900000
                       09 WS-IN-STOCK          PIC 9(4)    VALUE 0027.  32200000
                       09 WS-ON-ORDER          PIC 9(3)    VALUE 000.   32500000
                   07 WS-CAT-ITEM-9.                                    32800000
                       09 WS-ITEM-REF          PIC 9(4)    VALUE 0090.  33100000
                       09 WS-DESCRIPTION       PIC X(40)                33400000
                       VALUE 'Blue Laser Paper 20lb 500/ream          '.33700000
                       09 WS-DEPARTMENT        PIC 9(3)    VALUE 010.   34000000
                       09 WS-COST              PIC ZZZ.99               34300000
                                                   VALUE '005.35'.      34600000
                       09 WS-IN-STOCK          PIC 9(4)    VALUE 0022.  34900000
                       09 WS-ON-ORDER          PIC 9(3)    VALUE 000.   35200000
                   07 WS-CAT-ITEM-10.                                   35500000
                       09 WS-ITEM-REF          PIC 9(4)    VALUE 0100.  35800000
                       09 WS-DESCRIPTION       PIC X(40)                36100000
                       VALUE 'Green Laser Paper 20lb 500/ream         '.36400000
                       09 WS-DEPARTMENT        PIC 9(3)    VALUE 010.   36700000
                       09 WS-COST              PIC ZZZ.99               37000000
                                                   VALUE '007.35'.      37300000
                       09 WS-IN-STOCK          PIC 9(4)    VALUE 0003.  37600000
                       09 WS-ON-ORDER          PIC 9(3)    VALUE 020.   37900000
                   07 WS-CAT-ITEM-11.                                   38200000
                       09 WS-ITEM-REF          PIC 9(4)    VALUE 0110.  38500000
                       09 WS-DESCRIPTION       PIC X(40)                38800000
                       VALUE 'IBM Network Printer 24 - Toner cart     '.39100000
                       09 WS-DEPARTMENT        PIC 9(3)    VALUE 010.   39400000
                       09 WS-COST              PIC ZZZ.99               39700000
                                                   VALUE '169.56'.      40000000
                       09 WS-IN-STOCK          PIC 9(4)    VALUE 0012.  40300000
                       09 WS-ON-ORDER          PIC 9(3)    VALUE 000.   40600000
                   07 WS-CAT-ITEM-12.                                   40900000
                       09 WS-ITEM-REF          PIC 9(4)    VALUE 0120.  41200000
                       09 WS-DESCRIPTION       PIC X(40)                41500000
                       VALUE 'Standard Diary: Week to view 8 1/4x5 3/4'.41800000
                       09 WS-DEPARTMENT        PIC 9(3)    VALUE 010.   42100000
                       09 WS-COST              PIC ZZZ.99               42400000
                                                   VALUE '025.99'.      42700000
                       09 WS-IN-STOCK          PIC 9(4)    VALUE 0007.  43000000
                       09 WS-ON-ORDER          PIC 9(3)    VALUE 000.   43300000
                   07 WS-CAT-ITEM-13.                                   43600000
                       09 WS-ITEM-REF          PIC 9(4)    VALUE 0130.  43900000
                       09 WS-DESCRIPTION       PIC X(40)                44200000
                       VALUE 'Wall Planner: Eraseable 36x24           '.44500000
                       09 WS-DEPARTMENT        PIC 9(3)    VALUE 010.   44800000
                       09 WS-COST              PIC ZZZ.99               45100000
                                                   VALUE '018.85'.      45400000
                       09 WS-IN-STOCK          PIC 9(4)    VALUE 0003.  45700000
                       09 WS-ON-ORDER          PIC 9(3)    VALUE 000.   46000000
                   07 WS-CAT-ITEM-14.                                   46300000
                       09 WS-ITEM-REF          PIC 9(4)    VALUE 0140.  46600000
                       09 WS-DESCRIPTION       PIC X(40)                46900000
                       VALUE '70 Sheet Hard Back wire bound notepad   '.47200000
                       09 WS-DEPARTMENT        PIC 9(3)    VALUE 010.   47500000
                       09 WS-COST              PIC ZZZ.99               47800000
                                                   VALUE '005.89'.      48100000
                       09 WS-IN-STOCK          PIC 9(4)    VALUE 0084.  48400000
                       09 WS-ON-ORDER          PIC 9(3)    VALUE 000.   48700000
                   07 WS-CAT-ITEM-15.                                   49000000
                       09 WS-ITEM-REF          PIC 9(4)    VALUE 0150.  49300000
                       09 WS-DESCRIPTION       PIC X(40)                49600000
                       VALUE 'Sticky Notes 3x3 Assorted Colors 5pk    '.49900000
                       09 WS-DEPARTMENT        PIC 9(3)    VALUE 010.   50200000
                       09 WS-COST              PIC ZZZ.99               50500000
                                                   VALUE '005.35'.      50800000
                       09 WS-IN-STOCK          PIC 9(4)    VALUE 0036.  51100000
                       09 WS-ON-ORDER          PIC 9(3)    VALUE 040.   51400000
               05 WS-ITEM-TABLE REDEFINES WS-ITEM-TABLE-DATA            51700000
                                OCCURS 15 TIMES.                        52000000
                       07 WS-CAT-ITEM.                                  52300000
                           09 WS-ITEM-REF-NUM      PIC 9(4).            52600000
                           09 WS-DESCRIPTION       PIC X(40).           52900000
                           09 WS-DEPARTMENT        PIC 9(3).            53200000
                           09 WS-COST              PIC ZZZ.99.          53500000
                           09 WS-IN-STOCK          PIC 9(4).            53800000
                           09 WS-ON-ORDER          PIC 9(3).            54100000
                                                                        54400000
      *----------------------------------------------------------------*54700000
                                                                        55000000
      ******************************************************************55300000
      *    L I N K A G E   S E C T I O N                                55600000
      ******************************************************************55900000
       LINKAGE SECTION.                                                 56200000
       01 DFHCOMMAREA.                                                  56500000
           COPY DFH0XCP1.                                               56800000
                                                                        57100000
      ******************************************************************57400000
      *    P R O C E D U R E S                                          57700000
      ******************************************************************58000000
       PROCEDURE DIVISION.                                              58300000
                                                                        58600000
      *----------------------------------------------------------------*58900000
       MAINLINE SECTION.                                                59200000
                                                                        59500000
      *----------------------------------------------------------------*59800000
      * Common code                                                    *60100000
      *----------------------------------------------------------------*60400000
      * initialize working storage variables                            60700000
           INITIALIZE WS-HEADER.                                        61000000
                                                                        61300000
      * set up general variable                                         61600000
           MOVE EIBTRNID TO WS-TRANSID.                                 61900000
           MOVE EIBTRMID TO WS-TERMID.                                  62200000
           MOVE EIBTASKN TO WS-TASKNUM.                                 62500000
                                                                        62800000
      *---------------------------------------------------------------* 63100000
      * Check commarea and obtain required details                    * 63400000
      *---------------------------------------------------------------* 63700000
      * If NO commarea received issue an ABEND                          64000000
           IF EIBCALEN IS EQUAL TO ZERO                                 64300000
               MOVE ' NO COMMAREA RECEIVED' TO EM-DETAIL                64600000
               PERFORM WRITE-ERROR-MESSAGE                              64900000
               EXEC CICS ABEND ABCODE('EXCA') NODUMP END-EXEC           65200000
           END-IF                                                       65500000
                                                                        65800000
      * initalize commarea return code to zero                          66100000
           MOVE '00' TO CA-RETURN-CODE                                  66400000
           MOVE EIBCALEN TO WS-CALEN.                                   66700000
                                                                        67000000
      *----------------------------------------------------------------*67300000
      * Check which operation in being requested                        67600000
      *----------------------------------------------------------------*67900000
      * Uppercase the value passed in the Request Id field              68200000
           MOVE FUNCTION UPPER-CASE(CA-REQUEST-ID) TO CA-REQUEST-ID     68500000
                                                                        68800000
           EVALUATE CA-REQUEST-ID                                       69100000
               WHEN '01INQC'                                            69400000
      *        Call routine to read catalog for inquire                 69700000
                   PERFORM CATALOG-INQUIRE                              70000000
                                                                        70300000
               WHEN '01ORDR'                                            70600000
      *        Call routine to place order                              70900000
                   PERFORM PLACE-ORDER                                  71200000
                                                                        71500000
               WHEN '01INQS'                                            71800000
      *        Call routine to perform for inquire for single item      72100000
                   PERFORM CATALOG-INQUIRE-SINGLE                       72400000
                                                                        72700000
               WHEN OTHER                                               73000000
      *        Request is not recognised or supported                   73300000
                   PERFORM REQUEST-NOT-RECOGNISED                       73600000
                                                                        73900000
           END-EVALUATE                                                 74200000
                                                                        74500000
      * Return to caller                                                74800000
           EXEC CICS RETURN END-EXEC.                                   75100000
                                                                        75400000
       MAINLINE-EXIT.                                                   75700000
           EXIT.                                                        76000000
      *----------------------------------------------------------------*76300000
                                                                        76600000
      *================================================================*76900000
      * Procedure to write error message to TD QUEUE(CSMT)             *77200000
      *   message will include Date, Time, Program Name,               *77500000
      *   and error details.                                           *77800000
      *================================================================*78100000
       WRITE-ERROR-MESSAGE.                                             78400000
      * Obtain and format current time and date                         78700000
           EXEC CICS ASKTIME ABSTIME(ABS-TIME)                          79000000
           END-EXEC                                                     79300000
           EXEC CICS FORMATTIME ABSTIME(ABS-TIME)                       79600000
                     MMDDYYYY(DATE1)                                    79900000
                     TIME(TIME1)                                        80200000
           END-EXEC                                                     80500000
           MOVE DATE1 TO EM-DATE                                        80800000
           MOVE TIME1 TO EM-TIME                                        81100000
      * Write output message to TDQ                                     81400000
           EXEC CICS WRITEQ TD QUEUE('CSMT')                            81700000
                     FROM(ERROR-MSG)                                    82000000
                     LENGTH(LENGTH OF ERROR-MSG)                        82300000
           END-EXEC.                                                    82600000
           EXIT.                                                        82900000
      *================================================================*83200000
      * Procedure to link to Datastore program to inquire              *83500000
      *   on the catalog data                                          *83800000
      *================================================================*84100000
        CATALOG-INQUIRE.                                                84400000
           MOVE '15 ITEMS RETURNED' TO CA-RESPONSE-MESSAGE              84700000
           MOVE WS-INQUIRE-REQUEST TO CA-INQUIRE-REQUEST                85000000
           EXIT.                                                        85300000
                                                                        85600000
      *================================================================*85900000
      * Procedure to link to Datastore program to inquire for a single *86200000
      *   item from the catalog data                                   *86500000
      *================================================================*86800000
        CATALOG-INQUIRE-SINGLE.                                         87100000
                                                                        87400000
      *    Convert item-ref into table index by dividing by 10          87700000
           DIVIDE CA-LIST-START-REF BY 10 GIVING WS-TABLE-INDEX         88000000
                                                                        88300000
      *    Test Item to make sure its within the data                   88600000
           IF WS-TABLE-INDEX GREATER THAN WS-NUM-ITEMS                  88900000
               MOVE 20 TO CA-RETURN-CODE                                89200000
               MOVE 'ITEM NOT FOUND' TO CA-RESPONSE-MESSAGE             89500000
               EXEC CICS RETURN END-EXEC                                89800000
           END-IF                                                       90100000
                                                                        90400000
      *    Populate commarea to return single item                      90700000
           MOVE CA-LIST-START-REF TO CA-LAST-ITEM-REF                   91000000
           MOVE 1 TO WS-COMMDATA-INDEX                                  91300000
           MOVE WS-ITEM-TABLE(WS-TABLE-INDEX)                           91600000
                  TO CA-CAT-ITEM(WS-COMMDATA-INDEX)                     91900000
                                                                        92200000
           EXIT.                                                        92500000
        CATALOG-INQUIRE-SINGLE-END.                                     92800000
           EXIT.                                                        93100000
                                                                        93400000
      *================================================================*93700000
      * Procedure to link to Datastore program to place order,         *94000000
      *   send request to dispatcher and notify stock manager          *94300000
      *   an order has been placed                                     *94600000
      *================================================================*94900000
        PLACE-ORDER.                                                    95200000
           MOVE 'ORDER SUCESSFULLY PLACED' TO CA-RESPONSE-MESSAGE       95500000
           EXIT.                                                        95800000
                                                                        96100000
      *================================================================*96400000
      * Procedure to handle unknown requests                           *96700000
      *================================================================*97000000
        REQUEST-NOT-RECOGNISED.                                         97300000
           MOVE '99' TO CA-RETURN-CODE                                  97600000
           MOVE CA-REQUEST-ID TO EM-REQUEST-ID                          97900000
           MOVE ' UNKNOWN REQUEST ID RECEIVED - ' TO EM-DETAIL          98200000
           MOVE CA-REQUEST-ID TO EM-DETAIL(31:6)                        98500000
           MOVE 'OPERATION UNKNOWN' TO CA-RESPONSE-MESSAGE              98800000
           EXIT.                                                        99100000
                                                                        99400000
                                                                        99700000