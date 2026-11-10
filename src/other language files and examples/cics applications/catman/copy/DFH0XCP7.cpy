      ***************************************************************** 01000000
      *                                                               * 02000000
      * CONTROL BLOCK NAME = DFH0XCP7                                 * 03000000
      *                                                               * 04000000
      * DESCRIPTIVE NAME = CICS     (Samples) Example Application -   * 05000000
      *                     Copybook for example application          * 06000000
      *                                                               * 07000000
      *  @BANNER_START                           01                   * 07166600
      *  Licensed Materials - Property of IBM                         * 07333200
      *                                                               * 07499800
      *  5655-M15              DFH0XCP7                               * 07666400
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
      *      defines the commarea interface to the order dispatcher   * 14000000
      *      module                                                   * 15000000
      *                                                               * 16000000
      *  CHANGE ACTIVITY :                                            * 17000000
      *       $SEG(DFH0XCP7),COMP(SAMPLES),PROD(CICS    ):            * 18000000
      *                                                               * 19000000
      *   PN= REASON REL YYMMDD HDXXIII : REMARKS                     * 20000000
      *   $D0= I07544 640 041129 HDIPCB  : ExampleApp: Outbound suppor* 21000000
      *                                                               * 22000000
      ***************************************************************** 23000000
      * ++++++++++++++++++++ COMMENTED STRUCTURE +++++++++++++++++++++  24000000
      * Request language structure for operation 'dispatchOrder'        25000000
      *                                                                 26000000
      *    05 dispatchOrderRequest.                                     27000000
      *                                                                 28000000
      * Comments for: itemReferenceNumber                               29000000
      * Soap message location = '/dispatchOrderRequest/itemReferenceNum 30000000
      * ber'                                                            31000000
      * Schema datatype = 'short'                                       32000000
      * whiteSpace='collapse'                                           33000000
      * fractionDigits='0'                                              34000000
      * maxInclusive='9999'                                             35000000
      * minInclusive='0'                                                36000000
      * pattern='((\-+)?(0-9)+)'                                        37000000
      *      10 itemReferenceNumber           PIC 9(4) DISPLAY.         38000000
      *                                                                 39000000
      * Comments for: quantityRequired                                  40000000
      * Soap message location = '/dispatchOrderRequest/quantityRequired 41000000
      * '                                                               42000000
      * Schema datatype = 'short'                                       43000000
      * whiteSpace='collapse'                                           44000000
      * fractionDigits='0'                                              45000000
      * maxInclusive='999'                                              46000000
      * minInclusive='0'                                                47000000
      * pattern='((\-+)?(0-9)+)'                                        48000000
      *      10 quantityRequired              PIC 9(3) DISPLAY.         50000000
      *                                                                 52000000
      * Comments for: customerId                                        54000000
      * Soap message location = '/dispatchOrderRequest/customerId'      56000000
      * Schema datatype = 'string'                                      58000000
      * whiteSpace='preserve'                                           60000000
      * length='8'                                                      62000000
      *      10 customerId                    PIC X(8).                 64000000
      *                                                                 66000000
      * Comments for: chargeDepartment                                  68000000
      * Soap message location = '/dispatchOrderRequest/chargeDepartment 70000000
      * '                                                               72000000
      * Schema datatype = 'string'                                      74000000
      * whiteSpace='preserve'                                           76000000
      * length='8'                                                      78000000
      *      10 chargeDepartment              PIC X(8).                 80000000
      *                                                                 82000000
      *                                                                 84000000
      * ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++  86000000
           05 dispatchOrderRequest.                                     88000000
             10 itemReferenceNumber           PIC 9(4) DISPLAY.         90000000
             10 quantityRequired              PIC 9(3) DISPLAY.         92000000
             10 customerId                    PIC X(8).                 94000000
             10 chargeDepartment              PIC X(8).                 96000000