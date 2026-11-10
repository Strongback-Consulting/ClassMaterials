      ******************************************************************00400000
      *                                                                *00800000
      * CONTROL BLOCK NAME = DFH0XM3                                   *01200000
      *                                                                *01600000
      * DESCRIPTIVE NAME = CICS     (Samples) Example Application -    *02000000
      *                     Copybook for BMS mapsets for menu & order  *02500000
      *                                                                *03000000
      *  @BANNER_START                           01                    *03083300
      *  Licensed Materials - Property of IBM                          *03166600
      *                                                                *03249900
      *  5655-M15              DFH0XM3                                 *03333200
      *                                                                *03416500
      *  (C) Copyright IBM Corp. 2004, 2005                            *03499800
      *                                                                *03583100
      *  CICS                                                          *03666400
      *  (Element of CICS Transaction Server                           *03749700
      *  for z/OS, Version 3 Release 1)                                *03833000
      *  @BANNER_END                                                   *03916300
      *                                                                *04000000
      * STATUS = 6.4.0                                                 *04500000
      *                                                                *05000000
      * FUNCTION =                                                     *05500000
      *      This copy book is part of the example application &       *06000000
      *      defines the data passed to and from the BMS mapsets for   *06500000
      *      the configuration application                             *07000000
      *                                                                *07500000
      *----------------------------------------------------------------*08000000
      *                                                                *08500000
      * CHANGE ACTIVITY :                                              *09000000
      *      $SEG(DFH0XM3),COMP(SAMPLES),PROD(CICS    ):               *09500000
      *                                                                *10000000
      *   PN= REASON REL YYMMDD HDXXIII : REMARKS                      *10500000
      *  $D0= I07544 640 050114 HDIPCB  : ExampleApp CICS client code   11000000
      *   $D0= I07544 640 040910 HDIPCB  : EXAMPLE - BASE APPLICATION  *11500000
      *                                                                *12000000
      ******************************************************************12500000
       01  EXCONFI.                                                     13000000
           02  FILLER PIC X(12).                                        13500000
           02  DS-TYPEL    COMP  PIC  S9(4).                            14000000
           02  DS-TYPEF    PICTURE X.                                   14500000
           02  FILLER REDEFINES DS-TYPEF.                               15000000
             03 DS-TYPEA    PICTURE X.                                  15500000
           02  FILLER   PICTURE X(2).                                   16000000
           02  DS-TYPEI  PIC X(4).                                      16500000
           02  WS-OUTBOUNDL    COMP  PIC  S9(4).                        17000000
           02  WS-OUTBOUNDF    PICTURE X.                               17500000
           02  FILLER REDEFINES WS-OUTBOUNDF.                           18000000
             03 WS-OUTBOUNDA    PICTURE X.                              18500000
           02  FILLER   PICTURE X(2).                                   19000000
           02  WS-OUTBOUNDI  PIC X(3).                                  19500000
           02  CATMAN-PROGL    COMP  PIC  S9(4).                        20000000
           02  CATMAN-PROGF    PICTURE X.                               20500000
           02  FILLER REDEFINES CATMAN-PROGF.                           21000000
             03 CATMAN-PROGA    PICTURE X.                              21500000
           02  FILLER   PICTURE X(2).                                   22000000
           02  CATMAN-PROGI  PIC X(8).                                  22500000
           02  DSSTUB-PROGL    COMP  PIC  S9(4).                        23000000
           02  DSSTUB-PROGF    PICTURE X.                               23500000
           02  FILLER REDEFINES DSSTUB-PROGF.                           24000000
             03 DSSTUB-PROGA    PICTURE X.                              24500000
           02  FILLER   PICTURE X(2).                                   25000000
           02  DSSTUB-PROGI  PIC X(8).                                  25500000
           02  DSVSAM-PROGL    COMP  PIC  S9(4).                        26000000
           02  DSVSAM-PROGF    PICTURE X.                               26500000
           02  FILLER REDEFINES DSVSAM-PROGF.                           27000000
             03 DSVSAM-PROGA    PICTURE X.                              27500000
           02  FILLER   PICTURE X(2).                                   28000000
           02  DSVSAM-PROGI  PIC X(8).                                  28500000
           02  ODSTUB-PROGL    COMP  PIC  S9(4).                        29000000
           02  ODSTUB-PROGF    PICTURE X.                               29500000
           02  FILLER REDEFINES ODSTUB-PROGF.                           30000000
             03 ODSTUB-PROGA    PICTURE X.                              30500000
           02  FILLER   PICTURE X(2).                                   31000000
           02  ODSTUB-PROGI  PIC X(8).                                  31500000
           02  ODWS-PROGL    COMP  PIC  S9(4).                          32000000
           02  ODWS-PROGF    PICTURE X.                                 32500000
           02  FILLER REDEFINES ODWS-PROGF.                             33000000
             03 ODWS-PROGA    PICTURE X.                                33500000
           02  FILLER   PICTURE X(2).                                   34000000
           02  ODWS-PROGI  PIC X(8).                                    34500000
           02  STKMAN-PROGL    COMP  PIC  S9(4).                        35000000
           02  STKMAN-PROGF    PICTURE X.                               35500000
           02  FILLER REDEFINES STKMAN-PROGF.                           36000000
             03 STKMAN-PROGA    PICTURE X.                              36500000
           02  FILLER   PICTURE X(2).                                   37000000
           02  STKMAN-PROGI  PIC X(8).                                  37500000
           02  VSAM-FILEL    COMP  PIC  S9(4).                          38000000
           02  VSAM-FILEF    PICTURE X.                                 38500000
           02  FILLER REDEFINES VSAM-FILEF.                             39000000
             03 VSAM-FILEA    PICTURE X.                                39500000
           02  FILLER   PICTURE X(2).                                   40000000
           02  VSAM-FILEI  PIC X(8).                                    40500000
           02  WS-SERVERL    COMP  PIC  S9(4).                          41000000
           02  WS-SERVERF    PICTURE X.                                 41500000
           02  FILLER REDEFINES WS-SERVERF.                             42000000
             03 WS-SERVERA    PICTURE X.                                42500000
           02  FILLER   PICTURE X(2).                                   43000000
           02  WS-SERVERI  PIC X(48).                                   43500000
           02  OUT-WS-URI1L    COMP  PIC  S9(4).                        44000000
           02  OUT-WS-URI1F    PICTURE X.                               44500000
           02  FILLER REDEFINES OUT-WS-URI1F.                           45000000
             03 OUT-WS-URI1A    PICTURE X.                              45500000
           02  FILLER   PICTURE X(2).                                   46000000
           02  OUT-WS-URI1I  PIC X(44).                                 46500000
           02  OUT-WS-URI2L    COMP  PIC  S9(4).                        47000000
           02  OUT-WS-URI2F    PICTURE X.                               47500000
           02  FILLER REDEFINES OUT-WS-URI2F.                           48000000
             03 OUT-WS-URI2A    PICTURE X.                              48500000
           02  FILLER   PICTURE X(2).                                   49000000
           02  OUT-WS-URI2I  PIC X(44).                                 49500000
           02  OUT-WS-URI3L    COMP  PIC  S9(4).                        50000000
           02  OUT-WS-URI3F    PICTURE X.                               50500000
           02  FILLER REDEFINES OUT-WS-URI3F.                           51000000
             03 OUT-WS-URI3A    PICTURE X.                              51500000
           02  FILLER   PICTURE X(2).                                   52000000
           02  OUT-WS-URI3I  PIC X(44).                                 52500000
           02  OUT-WS-URI4L    COMP  PIC  S9(4).                        53000000
           02  OUT-WS-URI4F    PICTURE X.                               53500000
           02  FILLER REDEFINES OUT-WS-URI4F.                           54000000
             03 OUT-WS-URI4A    PICTURE X.                              54500000
           02  FILLER   PICTURE X(2).                                   55000000
           02  OUT-WS-URI4I  PIC X(44).                                 55500000
           02  OUT-WS-URI5L    COMP  PIC  S9(4).                        56000000
           02  OUT-WS-URI5F    PICTURE X.                               56500000
           02  FILLER REDEFINES OUT-WS-URI5F.                           57000000
             03 OUT-WS-URI5A    PICTURE X.                              57500000
           02  FILLER   PICTURE X(2).                                   58000000
           02  OUT-WS-URI5I  PIC X(44).                                 58500000
           02  OUT-WS-URI6L    COMP  PIC  S9(4).                        59000000
           02  OUT-WS-URI6F    PICTURE X.                               59500000
           02  FILLER REDEFINES OUT-WS-URI6F.                           60000000
             03 OUT-WS-URI6A    PICTURE X.                              60500000
           02  FILLER   PICTURE X(2).                                   61000000
           02  OUT-WS-URI6I  PIC X(35).                                 61500000
           02  MSGL    COMP  PIC  S9(4).                                62000000
           02  MSGF    PICTURE X.                                       62500000
           02  FILLER REDEFINES MSGF.                                   63000000
             03 MSGA    PICTURE X.                                      63500000
           02  FILLER   PICTURE X(2).                                   64000000
           02  MSGI  PIC X(79).                                         64500000
       01  EXCONFO REDEFINES EXCONFI.                                   65000000
           02  FILLER PIC X(12).                                        65500000
           02  FILLER PICTURE X(3).                                     66000000
           02  DS-TYPEC    PICTURE X.                                   66500000
           02  DS-TYPEH    PICTURE X.                                   67000000
           02  DS-TYPEO  PIC X(4).                                      67500000
           02  FILLER PICTURE X(3).                                     68000000
           02  WS-OUTBOUNDC    PICTURE X.                               68500000
           02  WS-OUTBOUNDH    PICTURE X.                               69000000
           02  WS-OUTBOUNDO  PIC X(3).                                  69500000
           02  FILLER PICTURE X(3).                                     70000000
           02  CATMAN-PROGC    PICTURE X.                               70500000
           02  CATMAN-PROGH    PICTURE X.                               71000000
           02  CATMAN-PROGO  PIC X(8).                                  71500000
           02  FILLER PICTURE X(3).                                     72000000
           02  DSSTUB-PROGC    PICTURE X.                               72500000
           02  DSSTUB-PROGH    PICTURE X.                               73000000
           02  DSSTUB-PROGO  PIC X(8).                                  73500000
           02  FILLER PICTURE X(3).                                     74000000
           02  DSVSAM-PROGC    PICTURE X.                               74500000
           02  DSVSAM-PROGH    PICTURE X.                               75000000
           02  DSVSAM-PROGO  PIC X(8).                                  75500000
           02  FILLER PICTURE X(3).                                     76000000
           02  ODSTUB-PROGC    PICTURE X.                               76500000
           02  ODSTUB-PROGH    PICTURE X.                               77000000
           02  ODSTUB-PROGO  PIC X(8).                                  77500000
           02  FILLER PICTURE X(3).                                     78000000
           02  ODWS-PROGC    PICTURE X.                                 78500000
           02  ODWS-PROGH    PICTURE X.                                 79000000
           02  ODWS-PROGO  PIC X(8).                                    79500000
           02  FILLER PICTURE X(3).                                     80000000
           02  STKMAN-PROGC    PICTURE X.                               80500000
           02  STKMAN-PROGH    PICTURE X.                               81000000
           02  STKMAN-PROGO  PIC X(8).                                  81500000
           02  FILLER PICTURE X(3).                                     82000000
           02  VSAM-FILEC    PICTURE X.                                 82500000
           02  VSAM-FILEH    PICTURE X.                                 83000000
           02  VSAM-FILEO  PIC X(8).                                    83500000
           02  FILLER PICTURE X(3).                                     84000000
           02  WS-SERVERC    PICTURE X.                                 84500000
           02  WS-SERVERH    PICTURE X.                                 85000000
           02  WS-SERVERO  PIC X(48).                                   85500000
           02  FILLER PICTURE X(3).                                     86000000
           02  OUT-WS-URI1C    PICTURE X.                               86500000
           02  OUT-WS-URI1H    PICTURE X.                               87000000
           02  OUT-WS-URI1O  PIC X(44).                                 87500000
           02  FILLER PICTURE X(3).                                     88000000
           02  OUT-WS-URI2C    PICTURE X.                               88500000
           02  OUT-WS-URI2H    PICTURE X.                               89000000
           02  OUT-WS-URI2O  PIC X(44).                                 89500000
           02  FILLER PICTURE X(3).                                     90000000
           02  OUT-WS-URI3C    PICTURE X.                               90500000
           02  OUT-WS-URI3H    PICTURE X.                               91000000
           02  OUT-WS-URI3O  PIC X(44).                                 91500000
           02  FILLER PICTURE X(3).                                     92000000
           02  OUT-WS-URI4C    PICTURE X.                               92500000
           02  OUT-WS-URI4H    PICTURE X.                               93000000
           02  OUT-WS-URI4O  PIC X(44).                                 93500000
           02  FILLER PICTURE X(3).                                     94000000
           02  OUT-WS-URI5C    PICTURE X.                               94500000
           02  OUT-WS-URI5H    PICTURE X.                               95000000
           02  OUT-WS-URI5O  PIC X(44).                                 95500000
           02  FILLER PICTURE X(3).                                     96000000
           02  OUT-WS-URI6C    PICTURE X.                               96500000
           02  OUT-WS-URI6H    PICTURE X.                               97000000
           02  OUT-WS-URI6O  PIC X(35).                                 97500000
           02  FILLER PICTURE X(3).                                     98000000
           02  MSGC    PICTURE X.                                       98500000
           02  MSGH    PICTURE X.                                       99000000
           02  MSGO  PIC X(79).                                         99500000