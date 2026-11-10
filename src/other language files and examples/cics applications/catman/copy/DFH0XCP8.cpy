      ***************************************************************** 00500000
      *                                                               * 01000000
      * CONTROL BLOCK NAME = DFH0XCP8                                 * 01500000
      *                                                               * 02000000
      * DESCRIPTIVE NAME = CICS     (Samples) Example Application -   * 02500000
      *                     Copybook for example application          * 03000000
      *                                                               * 03500000
      *  @BANNER_START                           01                   * 03583300
      *  Licensed Materials - Property of IBM                         * 03666600
      *                                                               * 03749900
      *  5655-M15              DFH0XCP8                               * 03833200
      *                                                               * 03916500
      *  (C) Copyright IBM Corp. 2004                                 * 03999800
      *                                                               * 04083100
      *  CICS                                                         * 04166400
      *  (Element of CICS Transaction Server                          * 04249700
      *  for z/OS, Version 3 Release 1)                               * 04333000
      *  @BANNER_END                                                  * 04416300
      *                                                               * 04500000
      * STATUS = 6.4.0                                                * 05000000
      *                                                               * 05500000
      * FUNCTION =                                                    * 06000000
      *      This copy book is part of the example application and    * 06500000
      *      defines the commarea interface to the order dispatcher   * 07000000
      *      module                                                   * 07500000
      *                                                               * 08000000
      *  CHANGE ACTIVITY :                                            * 08500000
      *       $SEG(DFH0XCP8),COMP(SAMPLES),PROD(CICS    ):            * 09000000
      *                                                               * 09500000
      *   PN= REASON REL YYMMDD HDXXIII : REMARKS                     * 10000000
      *   $D0= I07544 640 041129 HDIPCB  : ExampleApp: Outbound suppor* 10500000
      *                                                               * 11000000
      ***************************************************************** 11500000
      * ++++++++++++++++++++ COMMENTED STRUCTURE +++++++++++++++++++++  12000000
      * Response language structure for operation 'dispatchOrder'       12500000
      *                                                                 13000000
      *    05 dispatchOrderResponse.                                    13500000
      *                                                                 14000000
      * Comments for: confirmation                                      14500000
      * Soap message location = '/dispatchOrderResponse/confirmation'   15000000
      * Schema datatype = 'string'                                      15500000
      * whiteSpace='preserve'                                           16000000
      * length='20'                                                     16500000
      *      10 confirmation                  PIC X(20).                17000000
      *                                                                 17500000
      *                                                                 18000000
      * ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++  18500000
           05 dispatchOrderResponse.                                    19000000
             10 confirmation                  PIC X(20).                19500000