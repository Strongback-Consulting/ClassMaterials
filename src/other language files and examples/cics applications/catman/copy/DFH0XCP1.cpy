      ***************************************************************** 01000000
      *                                                               * 02000000
      * CONTROL BLOCK NAME = DFH0XCP1                                 * 03000000
      *                                                               * 04000000
      * DESCRIPTIVE NAME = CICS     (Samples) Example Application -   * 05000000
      *                     Main copybook for example application     * 06000000
      *                                                               * 07000000
      *  @BANNER_START                           01                   * 07166600
      *  Licensed Materials - Property of IBM                         * 07333200
      *                                                               * 07499800
      *  5655-M15              DFH0XCP1                               * 07666400
      *                                                               * 07833000
      *  (C) Copyright IBM Corp. 2004                                 * 07999600
      *                                                               * 08166200
      *  CICS                                                         * 08332800
      *  (Element of CICS Transaction Server                          * 08499400
      *  for z/OS, Version 3 Release 1)                               * 08666000
      *  @BANNER_END                                                  * 08832600
      *                                                               * 09000000
      * STATUS = 6.4.0                                                * 10000000
      *                                                               * 11000000
      * FUNCTION =                                                    * 12000000
      *      This copy book is part of the example application and    * 13000000
      *      defines the commarea interface to the catalog manager    * 14000000
      *      module and the datastore modules                         * 15000000
      *                                                               * 16000000
      *      The fields are as follows                                * 17000000
      *                                                               * 18000000
      *        CA-REQUEST-ID            Identifies function           * 19000000
      *        CA-RETURN-CODE           Return Code                   * 20000000
      *        CA-RESPONSE-MESSAGE      Response message              * 21000000
      *        CA-REQUEST-SPECIFIC      Redefined for inquire/order   * 22000000
      *                                                               * 23000000
      *        CA-INQUIRE-REQUEST       Group for inquire of 15 items * 24000000
      *          CA-LIST-START-REF      Reference to start list from  * 25000000
      *          CA-LAST-ITEM-REF       Last item returned            * 26000000
      *          CA-ITEM-COUNT          Number of items returned      * 27000000
      *          CA-CAT-ITEM            Catalog item                  * 28000000
      *              CA-ITEM-REF        Item reference number         * 29000000
      *              CA-DESCRIPTION     Short description             * 30000000
      *              CA-DEPARTMENT      Department item belongs to    * 31000000
      *              CA-COST            Cost of item                  * 32000000
      *              IN-STOCK           Number of items in stock      * 33000000
      *              ON-ORDER           Number of items on order      * 34000000
      *                                                               * 35000000
      *        CA-INQUIRE-SINGLE        Structure for inquire single  * 36000000
      *          CA-ITEM-REF-REQ        Reference number of item      * 37000000
      *          CA-SINGLE-ITEM.                                      * 38000000
      *            CA-SNGL-ITEM-REF     Item reference number returned* 39000000
      *            CA-SNGL-DESCRIPTION  Short description             * 40000000
      *            CA-SNGL-DEPARTMENT   Department item belongs to    * 41000000
      *            CA-SNGL-COST         Cost of item                  * 42000000
      *            IN-SNGL-STOCK        Number of items in stock      * 43000000
      *            ON-SNGL-ORDER        Number of items on order      * 44000000
      *                                                               * 45000000
      *        CA-ORDER-REQUEST         Structure for placing an order* 46000000
      *          CA-USERID              User name placing the order   * 47000000
      *          CA-CHARGE-DEPT         Department user belongs to    * 48000000
      *          CA-ITEM-REF-NUMBER     Item reference to be ordered  * 49000000
      *          CA-QUANTITY-REQ        Quantity of item required     * 50000000
      *                                                               * 51000000
      *---------------------------------------------------------------* 52000000
      *                                                               * 53000000
      * CHANGE ACTIVITY :                                             * 54000000
      *      $SEG(DFH0XCP1),COMP(SAMPLES),PROD(CICS    ):             * 55000000
      *                                                               * 56000000
      *   PN= REASON REL YYMMDD HDXXIII : REMARKS                     * 57000000
      *   $D0= I07544 640 040910 HDIPCB  : EXAMPLE - BASE APPLICATION * 58000000
      *                                                               * 59000000
      ***************************************************************** 60000000
      *    Catalogue COMMAREA structure                                 61000000
           03 CA-REQUEST-ID            PIC X(6).                        62000000
           03 CA-RETURN-CODE           PIC 9(2).                        63000000
           03 CA-RESPONSE-MESSAGE      PIC X(79).                       64000000
           03 CA-REQUEST-SPECIFIC      PIC X(911).                      65000000
      *    Fields used in Inquire Catalog                               66000000
           03 CA-INQUIRE-REQUEST REDEFINES CA-REQUEST-SPECIFIC.         67000000
               05 CA-LIST-START-REF        PIC 9(4).                    68000000
               05 CA-LAST-ITEM-REF         PIC 9(4).                    69000000
               05 CA-ITEM-COUNT            PIC 9(3).                    70000000
               05 CA-INQUIRY-RESPONSE-DATA PIC X(900).                  71000000
               05 CA-CAT-ITEM  REDEFINES CA-INQUIRY-RESPONSE-DATA       72000000
                               OCCURS 15 TIMES.                         73000000
                   07 CA-ITEM-REF          PIC 9(4).                    74000000
                   07 CA-DESCRIPTION       PIC X(40).                   75000000
                   07 CA-DEPARTMENT        PIC 9(3).                    76000000
                   07 CA-COST              PIC X(6).                    77000000
                   07 IN-STOCK             PIC 9(4).                    78000000
                   07 ON-ORDER             PIC 9(3).                    79000000
      *    Fields used in Inquire Single                                80000000
           03 CA-INQUIRE-SINGLE REDEFINES CA-REQUEST-SPECIFIC.          81000000
               05 CA-ITEM-REF-REQ          PIC 9(4).                    82000000
               05 FILLER                   PIC 9(4).                    83000000
               05 FILLER                   PIC 9(3).                    84000000
               05 CA-SINGLE-ITEM.                                       85000000
                   07 CA-SNGL-ITEM-REF     PIC 9(4).                    86000000
                   07 CA-SNGL-DESCRIPTION  PIC X(40).                   87000000
                   07 CA-SNGL-DEPARTMENT   PIC 9(3).                    88000000
                   07 CA-SNGL-COST         PIC X(6).                    89000000
                   07 IN-SNGL-STOCK        PIC 9(4).                    90000000
                   07 ON-SNGL-ORDER        PIC 9(3).                    91000000
               05 FILLER                   PIC X(840).                  92000000
      *    Fields used in Place Order                                   93000000
           03 CA-ORDER-REQUEST REDEFINES CA-REQUEST-SPECIFIC.           94000000
               05 CA-USERID                PIC X(8).                    95000000
               05 CA-CHARGE-DEPT           PIC X(8).                    96000000
               05 CA-ITEM-REF-NUMBER       PIC 9(4).                    97000000
               05 CA-QUANTITY-REQ          PIC 9(3).                    98000000
               05 FILLER                   PIC X(888).                  99000000