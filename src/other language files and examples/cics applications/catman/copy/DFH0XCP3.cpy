      ******************************************************************02000000
      *                                                                *04000000
      * CONTROL BLOCK NAME = DFH0XCP3                                  *06000000
      *                                                                *08000000
      * DESCRIPTIVE NAME = CICS     (Samples) Example Application -    *10000000
      *                     Main copybook for example application      *12000000
      *                                                                *14000000
      *  @BANNER_START                           01                    *14333300
      *  Licensed Materials - Property of IBM                          *14666600
      *                                                                *14999900
      *  5655-M15              DFH0XCP3                                *15333200
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
      *      defines the datastructure for an inquire list for the     *28000000
      *      catalogitems. It is the same as the structure defined     *30000000
      *      DFH0XCP1 but without the redefines                        *32000000
      *----------------------------------------------------------------*34000000
      *                                                                *36000000
      * CHANGE ACTIVITY :                                              *38000000
      *      $SEG(DFH0XCP3),COMP(SAMPLES),PROD(CICS    ):              *40000000
      *                                                                *42000000
      *   PN= REASON REL YYMMDD HDXXIII : REMARKS                      *44000000
      *   $D0= I07544 640 040910 HDIPCB  : EXAMPLE - BASE APPLICATION  *46000000
      *                                                                *48000000
      ******************************************************************50000000
      *    Catalogue COMMAREA structure                                 52000000
           03 CA-REQUEST-ID            PIC X(6).                        54000000
           03 CA-RETURN-CODE           PIC 9(2) DISPLAY.                56000000
           03 CA-RESPONSE-MESSAGE      PIC X(79).                       58000000
      *    Fields used in Inquire Catalog                               61000000
           03 CA-INQUIRE-REQUEST.                                       64000000
               05 CA-LIST-START-REF        PIC 9(4) DISPLAY.            67000000
               05 CA-LAST-ITEM-REF         PIC 9(4) DISPLAY.            70000000
               05 CA-ITEM-COUNT            PIC 9(3) DISPLAY.            73000000
               05 CA-CAT-ITEM OCCURS 15.                                76000000
                   07 CA-ITEM-REF          PIC 9(4) DISPLAY.            79000000
                   07 CA-DESCRIPTION       PIC X(40).                   82000000
                   07 CA-DEPARTMENT        PIC 9(3) DISPLAY.            85000000
                   07 CA-COST              PIC X(6).                    88000000
                   07 IN-STOCK             PIC 9(4) DISPLAY.            91000000
                   07 ON-ORDER             PIC 9(3) DISPLAY.            94000000
                                                                        97000000