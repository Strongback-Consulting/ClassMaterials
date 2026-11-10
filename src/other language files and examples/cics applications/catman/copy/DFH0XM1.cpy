      ******************************************************************00600000
      *                                                                *01200000
      * CONTROL BLOCK NAME = DFH0XM1                                   *01800000
      *                                                                *02400000
      * DESCRIPTIVE NAME = CICS     (Samples) Example Application -    *03000000
      *                     Copybook for BMS mapsets for menu and order*03600000
      *                                                                *04200000
      *  @BANNER_START                           01                    *04300000
      *  Licensed Materials - Property of IBM                          *04400000
      *                                                                *04500000
      *  5655-M15              DFH0XM1                                 *04600000
      *                                                                *04700000
      *  (C) Copyright IBM Corp. 2004                                  *04800000
      *                                                                *04900000
      *  CICS                                                          *05000000
      *  (Element of CICS Transaction Server                           *05100000
      *  for z/OS, Version 3 Release 1)                                *05200000
      *  @BANNER_END                                                   *05300000
      *                                                                *05400000
      * STATUS = 6.4.0                                                 *06000000
      *                                                                *06600000
      * FUNCTION =                                                     *07200000
      *      This copy book is part of the example application and     *07800000
      *      the data passed to and from the BMS mapsets for the main  *08400000
      *      menu and the place order panels                           *09000000
      *                                                                *09600000
      *----------------------------------------------------------------*10200000
      *                                                                *10800000
      * CHANGE ACTIVITY :                                              *11400000
      *      $SEG(DFH0XM1),COMP(SAMPLES),PROD(CICS    ):               *12000000
      *                                                                *12600000
      *   PN= REASON REL YYMMDD HDXXIII : REMARKS                      *13200000
      *   $D0= I07544 640 040910 HDIPCB  : EXAMPLE - BASE APPLICATION  *13800000
      *                                                                *14400000
      ******************************************************************15000000
       01  EXMENUI.                                                     15600000
           02  FILLER PIC X(12).                                        16200000
           02  ACTIONL    COMP  PIC  S9(4).                             16800000
           02  ACTIONF    PICTURE X.                                    17400000
           02  FILLER REDEFINES ACTIONF.                                18000000
             03 ACTIONA    PICTURE X.                                   18600000
           02  FILLER   PICTURE X(2).                                   19200000
           02  ACTIONI  PIC X(1).                                       19800000
           02  ITEM-REFL    COMP  PIC  S9(4).                           20400000
           02  ITEM-REFF    PICTURE X.                                  21000000
           02  FILLER REDEFINES ITEM-REFF.                              21600000
             03 ITEM-REFA    PICTURE X.                                 22200000
           02  FILLER   PICTURE X(2).                                   22800000
           02  ITEM-REFI  PIC X(4).                                     23400000
           02  MSG1L    COMP  PIC  S9(4).                               24000000
           02  MSG1F    PICTURE X.                                      24600000
           02  FILLER REDEFINES MSG1F.                                  25200000
             03 MSG1A    PICTURE X.                                     25800000
           02  FILLER   PICTURE X(2).                                   26400000
           02  MSG1I  PIC X(79).                                        27000000
       01  EXMENUO REDEFINES EXMENUI.                                   27600000
           02  FILLER PIC X(12).                                        28200000
           02  FILLER PICTURE X(3).                                     28800000
           02  ACTIONC    PICTURE X.                                    29400000
           02  ACTIONH    PICTURE X.                                    30000000
           02  ACTIONO  PIC X(1).                                       30600000
           02  FILLER PICTURE X(3).                                     31200000
           02  ITEM-REFC    PICTURE X.                                  31800000
           02  ITEM-REFH    PICTURE X.                                  32400000
           02  ITEM-REFO  PIC X(4).                                     33000000
           02  FILLER PICTURE X(3).                                     33600000
           02  MSG1C    PICTURE X.                                      34200000
           02  MSG1H    PICTURE X.                                      34800000
           02  MSG1O  PIC X(79).                                        35400000
       01  EXORDRI.                                                     36000000
           02  FILLER PIC X(12).                                        36600000
           02  ORDR-ITEMREFL    COMP  PIC  S9(4).                       37200000
           02  ORDR-ITEMREFF    PICTURE X.                              37800000
           02  FILLER REDEFINES ORDR-ITEMREFF.                          38400000
             03 ORDR-ITEMREFA    PICTURE X.                             39000000
           02  FILLER   PICTURE X(2).                                   39600000
           02  ORDR-ITEMREFI  PIC X(4).                                 40200000
           02  ORDR-DESCL    COMP  PIC  S9(4).                          40800000
           02  ORDR-DESCF    PICTURE X.                                 41400000
           02  FILLER REDEFINES ORDR-DESCF.                             42000000
             03 ORDR-DESCA    PICTURE X.                                42600000
           02  FILLER   PICTURE X(2).                                   43200000
           02  ORDR-DESCI  PIC X(40).                                   43800000
           02  ORDR-COSTL    COMP  PIC  S9(4).                          44400000
           02  ORDR-COSTF    PICTURE X.                                 45000000
           02  FILLER REDEFINES ORDR-COSTF.                             45600000
             03 ORDR-COSTA    PICTURE X.                                46200000
           02  FILLER   PICTURE X(2).                                   46800000
           02  ORDR-COSTI  PIC X(6).                                    47500000
           02  ORDR-STKL    COMP  PIC  S9(4).                           48200000
           02  ORDR-STKF    PICTURE X.                                  48900000
           02  FILLER REDEFINES ORDR-STKF.                              49600000
             03 ORDR-STKA    PICTURE X.                                 50300000
           02  FILLER   PICTURE X(2).                                   51000000
           02  ORDR-STKI  PIC X(4).                                     51700000
           02  ORDR-ORDL    COMP  PIC  S9(4).                           52400000
           02  ORDR-ORDF    PICTURE X.                                  53100000
           02  FILLER REDEFINES ORDR-ORDF.                              53800000
             03 ORDR-ORDA    PICTURE X.                                 54500000
           02  FILLER   PICTURE X(2).                                   55200000
           02  ORDR-ORDI  PIC X(3).                                     55900000
           02  ORDR-QUANTITYL    COMP  PIC  S9(4).                      56600000
           02  ORDR-QUANTITYF    PICTURE X.                             57300000
           02  FILLER REDEFINES ORDR-QUANTITYF.                         58000000
             03 ORDR-QUANTITYA    PICTURE X.                            58700000
           02  FILLER   PICTURE X(2).                                   59400000
           02  ORDR-QUANTITYI  PIC X(3).                                60100000
           02  ORDR-USERIDL    COMP  PIC  S9(4).                        60800000
           02  ORDR-USERIDF    PICTURE X.                               61500000
           02  FILLER REDEFINES ORDR-USERIDF.                           62200000
             03 ORDR-USERIDA    PICTURE X.                              62900000
           02  FILLER   PICTURE X(2).                                   63600000
           02  ORDR-USERIDI  PIC X(8).                                  64300000
           02  ORDR-DEPTL    COMP  PIC  S9(4).                          65000000
           02  ORDR-DEPTF    PICTURE X.                                 65700000
           02  FILLER REDEFINES ORDR-DEPTF.                             66400000
             03 ORDR-DEPTA    PICTURE X.                                67100000
           02  FILLER   PICTURE X(2).                                   67800000
           02  ORDR-DEPTI  PIC X(8).                                    68500000
           02  ORDR-MSGL    COMP  PIC  S9(4).                           69200000
           02  ORDR-MSGF    PICTURE X.                                  69900000
           02  FILLER REDEFINES ORDR-MSGF.                              70600000
             03 ORDR-MSGA    PICTURE X.                                 71300000
           02  FILLER   PICTURE X(2).                                   72000000
           02  ORDR-MSGI  PIC X(79).                                    72700000
       01  EXORDRO REDEFINES EXORDRI.                                   73400000
           02  FILLER PIC X(12).                                        74100000
           02  FILLER PICTURE X(3).                                     74800000
           02  ORDR-ITEMREFC    PICTURE X.                              75500000
           02  ORDR-ITEMREFH    PICTURE X.                              76200000
           02  ORDR-ITEMREFO  PIC X(4).                                 76900000
           02  FILLER PICTURE X(3).                                     77600000
           02  ORDR-DESCC    PICTURE X.                                 78300000
           02  ORDR-DESCH    PICTURE X.                                 79000000
           02  ORDR-DESCO  PIC X(40).                                   79700000
           02  FILLER PICTURE X(3).                                     80400000
           02  ORDR-COSTC    PICTURE X.                                 81100000
           02  ORDR-COSTH    PICTURE X.                                 81800000
           02  ORDR-COSTO  PIC X(6).                                    82500000
           02  FILLER PICTURE X(3).                                     83200000
           02  ORDR-STKC    PICTURE X.                                  83900000
           02  ORDR-STKH    PICTURE X.                                  84600000
           02  ORDR-STKO  PIC X(4).                                     85300000
           02  FILLER PICTURE X(3).                                     86000000
           02  ORDR-ORDC    PICTURE X.                                  86700000
           02  ORDR-ORDH    PICTURE X.                                  87400000
           02  ORDR-ORDO  PIC X(3).                                     88100000
           02  FILLER PICTURE X(3).                                     88800000
           02  ORDR-QUANTITYC    PICTURE X.                             89500000
           02  ORDR-QUANTITYH    PICTURE X.                             90200000
           02  ORDR-QUANTITYO  PIC X(3).                                90900000
           02  FILLER PICTURE X(3).                                     91600000
           02  ORDR-USERIDC    PICTURE X.                               92300000
           02  ORDR-USERIDH    PICTURE X.                               93000000
           02  ORDR-USERIDO  PIC X(8).                                  93700000
           02  FILLER PICTURE X(3).                                     94400000
           02  ORDR-DEPTC    PICTURE X.                                 95100000
           02  ORDR-DEPTH    PICTURE X.                                 95800000
           02  ORDR-DEPTO  PIC X(8).                                    96500000
           02  FILLER PICTURE X(3).                                     97200000
           02  ORDR-MSGC    PICTURE X.                                  97900000
           02  ORDR-MSGH    PICTURE X.                                  98600000
           02  ORDR-MSGO  PIC X(79).                                    99300000