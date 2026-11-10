000100 IDENTIFICATION DIVISION.
000200 PROGRAM-ID. NACT03.
000300 AUTHOR.       A PROGRAMMER.
000310 INSTALLATION. IBM HURSLEY.
000320 DATE-WRITTEN. AUGUST 1999.
000330 DATE-COMPILED.
000340*
000341*-------------------------------------------------------------*
000342*                                                             *
000343*               @BANNER_START@                                *
000344*      nact03.cbl                                             *
000345*      (C) Copyright IBM Corp. 2000. All Rights Reserved.     *
000346*                                                             *
000347* Element of Designing and Programming CICS Applications book *
000348*               @BANNER_END@                                  *
000349*                                                             *
000350*-------------------------------------------------------------*
000351*
000361***************************************************************
000362*    DESCRIPTION
000363*
000364* This program provides the convenience print function as part
000365* of the CICS Application Design and Programming book sample
000366* application. It employs Basic Mapping Support (BMS) services
000370* to perform its function.
000393*
000395***************************************************************
000396*     AMENDMENT HISTORY
000397*
000398*      DATE         AUTHOR          DESCRIPTION
000399*
000400*
000401***************************************************************
000402*     FILES
000403*
000404***************************************************************
000405*     CICS RESOURCES
000406*
000407***************************************************************
000408*     UTILITIES
000409*
000410***************************************************************
000411*     COPYBOOKS
000412*
000413*     NACWLITS - Common working storage.
000418*     NACWERRH - Working storage layout of the data passed to
000419*                the Error Handler program.
000422*     NACTSET  - The mapsets.
000423*
000424***************************************************************
000430*
000800 ENVIRONMENT DIVISION.
000900 DATA DIVISION.
000910*
001000 WORKING-STORAGE SECTION.
001020*
001030*    Store eye catcher details to aid dump reading
001040*
001050 01  WS-DEBUG-DETAILS.
001060     05  FILLER                        PIC X(32)
001070           VALUE 'NACT03-------WORKING STORAGE  '.
001080     05  DEBUG-EYE.
001090         10  DEBUG-TRANID              PIC X(4) VALUE SPACES.
001091         10  DEBUG-TERMID              PIC X(4) VALUE SPACES.
001092         10  DEBUG-TASKNO              PIC 9(7) VALUE ZERO.
001093     05  FILLER                        PIC X    VALUE SPACE.
001094     05  DEBUG-COMMAREA-ADDR           USAGE IS POINTER.
001102*
001110 01  FILLER.
001200*
001300* This field is used for interfacing with the
001400* ABEND/Error Handler program in the suite.
001500*
001600     05  WS-PROGRAM-NAME               PIC X(8) VALUE SPACES.
001670     05  ABEND-PROGRAM.
001680         10  WS-ABEND-PROGRAM-PREFIX   PIC X(4) VALUE SPACES.
001690         10  FILLER                    PIC X(4) VALUE '04  '.
001710*
001800* This field is used to control the input since there may
001900* be more than one set of data to be printed queued up.
002000*
002100     05  END-SWITCH                    PIC X VALUE 'Y'.
002300         88  NO-MORE                   VALUE 'N'.
002400*
002420* Store of EIBRESP and EIBRESP2 set up in each EXEC CICS statement
002430*
002440     05  RESPONSE                      PIC S9(8) COMP-4 VALUE 0.
002450     05  REASON-CODE                   PIC S9(8) COMP-4 VALUE 0.
002460*
002500* The EIBFN is defined as character but the error interface
002600* expects a numeric value.
002700*
002800     05  WORK-FN                       PIC 9(4) COMP VALUE ZERO.
002900     05  WORK-FN-X REDEFINES WORK-FN   PIC X(2).
003000*
003100* Various values which you might wish to modify are placed in one
003200* copy book in order to make those sorts of changes more easily.
003300*
003310 01  FILLER.
003320     05  FILLER                        PIC X(36) VALUE
003330         '********  NACWLITS COPYBOOK  *******'.
003400     COPY NACWLITS.
003500*
003600* The interface to the error handler program is described
003700* in a copy book in order to ensure consistency.
003800*
003810 01  FILLER.
003820     05  FILLER                        PIC X(36) VALUE
003830        '********  NACWERRH COPYBOOK  *******'.
003900     COPY NACWERRH.
004000*
004100* The generated symbolic map must be included in the program.
004200*
004210 01  FILLER.
004220     05  FILLER                        PIC X(36) VALUE
004230         '********  NACTSET COPYBOOK  ********'.
004300     COPY NACTSET.
004400*
004500 EJECT.
005100*
005200 PROCEDURE DIVISION.
005201*
005210*
005220 NACT03-MAIN SECTION.
005221*
005222* First we establish the ABEND handler in case unexpected
005223* errors arise, such as program interrupts. The technique
005224* used here assumes a naming convention where the variable
005225* part of the program names is in the 5th and 6th positions.
005226* This allows for changes to the names in case the provided
005227* names conflict with existing applications.
005229*
005230 NACT03-010.
005300     EXEC CICS ASSIGN
005400               PROGRAM(WS-PROGRAM-NAME)
005500               NOHANDLE
005600     END-EXEC.
005610*
005620     MOVE WS-PROGRAM-NAME TO WS-ABEND-PROGRAM-PREFIX.
005660*
005900     EXEC CICS HANDLE ABEND
006000               PROGRAM(ABEND-PROGRAM)
006110               RESP(RESPONSE)
006120               RESP2(REASON-CODE)
006200     END-EXEC.
006210*
006300     IF  RESPONSE NOT = DFHRESP(NORMAL)
006400         EXEC CICS ABEND
006500                   ABCODE(WS-LITS-ABEND-ERROR-ABEND)
006600         END-EXEC
006700     END-IF.
006710*
006720 NACT03-020.
006800*
006801*  Set up values in the eye-catcher
006802*
006803     MOVE EIBTRNID TO DEBUG-TRANID.
006804     MOVE EIBTRMID TO DEBUG-TERMID.
006805     MOVE EIBTASKN TO DEBUG-TASKNO.
006806*
006807*  Set up the commarea address
006808*
006809     SET DEBUG-COMMAREA-ADDR TO ADDRESS OF DFHCOMMAREA.
006810*
006816 NACT03-030.
006820*
006900* The main logic of the program is is performed as a loop since
007000* there may be more than one set of data to be printed queued up.
007100* Since the task on behalf of which this program runs must be
007200* STARTed, the data is obtained via a CICS RETRIEVE command.
007300*
007400     PERFORM UNTIL NO-MORE
007500         EXEC CICS RETRIEVE
007600                   INTO(ACCTDTLO)
007710                   RESP(RESPONSE)
007720                   RESP2(REASON-CODE)
007800         END-EXEC
007900         EVALUATE RESPONSE
008000*
008100* If data was returned, then it is to be in the BMS mapset form
008200* so we simply need to send it to the terminal (printer) with
008300* which this task is associated. The PRINT option is included
008400* to ensure that printing is performed immediately rather
008500* than simply placed into the buffer of the device.
008600*
008700             WHEN DFHRESP(NORMAL)
008800                 EXEC CICS SEND
008900                           MAP('ACCTDTL')
009000                           MAPSET(WS-LITS-MAPSET)
009100                           PRINT
009200                           ERASE
009300                           NOHANDLE
009400                 END-EXEC
009500*
009600* If we have exhausted the data, then we set
009700* the indicator to terminate the loop.
009800*
009900             WHEN DFHRESP(ENDDATA)
010000                 SET NO-MORE TO TRUE
010100*
010200* If any other condition arises, then a serious problem has
010300* occurred, so the error handler is invoked.
010400*
010500             WHEN OTHER
010600                 SET WS-ERRH-CORRECT-VERSION TO TRUE
010700                 MOVE RESPONSE            TO WS-ERRH-ERROR
010800                 MOVE REASON-CODE         TO WS-ERRH-REASON
010900                 MOVE EIBFN               TO WORK-FN-X
011000                 MOVE WORK-FN             TO WS-ERRH-CICS-FUNCTION
011010                 MOVE WS-PROGRAM-NAME     TO WS-ERRH-PROGRAM
011100                 EXEC CICS XCTL
011200                           PROGRAM(ABEND-PROGRAM)
011300                           COMMAREA(WS-ERRH-ERROR-COMMAREA)
011400                           NOHANDLE
011500                 END-EXEC
011600*
011700* The following will only be executed if the XCTL fails.
011800* The primary reason that might happen is if the error
011900* handling program has become unavailable for some reason.
012000*
012100                 EXEC CICS ABEND
012200                           ABCODE(WS-LITS-ABEND-ERROR-ABEND)
012300                 END-EXEC
012400         END-EVALUATE
012500     END-PERFORM.
012510*
012520 NACT03-030.
012600*
012700* When all of the data is printed, we simply terminate the task.
012800*
012900     EXEC CICS RETURN
013000     END-EXEC.
013010*
013100 END-NACT03-MAIN.
013200     EXIT.
