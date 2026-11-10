       CBL CICS('COBOL3') APOST                                         00700000
      ******************************************************************01400000
      *                                                                *02100000
      * MODULE NAME = DFH0XWOD                                         *02800000
      *                                                                *03500000
      * DESCRIPTIVE NAME = CICS     (Samples) Example Application -    *04200000
      *                          Outbound web service order Dispatcher *04900000
      *                                                                *05600000
      *  @BANNER_START                           01                    *05716600
      *  Licensed Materials - Property of IBM                          *05833200
      *                                                                *05949800
      *  5655-M15              DFH0XWOD                                *06066400
      *                                                                *06183000
      *  (C) Copyright IBM Corp. 2004, 2005                            *06299600
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
      *      This program is a version of the order dispatcher that    *11200000
      *      makes an outbound web service call to an order dispatcher *11900000
      *                                                                *12600000
      *----------------------------------------------------------------*13300000
      *                                                                *14000000
      * ENTRY POINT = DFH0XWOD                                         *14700000
      *                                                                *15400000
      *----------------------------------------------------------------*16100000
      *                                                                *16800000
      * CHANGE ACTIVITY :                                              *17500000
      *                                                                *18200000
      *      $MOD(DFH0XWOD),COMP(SAMPLES),PROD(CICS    ):              *18900000
      *                                                                *19600000
      *   PN= REASON REL YYMMDD HDXXIII : REMARKS                      *20300000
      *  $D0= I07544 640 041129 HDIPCB  : ExampleApp: Outbound support *20600000
      *  $D1= I07544 640 050204 HDIPCB  : Example App - fix config pane*20800000
      *   $D0= I07544 640 040910 HDIPCB  : EXAMPLE - BASE APPLICATION  *21000000
      *                                                                *21700000
      ******************************************************************22400000
       IDENTIFICATION DIVISION.                                         23100000
       PROGRAM-ID. DFH0XWOD.                                            23800000
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
                                        VALUE 'DFH0XWOD------WS'.       31500000
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
           03 FILLER                   PIC X(9)  VALUE ' DFH0XWOD'.     42700000
           03 EM-DETAIL                PIC X(50) VALUE SPACES.          43400000
      * Key into the configurations file                                43420000
       01 APP-CONFIG-CONSTANTS.                                         43440000
           03 APP-CONFIG-FILE-NAME     PIC X(8)  VALUE 'EXMPCONF'.      43470000
           03 APP-CONFIG-URL-KEY       PIC X(9)  VALUE 'OUTBNDURL'.     43500000
                                                                        43530000
      * URL Record Structure                                            43560000
       01 URL-RECORD-STRUCTURE.                                         43590000
           03 FILLER                   PIC X(10).                       43620000
           03 WS-ENDPOINT-URI          PIC X(255).                      43650000
                                                                        43680000
      * Working Variables                                               43710000
       01 WORKING-VARIABLES.                                            43740000
           03 WS-WEBSERVICE-NAME       PIC X(32).                       43770000
           03 WS-OPERATION             PIC X(255).                      43800000
           03 WS-SERVICE-CONT-NAME     PIC X(16).                       43830000
           03 WS-CHANNELNAME           PIC X(16).                       43860000
           03 RESP                     PIC S9(8) COMP.                  43890000
           03 RESP2                    PIC S9(8) COMP.                  43920000
                                                                        43950000
      * WebService Message Structures                                   43980000
       01 WS-DISPATCH-ORDER-MESSAGES.                                   44010000
           COPY DFH0XCP7.                                               44040000
           COPY DFH0XCP8.                                               44070000
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
           INITIALIZE URL-RECORD-STRUCTURE                              59600000
           INITIALIZE WS-DISPATCH-ORDER-MESSAGES                        59800000
           INITIALIZE WORKING-VARIABLES                                 60000000
                                                                        60200000
      * set up general variable                                         60900000
           MOVE EIBTRNID TO WS-TRANSID.                                 61600000
           MOVE EIBTRMID TO WS-TERMID.                                  62300000
           MOVE EIBTASKN TO WS-TASKNUM.                                 63000000
                                                                        63700000
      *---------------------------------------------------------------* 64400000
      * Check commarea and obtain required details                    * 65100000
      *---------------------------------------------------------------* 65800000
      * If NO commarea received issue an ABEND                          66500000
           IF EIBCALEN IS EQUAL TO ZERO                                 67200000
               MOVE ' NO COMMAREA RECEIVED' TO EM-DETAIL                67900000
               PERFORM WRITE-ERROR-MESSAGE                              68600000
               EXEC CICS ABEND ABCODE('EXCA') NODUMP END-EXEC           69300000
           END-IF                                                       70000000
                                                                        70300000
      * Initialize commarea return code to zero and reset the response  70700000
           MOVE '00' TO CA-ORD-RETURN-CODE                              71400000
           MOVE SPACES TO CA-ORD-RESPONSE-MESSAGE                       72100000
      *---------------------------------------------------------------* 72800000
      * Read in the config file to get the url to call for the external 73500000
      * dispatcher service. Store URL in WS-ENDPOINT-URI.               73510000
      *---------------------------------------------------------------* 73520000
           EXEC CICS READ FILE(APP-CONFIG-FILE-NAME)                    73530000
                          RIDFLD(APP-CONFIG-URL-KEY)                    73540000
                          INTO(URL-RECORD-STRUCTURE)                    73550000
                          RESP(RESP)                                    73560000
           END-EXEC                                                     73570000
                                                                        73580000
      * Ensure that the file read was sucessful. We cannot continue if  73590000
      * we dont know what url the service it located at                 73600000
           IF RESP NOT EQUAL DFHRESP(NORMAL)                            73610000
               MOVE '51' TO CA-ORD-RETURN-CODE                          73620000
               MOVE 'APPLICATION ERROR OPENING CONFIGURATION FILE'      73630000
                   TO CA-ORD-RESPONSE-MESSAGE                           73640000
               EXEC CICS RETURN END-EXEC                                73650000
           END-IF                                                       73660000
                                                                        73670000
      *---------------------------------------------------------------* 73680000
      * Set up the data for the web service call                        73690000
      *---------------------------------------------------------------* 73700000
      *    'DFHWS-DATA' is the name of the container that will store    73710000
      *    the data to make the webservice request                      73720000
           MOVE 'DFHWS-DATA' TO WS-SERVICE-CONT-NAME                    73730000
                                                                        73740000
      *    'SERVICE-CHANNEL' is the name of the channel we will pass to 73750000
      *    the web service call                                         73760000
           MOVE 'SERVICE-CHANNEL' TO WS-CHANNELNAME                     73770000
                                                                        73780000
      *    'dispatchOrder' is the name of the WEBSERVICE resource       73790000
      *    installed in this CICS region                                73800000
           MOVE 'dispatchOrder' TO WS-WEBSERVICE-NAME                   73810000
                                                                        73820000
      *    'dispatchOrder' is the name of the operation we are going to 73830000
      *    invoke on the remote service                                 73840000
           MOVE 'dispatchOrder' TO WS-OPERATION                         73850000
                                                                        73860000
      *    Move the data from the input commarea to the                 73870000
      *    'dispatchOrderRequest' variable ready to put in a container  73880000
           MOVE CA-ORD-ITEM-REF-NUMBER                                  73890000
               TO itemReferenceNumber IN dispatchOrderRequest           73900000
           MOVE CA-ORD-QUANTITY-REQ                                     73920000
               TO quantityRequired IN dispatchOrderRequest              73940000
           MOVE CA-ORD-USERID                                           73960000
               TO customerId IN dispatchOrderRequest                    73980000
           MOVE CA-ORD-CHARGE-DEPT                                      74000000
               TO chargeDepartment IN dispatchOrderRequest              74020000
                                                                        74040000
      *---------------------------------------------------------------* 74060000
      * Place the request data into a container on a channel            74080000
      *---------------------------------------------------------------* 74100000
           EXEC CICS PUT CONTAINER(WS-SERVICE-CONT-NAME)                74120000
                         CHANNEL(WS-CHANNELNAME)                        74140000
                         FROM(dispatchOrderRequest)                     74160000
           END-EXEC                                                     74180000
                                                                        74200000
      *---------------------------------------------------------------* 74220000
      * Make the Invoke call                                            74240000
      *---------------------------------------------------------------* 74260000
                                                                        74280000
           EXEC CICS INVOKE WEBSERVICE(WS-WEBSERVICE-NAME)              74300000
                     CHANNEL(WS-CHANNELNAME)                            74320000
                     URI(WS-ENDPOINT-URI)                               74340000
                     OPERATION(WS-OPERATION)                            74360000
                     RESP(RESP) RESP2(RESP2)                            74380000
           END-EXEC.                                                    74400000
                                                                        74420000
      * Check the return code was normal                                74440000
                                                                        74460000
           EVALUATE RESP                                                74480000
               WHEN DFHRESP(NORMAL)                                     74500000
                   EXEC CICS GET CONTAINER(WS-SERVICE-CONT-NAME)        74520000
                             CHANNEL(WS-CHANNELNAME)                    74540000
                             INTO(CA-ORD-RESPONSE-MESSAGE)              74560000
                   END-EXEC                                             74580000
                                                                        74600000
               WHEN DFHRESP(INVREQ)                                     74620000
                   MOVE 'Error calling dispatch service - INVREQ'       74640000
                       TO CA-ORD-RESPONSE-MESSAGE                       74660000
                   MOVE 30 TO CA-ORD-RETURN-CODE                        74680000
                                                                        74700000
               WHEN DFHRESP(NOTFND)                                     74720000
                   MOVE 'Error calling dispatch service - NOT FOUND'    74740000
                       TO CA-ORD-RESPONSE-MESSAGE                       74760000
                   MOVE 31 TO CA-ORD-RETURN-CODE                        74780000
                                                                        74800000
               WHEN OTHER                                               74820000
                   MOVE 'Error calling dispatch service'                74840000
                       TO CA-ORD-RESPONSE-MESSAGE                       74860000
                   MOVE 32 TO CA-ORD-RETURN-CODE                        74880000
           END-EVALUATE.                                                74900000
                                                                        77000000
      * Return to caller                                                77700000
           EXEC CICS RETURN END-EXEC.                                   78400000
                                                                        79200000
       MAINLINE-EXIT.                                                   80000000
           EXIT.                                                        80800000
      *----------------------------------------------------------------*81600000
                                                                        82400000
      *================================================================*83200000
      * Procedure to write error message to TD QUEUE(CSMT)             *84000000
      *   message will include Date, Time, Program Name,               *84800000
      *   and error details.                                           *85600000
      *================================================================*86400000
       WRITE-ERROR-MESSAGE.                                             87200000
      * Obtain and format current time and date                         88000000
           EXEC CICS ASKTIME ABSTIME(ABS-TIME)                          88800000
           END-EXEC                                                     89600000
           EXEC CICS FORMATTIME ABSTIME(ABS-TIME)                       90400000
                     MMDDYYYY(DATE1)                                    91200000
                     TIME(TIME1)                                        92000000
           END-EXEC                                                     92800000
           MOVE DATE1 TO EM-DATE                                        93600000
           MOVE TIME1 TO EM-TIME                                        94400000
      * Write output message to TDQ                                     95200000
           EXEC CICS WRITEQ TD QUEUE('CSMT')                            96000000
                     FROM(ERROR-MSG)                                    96800000
                     LENGTH(LENGTH OF ERROR-MSG)                        97600000
           END-EXEC.                                                    98400000
           EXIT.                                                        99200000