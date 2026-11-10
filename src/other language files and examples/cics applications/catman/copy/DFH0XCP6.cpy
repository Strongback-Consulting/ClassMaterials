      ***************************************************************** 03000000
      *                                                               * 06000000
      * CONTROL BLOCK NAME = DFH0XCP6                                 * 09000000
      *                                                               * 12000000
      * DESCRIPTIVE NAME = CICS     (Samples) Example Application -   * 15000000
      *                     Copybook for example application          * 18000000
      *                                                               * 21000000
      *  @BANNER_START                           01                   * 21500000
      *  Licensed Materials - Property of IBM                         * 22000000
      *                                                               * 22500000
      *  5655-M15              DFH0XCP6                               * 23000000
      *                                                               * 23500000
      *  (C) Copyright IBM Corp. 2004                                 * 24000000
      *                                                               * 24500000
      *  CICS                                                         * 25000000
      *  (Element of CICS Transaction Server                          * 25500000
      *  for z/OS, Version 3 Release 1)                               * 26000000
      *  @BANNER_END                                                  * 26500000
      *                                                               * 27000000
      * STATUS = 6.4.0                                                * 30000000
      *                                                               * 33000000
      * FUNCTION =                                                    * 36000000
      *      This copy book is part of the example application and    * 39000000
      *      defines the commarea interface to the order dispatcher   * 42000000
      *      module                                                   * 45000000
      *                                                               * 48000000
      *  CHANGE ACTIVITY :                                            * 51000000
      *       $SEG(DFH0XCP6),COMP(SAMPLES),PROD(CICS    ):            * 54000000
      *                                                               * 57000000
      *   PN= REASON REL YYMMDD HDXXIII : REMARKS                     * 60000000
      *   $D0= I07544 640 041129 HDIPCB  : ExampleApp: Outbound suppor* 63000000
      *                                                               * 66000000
      ***************************************************************** 69000000
      *    Dispatcher/Stock Manager COMMAREA structure                  72000000
           03 CA-ORD-REQUEST-ID                PIC X(6).                75000000
           03 CA-ORD-RETURN-CODE               PIC 9(2).                78000000
           03 CA-ORD-RESPONSE-MESSAGE          PIC X(79).               81000000
           03 CA-DISPATCH-ORDER.                                        84000000
               05 CA-ORD-ITEM-REF-NUMBER       PIC 9(4).                87000000
               05 CA-ORD-QUANTITY-REQ          PIC 9(3).                90000000
               05 CA-ORD-USERID                PIC X(8).                93000000
               05 CA-ORD-CHARGE-DEPT           PIC X(8).                96000000