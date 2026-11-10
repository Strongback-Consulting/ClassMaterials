       IDENTIFICATION DIVISION.
       PROGRAM-ID.  DFSIVA64
      *
      ********************************************************@SCPYRT**
      *                                                               *
      *  Licensed Materials - Property of IBM                         *
      *                                                               *
      *  5635-A01                                                     *
      *                                                               *
      *  (C) Copyright IBM Corp. 1991,1998 All Rights Reserved        *
      *                                                               *
      *  US Government Users Restricted Rights - Use, duplication or  *
      *  disclosure restricted by GSA ADP Schedule contract with      *
      *  IBM Corp.                                                    *
      *                                                               *
      ********************************************************@ECPYRT**
      *
      * APPLICATION  :  BMP DL/I PROGRAM
      * TRANSACTION  :  NONE (BMP/DLI)
      * PSB          :  DFSIVP64
      * DATABASE     :  DFSIVD1
      * INPUT:
      *
      *        TELEPHONE DIRECTORY SYSTEM
      *        PROCESS CODE : CCCCCCCC
      *        LAST NAME    : XXXXXXXXXX
      *        FIRST NAME   : XXXXXXXXXX
      *        EXTENSION#   : N-NNN-NNNN
      *        INTERNAL ZIP : XXX/XXX
      *
      * CCCCCCCC = COMMAND
      *        ADD     = INSERT ENTRY IN DB
      *        DELETE  = DELETE ENTRY FROM DB
      *        UPDATE  = UPDATE ENTRY FROM DB
      *        DISPLAY = DISPLAY ENTRY
      *        TADD    = SAME AS ADD, BUT WRITE TO OPERATOR
      *
      *       CHANGES:  THIS MODULE IS NEW IN IMS/ESA 3.2
      *  APAR...  ID  PREREQ.  DATE....  DESCRIPTION...................
      *  KNQ0115  01           11/17/91  Add COBOL lang version
      *
       ENVIRONMENT DIVISION.
       CONFIGURATION SECTION.
       SOURCE-COMPUTER.  IBM-370.
       OBJECT-COMPUTER.  IBM-370.
      *
       DATA DIVISION.
       WORKING-STORAGE SECTION.

      * DL/I FUNCTION CODES

       77  GET-UNIQUE      PIC  X(4)  VALUE 'GU  '.
       77  GET-HOLD-UNIQUE PIC  X(4)  VALUE 'GHU '.
       77  GET-NEXT        PIC  X(4)  VALUE 'GN  '.
       77  ISRT            PIC  X(4)  VALUE 'ISRT'.
       77  DLET            PIC  X(4)  VALUE 'DLET'.
       77  REPL            PIC  X(4)  VALUE 'REPL'.

      * DL/I CALL STATUS CODE

       77  END-OF-DATABASE PIC  X(4)  VALUE 'GB'.

      * MESSAGES

       77  MDEL    PIC  X(40)
                   VALUE 'ENTRY WAS DELETED                       '.
       77  MADD    PIC  X(40)
                   VALUE 'ENTRY WAS ADDED                         '.
       77  MEND    PIC  X(40)
                   VALUE 'BMP/DLI PGM HAS ENDED                   '.
       77  MDIS    PIC  X(40)
                   VALUE 'Good Day. Have a great day              '.
       77  MUPD1   PIC  X(40)
                   VALUE 'ENTRY WAS UPDATED                       '.
       77  MTEST   PIC  X(40)
                   VALUE 'TEST REQUEST WAS ENDED                  '.
       77  MMORE   PIC  X(40)
                   VALUE 'DATA IS NOT ENOUGH                      '.
       77  MINV    PIC  X(40)
                   VALUE 'PROCESS CODE IS NOT VALID               '.
       77  MUPD0   PIC  X(40)
                   VALUE 'PLEASE UPDATE ENTRY                     '.
       77  MNODATA PIC  X(40)
                   VALUE 'NO DATA WAS ENTERED                     '.
       77  MNONAME PIC  X(40)
                   VALUE 'LAST NAME WAS NOT SPECIFIED             '.
       77  MNOENT  PIC  X(40)
                   VALUE 'SPECIFIED PERSON WAS NOT FOUND          '.
       77  MISRTE  PIC  X(40)
                   VALUE 'ADDITION OF ENTRY HAS FAILED            '.
       77  MDLETE  PIC  X(40)
                   VALUE 'DELETION OF ENTRY HAS FAILED            '.
       77  MREPLE  PIC  X(40)
                   VALUE 'UPDATE OF ENTRY HAS FAILED              '.

      * VARIABLES

       77  TEMP-ONE   PICTURE X(8) VALUE SPACES.
       77  TEMP-TWO   PICTURE X(8) VALUE SPACES.
       77  REPLY      PICTURE X(16).
       77  APPROVED   PICTURE X(1).

      * CONSTANTS

       77  HEADER-BLOCK    PIC X(50)
           VALUE '**************************************************'.
       77  HEADER-NAME     PIC X(50)
           VALUE '*  IMS INSTALLATION VERIFICATION PROCEDURE!      *'.
       77  CONSTANT1       PIC X(24)
           VALUE   'PROCESS  CODE  (*1) :   '.
       77  CONSTANT2       PIC X(24)
           VALUE   'LAST  NAME          :   '.
       77  CONSTANT3       PIC X(24)
           VALUE   'FIRST NAME          :   '.
       77  CONSTANT4       PIC X(24)
           VALUE   'EXTENSION  NUMBER   :   '.
       77  CONSTANT5       PIC X(24)
           VALUE   'INTERNAL  ZIP CODE  :   '.
       77  CONSTANT6       PIC X(17)
           VALUE   '(*1) PROCESS CODE'.
       77  CONSTANT7       PIC X(7)
           VALUE   'ADD    '.
       77  CONSTANT8       PIC X(7)
           VALUE   'DELETE '.
       77  CONSTANT9       PIC X(7)
           VALUE   'UPDATE '.
       77  CONSTANT10      PIC X(7)
           VALUE   'DISPLAY'.
       77  CONSTANT11      PIC X(7)
           VALUE   'TADD   '.
       77  SSA1            PIC X(9)  VALUE 'A1111111 '.


      * FLAGS

       01 FLAGS.
          02  SET-DATA-FLAG  PIC X VALUE '0'.
             88  NO-SET-DATA       VALUE '1'.
          02  TADD-FLAG      PIC X VALUE '0'.
             88  PROCESS-TADD      VALUE '1'.

      * COUNTERS

       01 COUNTERS.
          02  L-SPACE-CTR    PIC   9(2) COMP VALUE 0.

      * OUTLINE FORMAT

       01  BLANKLINE.
           02  ANSI     PIC  X.
           02  HFILLER  PIC  X(24)  VALUE SPACES.
           02  LEDGE    PIC  X(1)   VALUE '|'.
           02  FILLER   PIC  X(80)  VALUE SPACES.
           02  REDGE    PIC  X(1)   VALUE '|'.
           02  FILLER   PIC  X(14)  VALUE SPACES.
       01  OUTLINE1.
           02  O-ANSI   PIC  X.
           02  HFILLER  PIC  X(24)  VALUE SPACES.
           02  OUTLN1A  PIC  X(40)
               VALUE '*---------------------------------------'.
           02  OUTLN1B  PIC  X(42)
               VALUE '-----------------------------------------*'.
           02  FILLER   PIC  X(14)  VALUE SPACES.
       01  OUTLINE2.
           02  ANSI     PIC  X.
           02  HFILLER  PIC  X(24)  VALUE SPACES.
           02  LEDGE    PIC  X(1)   VALUE '|'.
           02  FILLER   PIC  X(15)  VALUE SPACES.
           02  HDRLN    PIC  X(50)  VALUE SPACES.
           02  FILLER   PIC  X(15)  VALUE SPACES.
           02  REDGE    PIC  X(1)   VALUE '|'.
           02  FILLER   PIC  X(14)  VALUE SPACES.
       01  OUTLINE3.
           02  ANSI     PIC  X.
           02  HFILLER  PIC  X(24)  VALUE SPACES.
           02  LEDGE    PIC  X(1)   VALUE '|'.
           02  FILLER   PIC  X(40)  VALUE SPACES.
           02  D1LN     PIC  X(27)
               VALUE 'TRANSACTION TYPE : BMP/DLI '.
           02  D2LN     PIC  X(10)  VALUE '(HIDAM DB)'.
           02  FILLER   PIC  X(3)   VALUE SPACES.
           02  REDGE    PIC  X(1)   VALUE '|'.
           02  FILLER   PIC  X(14)  VALUE SPACES.
       01  OUTLINE4.
           02  ANSI     PIC  X.
           02  HFILLER  PIC  X(24)  VALUE SPACES.
           02  LEDGE    PIC  X(1)   VALUE '|'.
           02  FILLER   PIC  X(40)  VALUE SPACES.
           02  D1CON    PIC  X(19)  VALUE 'DATE      :'.
           02  D1VAR    PIC  X(8)   VALUE '  /  /  '.
           02  TEMP-DATE REDEFINES D1VAR.
               04  MM          PIC  X(2).
               04  DATE-FILL1  PIC  X.
               04  DD          PIC  X(2).
               04  DATE-FILL2  PIC  X.
               04  YY          PIC  X(2).
           02  FILLER   PIC  X(13)  VALUE SPACES.
           02  REDGE    PIC  X(1)   VALUE '|'.
           02  FILLER   PIC  X(14)  VALUE SPACES.
       01  OUTLINE5.
           02  ANSI     PIC  X.
           02  HFILLER  PIC  X(24)  VALUE SPACES.
           02  LEDGE    PIC  X(1)   VALUE '|'.
           02  DFILL2   PIC  X(10)  VALUE SPACES.
           02  D2CON1   PIC  X(24).
           02  D2VAR    PIC  X(10).
           02  DFILL2A  PIC  X(23)  VALUE SPACES.
           02  D2CON2   PIC  X(7)   VALUE SPACES.
           02  FILLER   PIC  X(6)   VALUE SPACES.
           02  REDGE    PIC  X(1)   VALUE '|'.
           02  FILLER   PIC  X(14)  VALUE SPACES.
       01  OUTLINE6.
           02  ANSI     PIC  X.
           02  HFILLER  PIC  X(24)  VALUE SPACES.
           02  LEDGE    PIC  X(1)   VALUE '|'.
           02  DFILL3   PIC  X(59)  VALUE SPACES.
           02  D3CON    PIC  X(17).
           02  FILLER   PIC  X(4)   VALUE SPACES.
           02  REDGE    PIC  X(1)   VALUE '|'.
           02  FILLER   PIC  X(14)  VALUE SPACES.
       01  OUTLINE7.
           02  ANSI     PIC  X.
           02  HFILLER  PIC  X(24)  VALUE SPACES.
           02  LEDGE    PIC  X(1)   VALUE '|'.
           02  DFILL4   PIC  X(10)  VALUE SPACES.
           02  D4VAR1   PIC  X(40).
           02  DFILL4A  PIC  X(10)  VALUE SPACES.
           02  D4CON    PIC  X(12)  VALUE 'SEGMENT# :  '.
           02  D4VAR2   PIC  X(4).
           02  FILLER   PIC  X(4)   VALUE SPACES.
           02  REDGE    PIC  X(1)   VALUE '|'.
           02  FILLER   PIC  X(14)  VALUE SPACES.


      * I/O AREA FOR DATACASE HANDLING

       01  IOAREA.
           02  IO-BLANK  PIC  X(37) VALUE SPACES.
           02  IO-DATA REDEFINES IO-BLANK.
               03  IO-LAST-NAME   PIC  X(10).
               03  IO-FIRST-NAME  PIC  X(10).
               03  IO-EXTENSION   PIC  X(10).
               03  IO-ZIP-CODE    PIC  X(7).
           02  IO-FILLER    PIC  X(3) VALUE SPACES.
           02  IO-COMMAND   PIC  X(8) VALUE SPACES.

      * GSAM TEXT FOR ERROR CALL

       01  GS-TEXT.
           02  GS-TEXT1           PIC  X(7)   VALUE 'STATUS '.
           02  GS-ERROR-STATUS    PIC  X(2).
           02  GS-TEXT2           PIC  X(12)  VALUE 'GSAM CALL = '.
           02  GS-ERROR-CALL      PIC  X(4).

      * DC TEXT FOR ERROR CALL

       01 DC-TEXT.
          02  DC-TEXT1         PIC  X(7) VALUE 'STATUS '.
          02  DC-ERROR-STATUS  PIC  X(2).
          02  DC-TEXT2         PIC  X(12) VALUE 'DLI  CALL = '.
          02  DC-ERROR-CALL    PIC  X(4).

       01  TEMPDATE.
           02  TYY      PIC  99.
           02  TMM      PIC  99.
           02  TDD      PIC  99.


      * SEGMENT SEARCH ARGUMENT

       01 SSA.
          02  SEGMENT-NAME  PIC X(8)  VALUE 'A1111111'.
          02  SEG-KEY-NAME  PIC X(11) VALUE '(A1111111 ='.
          02  SSA-KEY       PIC X(10).
          02  FILLER        PIC X VALUE ')'.

        COPY IMSPHBK2.

       LINKAGE SECTION.

       01  IOPCB.
           02  LTERM-NAME      PIC  X(8).
           02  IO-RESERVE-IMS  PIC  X(2).
           02  IO-STATUS       PIC  X(2).
           02  CURR-DATE       PIC  X(4).
           02  CURR-TIME       PIC  X(4).
           02  IN-MSN          PIC  X(4).
           02  MODNAME         PIC  X(8).
           02  USERID          PIC  X(8).
       01  DBPCB.
           02  DBD-NAME        PIC  X(8).
           02  SEG-LEVEL       PIC  X(2).
           02  DBSTATUS        PIC  X(2).
           02  PROC-OPTIONS    PIC  X(4).
           02  RESERVE-DLI     PIC  X(4).
           02  SEG-NAME-FB     PIC  X(8).
           02  LENGTH-FB-KEY   PIC  9(4).
           02  NUMB-SENS-SEGS  PIC  9(4).
           02  KEY-FB-AREA     PIC  X(17).
       01  GIPCB.
           02  DBD-NAME        PIC  X(8).
           02  SEG-LEVEL       PIC  X(2).
           02  GI-STATUS       PIC  X(2).
           02  PROC-OPTIONS    PIC  X(4).
           02  RESERVE-DLI     PIC  X(4).
           02  SEG-NAME-FB     PIC  X(8).
           02  LENGTH-FB-KEY   PIC  9(4).
           02  NUMB-SENS-SEGS  PIC  9(4).
           02  KEY-FB-AREA     PIC  X(17).
       01  GOPCB.
           02  DBD-NAME        PIC  X(8).
           02  SEG-LEVEL       PIC  X(2).
           02  GO-STATUS       PIC  X(2).
           02  PROC-OPTIONS    PIC  X(4).
           02  RESERVE-DLI     PIC  x(4).
           02  SEG-NAME-FB     PIC  X(8).
           02  LENGTH-FB-KEY   PIC  9(4).
           02  NUMB-SENS-SEGS  PIC  9(4).
           02  KEY-FB-AREA     PIC  X(17).

       PROCEDURE DIVISION USING IOPCB, DBPCB, GIPCB, GOPCB.

      * ON ENTRY IMS PASSES ADDRESSES FOR IOPCB, DBPCB, GIPCB AND GOPCB

       MAIN-RTN.
           DISPLAY "I am enjoying this lab!! MQ"
           MOVE 0 TO SET-DATA-FLAG.
           MOVE 0 TO TADD-FLAG.
           MOVE GET-NEXT TO GS-ERROR-CALL.
           CALL 'CBLTDLI' USING GET-NEXT, GIPCB, INPUT-AREA.
       READ-INPUT.
           IF GI-STATUS = END-OF-DATABASE GOBACK.
           IF GI-STATUS NOT EQUAL SPACES
              PERFORM GSAM-ERROR
           ELSE
              PERFORM PROCESS-INPUT THRU PROCESS-INPUT-END.
           MOVE GET-NEXT TO GS-ERROR-CALL.
           CALL 'CBLTDLI' USING GET-NEXT, GIPCB, INPUT-AREA.
           GO TO READ-INPUT.

      * PROCEDURE PROCESS-INPUT

       PROCESS-INPUT.

           MOVE SPACES TO OUT-BLANK.
           MOVE SPACES TO OUT-FILL.
           MOVE SPACES TO IO-BLANK.

      *    CHECK THE LEADING SPACE IN INPUT COMMAND AND TRIM IT OFF

           INSPECT IN-COMMAND TALLYING L-SPACE-CTR FOR LEADING SPACE
             REPLACING LEADING SPACE BY '*'.
           IF L-SPACE-CTR > 0
             UNSTRING IN-COMMAND DELIMITED BY ALL '*' INTO TEMP-ONE
               TEMP-TWO
             MOVE TEMP-TWO TO IN-COMMAND
             MOVE 0 TO L-SPACE-CTR
             MOVE SPACES TO TEMP-TWO.

      *    CHECK THE LEADING SPACE IN INPUT LAST NAME AND TRIM IT OFF

           INSPECT IN-LAST-NAME TALLYING L-SPACE-CTR FOR LEADING
             SPACE REPLACING LEADING SPACE BY '*'.
           IF L-SPACE-CTR > 0
             UNSTRING IN-LAST-NAME DELIMITED BY ALL '*' INTO TEMP-ONE
               TEMP-TWO
             MOVE TEMP-TWO TO IN-LAST-NAME
             MOVE 0 TO L-SPACE-CTR
             MOVE SPACES TO TEMP-TWO.

      *    CHECK THE LEADING SPACE IN INPUT FIRST NAME AND TRIM IT OFF

           INSPECT IN-FIRST-NAME TALLYING L-SPACE-CTR FOR LEADING
             SPACE REPLACING LEADING SPACE BY '*'.
           IF L-SPACE-CTR > 0
             UNSTRING IN-FIRST-NAME DELIMITED BY ALL '*' INTO TEMP-ONE
               TEMP-TWO
             MOVE TEMP-TWO TO IN-FIRST-NAME
             MOVE 0 TO L-SPACE-CTR
             MOVE SPACES TO TEMP-TWO.

      *    CHECK THE LEADING SPACE IN INPUT EXTENSION AND TRIM IT OFF

           INSPECT IN-EXTENSION TALLYING L-SPACE-CTR FOR LEADING
             SPACE REPLACING LEADING SPACE BY '*'.
           IF L-SPACE-CTR > 0
             UNSTRING IN-EXTENSION DELIMITED BY ALL '*' INTO TEMP-ONE
               TEMP-TWO
             MOVE TEMP-TWO TO IN-EXTENSION
             MOVE 0 TO L-SPACE-CTR
             MOVE SPACES TO TEMP-TWO.

      *    CHECK THE LEADING SPACE IN INPUT ZIP CODE AND TRIM IT OFF

           INSPECT IN-ZIP-CODE TALLYING L-SPACE-CTR FOR LEADING SPACE
             REPLACING LEADING SPACE BY '*'.
           IF L-SPACE-CTR > 0
             UNSTRING IN-ZIP-CODE DELIMITED BY ALL '*' INTO TEMP-ONE
               TEMP-TWO
             MOVE TEMP-TWO TO IN-ZIP-CODE
             MOVE 0 TO L-SPACE-CTR
             MOVE SPACES TO TEMP-TWO.
           MOVE IN-LAST-NAME TO IO-LAST-NAME.
           MOVE IN-COMMAND TO IO-COMMAND.

           IF IO-COMMAND EQUAL SPACES
           THEN MOVE MINV TO OUT-MESSAGE
                PERFORM ISRT-IO THRU ISRT-IO-END
           ELSE IF IO-LAST-NAME EQUAL SPACES
                THEN MOVE MNONAME TO OUT-MESSAGE
                    PERFORM ISRT-IO THRU ISRT-IO-END
           ELSE IF TEMP-IOCMD EQUAL 'ADD'
                THEN PERFORM TO-ADD THRU TO-ADD-END
           ELSE IF TEMP-IOCMD EQUAL 'TAD'
                THEN MOVE 1 TO TADD-FLAG
                    PERFORM TO-ADD THRU TO-ADD-END
           ELSE IF TEMP-IOCMD EQUAL 'UPD'
                THEN PERFORM TO-UPD THRU TO-UPD-END
           ELSE IF TEMP-IOCMD EQUAL 'DEL'
                THEN PERFORM TO-DEL THRU TO-DEL-END
           ELSE IF TEMP-IOCMD EQUAL 'DIS'
                THEN PERFORM TO-DIS THRU TO-DIS-END
           ELSE
               MOVE IN-COMMAND TO OUT-COMMAND
               MOVE IN-LAST-NAME TO OUT-LAST-NAME
               MOVE MINV TO OUT-MESSAGE
               PERFORM ISRT-IO THRU ISRT-IO-END.
       PROCESS-INPUT-END.
           EXIT.

      * PROCEDURE GSAM-ERROR

       GSAM-ERROR.
           MOVE GI-STATUS TO GS-ERROR-STATUS.
           DISPLAY GS-TEXT1, GS-ERROR-STATUS, GS-TEXT2,
                   GS-ERROR-CALL UPON CONSOLE
           GOBACK.

      * PROCEDURE TO-ADD : ADDITION REQUEST HANDLER

       TO-ADD.
           MOVE 1 TO APPROVED.
           MOVE IN-FIRST-NAME TO IO-FIRST-NAME.
           MOVE IN-EXTENSION  TO IO-EXTENSION.
           MOVE IN-ZIP-CODE   TO IO-ZIP-CODE.
           MOVE IO-DATA       TO OUT-DATA.
           MOVE IO-COMMAND    TO OUT-COMMAND.

           IF IN-FIRST-NAME EQUAL SPACES OR
               IN-EXTENSION EQUAL SPACES OR
               IN-ZIP-CODE EQUAL SPACES
           THEN
               MOVE MMORE TO OUT-MESSAGE
               PERFORM ISRT-IO THRU ISRT-IO-END
           ELSE
               CALL 'PBILOG' USING INPUT-AREA OUTPUT-AREA APPROVED
               IF APPROVED EQUAL 0
                   PERFORM ISRT-IO THRU ISRT-IO-END
               ELSE
                   PERFORM ISRT-DB THRU ISRT-DB-END
               END-IF
           END-IF.
       TO-ADD-END.
           EXIT.


      * PROCEDURE TO-UPD : UPDATE REQUEST HANDLER

       TO-UPD.
           MOVE 0 TO SET-DATA-FLAG.
           MOVE IN-COMMAND TO OUT-COMMAND.
           MOVE IN-LAST-NAME TO OUT-LAST-NAME.
           MOVE IO-LAST-NAME TO SSA-KEY.
           PERFORM GET-HOLD-UNIQUE-DB THRU GET-HOLD-UNIQUE-DB-END.
           IF DBSTATUS = SPACES
           THEN
             IF IN-FIRST-NAME NOT = SPACES
               MOVE 1 TO SET-DATA-FLAG
               MOVE IN-FIRST-NAME TO IO-FIRST-NAME
             END-IF
             IF IN-EXTENSION  NOT = SPACES
               MOVE 1 TO SET-DATA-FLAG
               MOVE IN-EXTENSION  TO IO-EXTENSION
             END-IF
             IF IN-ZIP-CODE   NOT = SPACES
               MOVE 1 TO SET-DATA-FLAG
               MOVE IN-ZIP-CODE   TO IO-ZIP-CODE
             END-IF
             MOVE IO-DATA TO OUT-DATA.
             MOVE IO-COMMAND TO OUT-COMMAND.
             IF NO-SET-DATA
             IF NO-SET-DATA
             THEN
               PERFORM REPL-DB THRU REPL-DB-END
             ELSE
               MOVE MNODATA TO OUT-MESSAGE
               PERFORM ISRT-IO THRU ISRT-IO-END.
       TO-UPD-END.
           EXIT.

      * PROCEDURE TO-DEL : DELETE REQUEST HANDLER

       TO-DEL.
           MOVE IO-LAST-NAME TO SSA-KEY.
           PERFORM GET-HOLD-UNIQUE-DB THRU GET-HOLD-UNIQUE-DB-END.
           IF DBSTATUS = SPACES
           THEN
              MOVE IO-DATA TO OUT-DATA
              MOVE IO-COMMAND TO OUT-COMMAND
              PERFORM DLET-DB THRU DLET-DB-END.
       TO-DEL-END.
           EXIT.

      * PROCEDURE TO-DIS : DISPLAY REQUEST HANDLER

       TO-DIS.
           MOVE IN-COMMAND TO OUT-COMMAND.
           MOVE IN-LAST-NAME TO OUT-LAST-NAME.
           MOVE IO-LAST-NAME TO SSA-KEY.
           PERFORM GET-UNIQUE-DB THRU GET-UNIQUE-DB-END.
           IF DBSTATUS = SPACES
           THEN
              MOVE IO-DATA TO OUT-DATA
              MOVE IO-COMMAND TO OUT-COMMAND
              MOVE MDIS TO OUT-MESSAGE
              PERFORM ISRT-IO THRU ISRT-IO-END.
       TO-DIS-END.
           EXIT.

      * PROCEDURE ISRT-DB : DATA BASE SEGMENT INSERT REQUEST HANDLER

       ISRT-DB.
           MOVE ISRT TO DC-ERROR-CALL.
           CALL 'CBLTDLI' USING ISRT, DBPCB, IOAREA, SSA1
           IF DBSTATUS   = SPACES
           THEN
              IF PROCESS-TADD
                 DISPLAY 'INSERT IS DONE, REPLY' UPON CONSOLE
                 ACCEPT REPLY FROM CONSOLE
                 MOVE 0 TO TADD-FLAG
              END-IF
              MOVE MADD TO OUT-MESSAGE
              PERFORM ISRT-IO THRU ISRT-IO-END
           ELSE
              MOVE MISRTE TO OUT-MESSAGE
              MOVE DBSTATUS TO DC-ERROR-STATUS
              PERFORM ISRT-IO THRU ISRT-IO-END.
       ISRT-DB-END.
           EXIT.

      * PROCEDURE GET-UNIQUE-DB
      *    DATA BASE SEGMENT GET-UNIQUE-DB REQUEST HANDLER

       GET-UNIQUE-DB.
           MOVE GET-UNIQUE TO DC-ERROR-CALL.
           CALL 'CBLTDLI' USING GET-UNIQUE, DBPCB, IOAREA, SSA.
           IF DBSTATUS NOT = SPACES
           THEN
              MOVE MNOENT TO OUT-MESSAGE
              MOVE DBSTATUS TO DC-ERROR-STATUS
              PERFORM ISRT-IO THRU ISRT-IO-END.
       GET-UNIQUE-DB-END.
           EXIT.

      * PROCEDURE GET-HOLD-UNIQUE-DB
      *    DATA BASE SEGMENT GET-HOLD-UNIQUE-DB REQUEST HANDLER

       GET-HOLD-UNIQUE-DB.
           MOVE GET-HOLD-UNIQUE TO DC-ERROR-CALL.
           CALL 'CBLTDLI' USING GET-HOLD-UNIQUE, DBPCB, IOAREA, SSA.
           IF DBSTATUS NOT = SPACES
           THEN
              MOVE MNOENT TO OUT-MESSAGE
              MOVE DBSTATUS TO DC-ERROR-STATUS
              PERFORM ISRT-IO THRU ISRT-IO-END.
       GET-HOLD-UNIQUE-DB-END.
           EXIT.

      * PROCEDURE REPL-DB : DATA BASE SEGMENT REPLACE REQUEST HANDLER

       REPL-DB.
           MOVE REPL TO DC-ERROR-CALL.
           CALL 'CBLTDLI' USING REPL, DBPCB, IOAREA.
           IF DBSTATUS = SPACES
           THEN
              MOVE MUPD1 TO OUT-MESSAGE
              PERFORM ISRT-IO THRU ISRT-IO-END
           ELSE
              MOVE MREPLE TO OUT-MESSAGE
              MOVE DBSTATUS TO DC-ERROR-STATUS
              PERFORM ISRT-IO THRU ISRT-IO-END.
       REPL-DB-END.
           EXIT.

      * PROCEDURE DLET-DB : DATA BASE SEGMENT DELETE REQUEST HANDLER

       DLET-DB.
           MOVE DLET TO DC-ERROR-CALL.
           CALL 'CBLTDLI' USING DLET, DBPCB, IOAREA.
           IF DBSTATUS = SPACES
           THEN
              MOVE MDEL TO OUT-MESSAGE
              PERFORM ISRT-IO THRU ISRT-IO-END
           ELSE
              MOVE MDLETE TO OUT-MESSAGE
              MOVE DBSTATUS TO DC-ERROR-STATUS
              PERFORM ISRT-IO THRU ISRT-IO-END.
       DLET-DB-END.
           EXIT.


      * PROCEDURE ISRT-IO : FORMAT AND PRINT OUTPUT PAGE

       ISRT-IO.
           MOVE ISRT  TO GS-ERROR-CALL.
           ADD +1  TO OUT-SEGMENT-NO.
           ACCEPT TEMPDATE FROM DATE.
           PERFORM SETDATE.

           MOVE 1 TO O-ANSI.
           CALL 'CBLTDLI' USING ISRT, GOPCB, OUTLINE1.
           IF GO-STATUS NOT EQUAL SPACES
              PERFORM GSAM-ERROR.
           CALL 'CBLTDLI' USING ISRT, GOPCB, OUTLINE2.
           IF GO-STATUS NOT EQUAL SPACES
              PERFORM GSAM-ERROR.

           MOVE HEADER-BLOCK TO HDRLN.
           CALL 'CBLTDLI' USING ISRT, GOPCB, OUTLINE2.
           IF GO-STATUS NOT EQUAL SPACES
              PERFORM GSAM-ERROR.
           MOVE SPACES TO HDRLN.

           MOVE HEADER-NAME TO HDRLN.
           CALL 'CBLTDLI' USING ISRT, GOPCB, OUTLINE2.
           IF GO-STATUS NOT EQUAL SPACES
              PERFORM GSAM-ERROR.
           MOVE SPACES TO HDRLN.

           MOVE HEADER-BLOCK TO HDRLN.
           CALL 'CBLTDLI' USING ISRT, GOPCB, OUTLINE2.
           IF GO-STATUS NOT EQUAL SPACES
              PERFORM GSAM-ERROR.
           MOVE SPACES TO HDRLN.

           CALL 'CBLTDLI' USING ISRT, GOPCB, BLANKLINE.
           IF GO-STATUS NOT EQUAL SPACES
              PERFORM GSAM-ERROR.

           CALL 'CBLTDLI' USING ISRT, GOPCB, BLANKLINE.
           IF GO-STATUS NOT EQUAL SPACES
              PERFORM GSAM-ERROR.

           CALL 'CBLTDLI' USING ISRT, GOPCB, OUTLINE3.
           IF GO-STATUS NOT EQUAL SPACES
              PERFORM GSAM-ERROR.

           CALL 'CBLTDLI' USING ISRT, GOPCB, OUTLINE4.
           IF GO-STATUS NOT EQUAL SPACES
              PERFORM GSAM-ERROR.

           CALL 'CBLTDLI' USING ISRT, GOPCB, BLANKLINE.
           IF GO-STATUS NOT EQUAL SPACES
              PERFORM GSAM-ERROR.
           MOVE CONSTANT1 TO D2CON1.
           MOVE OUT-COMMAND TO D2VAR.
           CALL 'CBLTDLI' USING ISRT, GOPCB, OUTLINE5.
           IF GO-STATUS NOT EQUAL SPACES
              PERFORM GSAM-ERROR.
           MOVE SPACES TO D2CON1.
           MOVE SPACES TO D2VAR.

           MOVE CONSTANT6 TO D3CON.
           CALL 'CBLTDLI' USING ISRT, GOPCB, OUTLINE6.
           IF GO-STATUS NOT EQUAL SPACES
              PERFORM GSAM-ERROR.

           MOVE CONSTANT2 TO D2CON1.
           MOVE OUT-LAST-NAME TO D2VAR.
           MOVE CONSTANT7  TO D2CON2.
           CALL 'CBLTDLI' USING ISRT, GOPCB, OUTLINE5.
           IF GO-STATUS NOT EQUAL SPACES
              PERFORM GSAM-ERROR.
           MOVE SPACES TO D2CON1.
           MOVE SPACES TO D2VAR.
           MOVE SPACES TO D2CON2.

           MOVE CONSTANT8 TO D2CON2.
           CALL 'CBLTDLI' USING ISRT, GOPCB, OUTLINE5.
           IF GO-STATUS NOT EQUAL SPACES
              PERFORM GSAM-ERROR.
           MOVE SPACES TO D2CON2.

           MOVE CONSTANT3 TO D2CON1.
           MOVE OUT-FIRST-NAME TO D2VAR.
           MOVE CONSTANT9 TO D2CON2.
           CALL 'CBLTDLI' USING ISRT, GOPCB, OUTLINE5.
           IF GO-STATUS NOT EQUAL SPACES
              PERFORM GSAM-ERROR.
           MOVE SPACES TO D2CON1.
           MOVE SPACES TO D2VAR.
           MOVE SPACES TO D2CON2.

           MOVE CONSTANT10 TO D2CON2.
           CALL 'CBLTDLI' USING ISRT, GOPCB, OUTLINE5.
           IF GO-STATUS NOT EQUAL SPACES
              PERFORM GSAM-ERROR.
           MOVE SPACES TO D2CON2.

           MOVE CONSTANT4 TO D2CON1.
           MOVE OUT-EXTENSION TO D2VAR.
           MOVE CONSTANT11 TO D2CON2.
           CALL 'CBLTDLI' USING ISRT, GOPCB, OUTLINE5.
           IF GO-STATUS NOT EQUAL SPACES
              PERFORM GSAM-ERROR.
           MOVE SPACES TO D2CON1.
           MOVE SPACES TO D2VAR.
           MOVE SPACES TO D2CON2.

           CALL 'CBLTDLI' USING ISRT, GOPCB, BLANKLINE.
           IF GO-STATUS NOT EQUAL SPACES
              PERFORM GSAM-ERROR.

           MOVE CONSTANT5 TO D2CON1.
           MOVE OUT-ZIP-CODE TO D2VAR.
           CALL 'CBLTDLI' USING ISRT, GOPCB, OUTLINE5.
           IF GO-STATUS NOT EQUAL SPACES
              PERFORM GSAM-ERROR.
           MOVE SPACES TO D2CON1.
           MOVE SPACES TO D2VAR.

           CALL 'CBLTDLI' USING ISRT, GOPCB, BLANKLINE.
           IF GO-STATUS NOT EQUAL SPACES
              PERFORM GSAM-ERROR.

           CALL 'CBLTDLI' USING ISRT, GOPCB, BLANKLINE.
           IF GO-STATUS NOT EQUAL SPACES
              PERFORM GSAM-ERROR.

           MOVE OUT-MESSAGE TO D4VAR1.
           MOVE OUT-SEGMENT-NO TO D4VAR2.
           CALL 'CBLTDLI' USING ISRT, GOPCB, OUTLINE7.
           IF GO-STATUS NOT EQUAL SPACES
              PERFORM GSAM-ERROR.

           CALL 'CBLTDLI' USING ISRT, GOPCB, BLANKLINE.
           IF GO-STATUS NOT EQUAL SPACES
              PERFORM GSAM-ERROR.

           CALL 'CBLTDLI' USING ISRT, GOPCB, BLANKLINE.
           IF GO-STATUS NOT EQUAL SPACES
              PERFORM GSAM-ERROR.

           CALL 'CBLTDLI' USING ISRT, GOPCB, BLANKLINE.
           IF GO-STATUS NOT EQUAL SPACES
              PERFORM GSAM-ERROR.

           MOVE 0 TO O-ANSI.
           CALL 'CBLTDLI' USING ISRT, GOPCB, OUTLINE1.
           IF GO-STATUS NOT EQUAL SPACES
              PERFORM GSAM-ERROR.
       ISRT-IO-END.
           EXIT.

      * PROCEDURE SETDATE : SET THE DATE

       SETDATE.
           MOVE TYY TO YY.
           MOVE TMM TO MM.
           MOVE TDD TO DD.
           EXIT.