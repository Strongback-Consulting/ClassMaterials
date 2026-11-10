      ******************************************************************01000000
      *                                                                *02000000
      * CONTROL BLOCK NAME = DFH0XM2U                                  *03000000
      *                                                                *04000000
      * DESCRIPTIVE NAME = CICS     (Samples) Example Application -    *05000000
      *                     Copybook for BMS mapsets for inquire list  *06000000
      *                                                                *07000000
      *  @BANNER_START                           01                    *07166600
      *  Licensed Materials - Property of IBM                          *07333200
      *                                                                *07499800
      *  5655-M15              DFH0XM2U                                *07666400
      *                                                                *07833000
      *  (C) Copyright IBM Corp. 2004                                  *07999600
      *                                                                *08166200
      *  CICS                                                          *08332800
      *  (Element of CICS Transaction Server                           *08499400
      *  for z/OS, Version 3 Release 1)                                *08666000
      *  @BANNER_END                                                   *08832600
      *                                                                *09000000
      * STATUS = 6.4.0                                                 *10000000
      *                                                                *11000000
      * FUNCTION =                                                     *12000000
      *      This copy book is part of the example application &       *13000000
      *      defines the data passed to & from the BMS mapsets for the *14000000
      *      inquire list panel. It has *been edited from the generated*15000000
      *      to include an indexed array structure for ease of         *16000000
      *      copybook programming                                      *17000000
      *                                                                *18000000
      *----------------------------------------------------------------*19000000
      *                                                                *20000000
      * CHANGE ACTIVITY :                                              *21000000
      *      $SEG(DFH0XM2U),COMP(SAMPLES),PROD(CICS    ):              *22000000
      *                                                                *23000000
      *   PN= REASON REL YYMMDD HDXXIII : REMARKS                      *24000000
      *   $D0= I07544 640 040910 HDIPCB  : EXAMPLE - BASE APPLICATION  *25000000
      *                                                                *26000000
      ******************************************************************27000000
                                                                        28000000
      * Custom CopyBook for Example Inquire BMS Map                     29000000
       01  EXINQCI.                                                     30000000
           03 FILLER PIC X(12).                                         31000000
           03 CATALOG-ITEM-IN OCCURS 15 TIMES.                          32000000
               05 INQ-ITEMREFL    COMP  PIC  S9(4).                     33000000
               05 INQ-ITEMREFF    PICTURE X.                            34000000
               05 FILLER REDEFINES INQ-ITEMREFF.                        35000000
                   09 INQ-ITEMREFA    PICTURE X.                        36000000
               05 FILLER   PICTURE X(2).                                37000000
               05 INQ-ITEMREFI  PIC X(4).                               38000000
               05 INQ-DESCL    COMP  PIC  S9(4).                        39000000
               05 INQ-DESCF    PICTURE X.                               40000000
               05 FILLER REDEFINES INQ-DESCF.                           41000000
                   09 INQ-DESCA    PICTURE X.                           42000000
               05 FILLER   PICTURE X(2).                                43000000
               05 INQ-DESCI  PIC X(40).                                 44000000
               05 INQ-COSTL    COMP  PIC  S9(4).                        45000000
               05 INQ-COSTF    PICTURE X.                               46000000
               05 FILLER REDEFINES INQ-COSTF.                           47000000
                   09 INQ-COSTA    PICTURE X.                           48000000
               05 FILLER   PICTURE X(2).                                49000000
               05 INQ-COSTI  PIC X(6).                                  50000000
               05 INQ-ORDL    COMP  PIC  S9(4).                         51000000
               05 INQ-ORDF    PICTURE X.                                52000000
               05 FILLER REDEFINES INQ-ORDF.                            53000000
                   09 INQ-ORDA    PICTURE X.                            54000000
               05 FILLER   PICTURE X(2).                                55000000
               05 INQ-ORDI  PIC X(1).                                   56000000
                                                                        57000000
           03 INQC-MSGL    COMP  PIC  S9(4).                            58000000
           03 INQC-MSGF    PICTURE X.                                   59000000
           03 FILLER REDEFINES INQC-MSGF.                               60000000
               05 INQC-MSGA    PICTURE X.                               61000000
           03 FILLER   PICTURE X(2).                                    62000000
           03 INQC-MSGI  PIC X(79).                                     63000000
       01  EXINQCO REDEFINES EXINQCI.                                   64000000
           03  FILLER PIC X(12).                                        65000000
           03  CATALOG-ITEM-OUT OCCURS 15 TIMES.                        66000000
               05  FILLER PICTURE X(3).                                 67000000
               05  INQ-ITEMREFC    PICTURE X.                           68000000
               05  INQ-ITEMREFH    PICTURE X.                           69000000
               05  INQ-ITEMREFO  PIC X(4).                              70000000
               05  FILLER PICTURE X(3).                                 71000000
               05  INQ-DESCC    PICTURE X.                              72000000
               05  INQ-DESCH    PICTURE X.                              73000000
               05  INQ-DESCO  PIC X(40).                                74000000
               05  FILLER PICTURE X(3).                                 75000000
               05  INQ-COSTC    PICTURE X.                              76000000
               05  INQ-COSTH    PICTURE X.                              78000000
               05  INQ-COSTO PIC X(6).                                  80000000
               05  FILLER PICTURE X(3).                                 82000000
               05  INQ-ORDC    PICTURE X.                               84000000
               05  INQ-ORDH    PICTURE X.                               86000000
               05  INQ-ORDO  PIC X(1).                                  88000000
           03  FILLER PICTURE X(3).                                     90000000
           03  INQC-MSGC    PICTURE X.                                  92000000
           03  INQC-MSGH    PICTURE X.                                  94000000
           03  INQC-MSGO  PIC X(79).                                    96000000
                                                                        98000000