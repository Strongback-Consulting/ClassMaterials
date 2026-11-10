      ******************************************************************02000000
      *                                                                *04000000
      * CONTROL BLOCK NAME = DFH0XCP2                                  *06000000
      *                                                                *08000000
      * DESCRIPTIVE NAME = CICS     (Samples) Example Application -    *10000000
      *                     Copybook for order dispatcher and stock    *12000000
      *                     manager commarea structures                *14000000
      *                                                                *16000000
      *  @BANNER_START                           01                    *16333300
      *  Licensed Materials - Property of IBM                          *16666600
      *                                                                *16999900
      *  5655-M15              DFH0XCP2                                *17333200
      *                                                                *17666500
      *  (C) Copyright IBM Corp. 2004                                  *17999800
      *                                                                *18333100
      *  CICS                                                          *18666400
      *  (Element of CICS Transaction Server                           *18999700
      *  for z/OS, Version 3 Release 1)                                *19333000
      *  @BANNER_END                                                   *19666300
      *                                                                *20000000
      * STATUS = 6.4.0                                                 *22000000
      *                                                                *24000000
      * FUNCTION =                                                     *26000000
      *      This copy book is part of the example application and     *28000000
      *      defines the datastructure for the order dispatcher and    *30000000
      *      stock manager modules                                     *32000000
      *----------------------------------------------------------------*34000000
      *                                                                *36000000
      * CHANGE ACTIVITY :                                              *38000000
      *      $SEG(DFH0XCP2),COMP(SAMPLES),PROD(CICS    ):              *40000000
      *                                                                *42000000
      *   PN= REASON REL YYMMDD HDXXIII : REMARKS                      *44000000
      *   $D0= I07544 640 040910 HDIPCB  : EXAMPLE - BASE APPLICATION  *46000000
      *                                                                *48000000
      ******************************************************************50000000
      *    Dispatcher/Stock Manager COMMAREA structure                  52000000
           03 CA-ORD-REQUEST-ID                PIC X(6).                54000000
           03 CA-ORD-RETURN-CODE               PIC 9(2).                56000000
           03 CA-ORD-RESPONSE-MESSAGE          PIC X(79).               58000000
           03 CA-ORD-REQUEST-SPECIFIC          PIC X(23).               61000000
      *    Fields used in Dispatcher                                    64000000
           03 CA-DISPATCH-ORDER REDEFINES CA-ORD-REQUEST-SPECIFIC.      67000000
               05 CA-ORD-ITEM-REF-NUMBER       PIC 9(4).                70000000
               05 CA-ORD-QUANTITY-REQ          PIC 9(3).                73000000
               05 CA-ORD-USERID                PIC X(8).                76000000
               05 CA-ORD-CHARGE-DEPT           PIC X(8).                79000000
      *    Fields used in Stock Manager                                 82000000
           03 CA-STOCK-MANAGER-UPDATE REDEFINES CA-ORD-REQUEST-SPECIFIC.85000000
               05 CA-STK-ITEM-REF-NUMBER       PIC 9(4).                88000000
               05 CA-STK-QUANTITY-REQ          PIC 9(3).                91000000
               05 FILLER                       PIC X(16).               94000000
                                                                        97000000