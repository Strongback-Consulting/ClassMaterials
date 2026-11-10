      ******************************************************************02000000
      *                                                                *04000000
      * CONTROL BLOCK NAME = DFH0XCP5                                  *06000000
      *                                                                *08000000
      * DESCRIPTIVE NAME = CICS     (Samples) Example Application -    *10000000
      *                     Main copybook for example application      *12000000
      *                                                                *14000000
      *  @BANNER_START                           01                    *14333300
      *  Licensed Materials - Property of IBM                          *14666600
      *                                                                *14999900
      *  5655-M15              DFH0XCP5                                *15333200
      *                                                                *15666500
      *  (C) Copyright IBM Corp. 2004                                  *15999800
      *                                                                *16333100
      *  CICS                                                          *16666400
      *  (Element of CICS Transaction Server                           *16999700
      *  for z/OS, Version 3 Release 1)                                *17333000
      *  @BANNER_END                                                   *17666300
      *                                                                *18000000
      * STATUS = 6.4.0                                                 *20000000
      *                                                                *22000000
      * FUNCTION =                                                     *24000000
      *      This copy book is part of the example application and     *26000000
      *      defines the datastructure for to place an order for a     *28000000
      *      catalog item. It is the same as the structure defined     *31000000
      *      DFH0XCP1 but without the redefines                        *34000000
      *----------------------------------------------------------------*37000000
      *                                                                *40000000
      * CHANGE ACTIVITY :                                              *43000000
      *      $SEG(DFH0XCP5),COMP(SAMPLES),PROD(CICS    ):              *46000000
      *                                                                *49000000
      *   PN= REASON REL YYMMDD HDXXIII : REMARKS                      *52000000
      *   $D0= I07544 640 040910 HDIPCB  : EXAMPLE - BASE APPLICATION  *55000000
      *                                                                *58000000
      ******************************************************************61000000
                                                                        64000000
      *    Catalogue COMMAREA structure                                 67000000
           03 CA-REQUEST-ID            PIC X(6).                        70000000
           03 CA-RETURN-CODE           PIC 9(2) DISPLAY.                73000000
           03 CA-RESPONSE-MESSAGE      PIC X(79).                       76000000
      *    Fields used in Place Order                                   79000000
           03 CA-ORDER-REQUEST.                                         82000000
               05 CA-USERID                PIC X(8).                    85000000
               05 CA-CHARGE-DEPT           PIC X(8).                    88000000
               05 CA-ITEM-REF-NUMBER       PIC 9(4) DISPLAY.            91000000
               05 CA-QUANTITY-REQ          PIC 9(3) DISPLAY.            94000000
               05 FILLER                   PIC X(888).                  97000000