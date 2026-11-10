      *****************************************************************
      ******************************************************************
      *
      *          THIS PROGRAM READS AN IDMS DATABASE
      *          PRODUCED BY DATA ENTRY OPERATORS FROM CICS SCREENS
      *
      *          IT CONTAINS PART/SUPPLIER INFORMATION
      *
      *
      ******************************************************************
      *****************************************************************
       IDENTIFICATION DIVISION.
       PROGRAM-ID. IDMRDZ.
       ENVIRONMENT DIVISION.
       CONFIGURATION SECTION.
       SOURCE-COMPUTER. IBM-3090.
       OBJECT-COMPUTER. IBM-3090.

       DATA DIVISION.
       WORKING-STORAGE SECTION.
       01  WS-PART-NAME-ID PIC 9(04) VALUE 0.
       01  FILE-STATUS-CODES.
           05  IFCODE           PIC X(2).
               88 CODE-READ     VALUE SPACES.
               88 NO-MORE-DATA  VALUE "10".
           05  OFCODE           PIC X(2).
               88 CODE-WRITE    VALUE SPACES.

       01  COUNTERS-AND-ACCUMULATORS.
           05  REC-KTR        PIC S9(4)     COMP.
           05  TOTAL-AMOUNT   PIC S9(3)V99  COMP-3.

       01  IDMS-DB-CTRL.
           03 PGM-NM PIC X(8) VALUE SPACES.
           03 ERR-STAT PIC X(4) VALUE '1400'.
                88 DB-STATUS-OK       VALUE '0000'.
                88 ANY-STATUS         VALUE ' ' THRU '9999'.
                88 ANY-ERR-STAT   VALUE '0001' THRU '9999'.
                88 DB-END-OF-SET      VALUE '0307'.
                88 DB-REC-NOT-FOUND   VALUE '0326'.
           03 IDMS-DBKEY PIC S9(8) COMP SYNC.
           03 RECORD-NAME PIC X(16)         VALUE SPACES.
           03 RDZ-REC-NAME REDEFINES RECORD-NAME.
                      05 SSC-NODN PIC X(8).
                      05 SSC-DBN PIC X(8).
                      03 AREA-NAME PIC X(16)           VALUE SPACES.
           03 AREA-RNAME REDEFINES AREA-NAME.
                      05 SSC-DNO PIC X(8).
                      05 SSC-DNA PIC X(8).
           03 ERROR-SET PIC X(16)           VALUE SPACES.
           03 ERROR-RECORD PIC X(16)        VALUE SPACES.
           03 ERROR-AREA PIC X(16)          VALUE SPACES.
           03 DBCOM-AREA PIC X(100)      VALUE LOW-VALUE.
           03 DBCOM REDEFINES DBCOM-AREA
                      PIC X      OCCURS 100.
           03 RDBCOM REDEFINES DBCOM-AREA.
                      05 DB-SUB-ADDR PIC X(4).
                      05 FILLER PIC X(96).
           03 DIRECT-IDMS-DBKEY PIC S9(8) COMP SYNC.
           03 DIRECT-IDMS-DBK REDEFINES DIRECT-IDMS-DBKEY
                                         PIC S9(8) COMP.
           03 DATABASE-STATUS.
                      05 DBSTATMENT-CODE PIC X(2).
                      05 DBSTATUS-CODE PIC X(5).
           03 FILLER PIC X.
           03 RECORD-OCCUR PIC S9(8) COMP SYNC.
           03 DML-SEQUENCE PIC S9(8) COMP SYNC.

       01  SUB-SCHEMA-SSNAME PIC X(8)        VALUE 'RDZSS01 '.

       01  SUB-SCHEMA-RECORDS.
           03 RDZ460 PIC X(16)    VALUE 'SUPPLIERS'.
           03 RDZ455 PIC X(16)    VALUE 'PARTS '.
           03 RDZ450 PIC X(16)    VALUE 'ASSEMBLY '.
           03 RDZ445 PIC X(16)    VALUE 'WAREHOUSE'.
           03 RDZ440 PIC X(16)    VALUE 'KEY'.
           03 RDZ435 PIC X(16)    VALUE 'DRIVER'.
           03 RDZ430 PIC X(16)    VALUE 'LOCATION'.
           03 RDZ425 PIC X(16)    VALUE 'COLOR'.
           03 RDZ420 PIC X(16)    VALUE 'WEIGHT'.
           03 RDZ415 PIC X(16)    VALUE 'VALUE'.
           03 RDZ410 PIC X(16)    VALUE 'BACK-ORDER'.
           03 RDZ405 PIC X(16)    VALUE 'SUB-PART'.
           03 RDZ400 PIC X(16)    VALUE 'TEXTURE'.

        01 SUB-SCHEMA-SETS.
           03 SUPPLIERS PIC X(16) VALUE 'SUPPLIERS '.
           03 PARTS PIC X(16)   VALUE 'PARTS '.
           03 RDZ-WEIGHT PIC X(16)    VALUE 'RDZ-WEIGHT '.
           03 RDZ-EXPERTISE PIC X(16)   VALUE 'RDZ-EXPERTISE '.
           03 RDZ-NAME-NDX PIC X(16)    VALUE 'RDZ-NAME-NDX '.
           03 RDZ-HEIGHT PIC X(16)  VALUE 'RDZ-HEIGHT '.
           03 JOB-HEIGHT PIC X(16)  VALUE 'JOB-HEIGHT '.
           03 JOB-TITLE-NDX PIC X(16)   VALUE 'JOB-TITLE-NDX '.
           03 LOCATION PIC X(16)         VALUE 'LOCATION '.
           03 OFFICE-WAREHOUSE PIC X(16) VALUE 'DEPT-WREHOUSE'.
           03 COMPONENT PIC X(16)      VALUE 'COMPONENT '.
           03 MODEL-NO PIC X(16) VALUE 'MODEL-NO '.
           03 DESCRIPTION-NDX PIC X(16)  VALUE 'DESCRIPTION-NDX '.
           03 AMT PIC X(16)            VALUE 'AMT '.

       01  SUB-SCHEMA-AREANAMES.
           03 RDZ-TERRITORY PIC X(16) VALUE 'RDZ-TERRITORY '.
           03 INS-TERRITORY PIC X(16) VALUE 'INS-TERRITORY '.
           03 LOCATION PIC X(16) VALUE 'LOCATION '.
           03 D-CODE-WS     PIC X(3) VALUE '299'.

      * COPY IDMS RECORD WAREHOUSE.
       01  WAREHOUSE.
           02 PART-NAME-ID-0410 PIC 9(4).
           02 PART-NAME-NAME-0410 PIC X(45).
           02 PART-NAME-HEAD-ID-0410 PIC 9(4).
           02 FILLER PIC XXX.

       PROCEDURE DIVISION.
       MAIN.
           PERFORM 000-BEGIN THRU 000-EXIT.
           PERFORM 100-DB-LOOP THRU 100-EXIT.
           PERFORM 200-EOJ THRU 200-EXIT.
           GOBACK.
       MAIN-EXIT.
           EXIT.

       000-BEGIN.
      * BIND RUN-UNIT.
           MOVE '613' TO D-CODE-WS.
           CALL 'IDMS' USING IDMS-DB-CTRL
                                        DBCOM (59)
                                        IDMS-DB-CTRL
                                        SUB-SCHEMA-SSNAME.
           PERFORM IDMS-STATUS.

      * BIND WAREHOUSE.
           CALL 'IDMS' USING IDMS-DB-CTRL
                                        DBCOM (48)
                                        RDZ410
                                        WAREHOUSE.
           PERFORM IDMS-STATUS.

      * READY LOCATION.
           CALL 'IDMS' USING IDMS-DB-CTRL
                                        DBCOM (37)
                                        WAREHOUSE.
           PERFORM IDMS-STATUS.
           ACCEPT WS-PART-NAME-ID.

       000-EXIT.
           EXIT.

       100-DB-LOOP.
           MOVE WS-PART-NAME-ID TO PART-NAME-ID-0410.
      * OBTAIN AMT WAREHOUSE.
           CALL 'IDMS' USING IDMS-DB-CTRL
                                        DBCOM (32)
                                        RDZ410
                                        DBCOM (43).
           IF DB-STATUS-OK
               DISPLAY 'WAREHOUSE : ' PART-NAME-NAME-0410
           ELSE
           IF DB-REC-NOT-FOUND
               DISPLAY 'INVALID WAREHOUSE CODE'
           ELSE
               PERFORM IDMS-STATUS.
       100-EXIT.
           EXIT.
       200-EOJ.
      * EOJ
            CALL 'IDMS' USING IDMS-DB-CTRL
            DBCOM (2).
       200-EXIT.
           EXIT.

      * END-OF-PROGRAM ERROR AND RUN-STATUS HANDLING
      *********************************************************
      *********************************************************
       IDMS-STATUS.
      * ROLLBACK.
           CALL 'DSNTIAR' USING IDMS-DB-CTRL
                             DBCOM (67).
       IDMS-STATUS-EXIT.
           EXIT.

