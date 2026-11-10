000100 IDENTIFICATION DIVISION.
000200 PROGRAM-ID. NACT05.
000300 AUTHOR.       A PROGRAMMER.
000310 INSTALLATION. IBM HURSLEY.
000320 DATE-WRITTEN. AUGUST 1999.
000330 DATE-COMPILED.
000340*
000341*-------------------------------------------------------------*
000342*                                                             *
000343*               @BANNER_START@                                *
000344*      nact05.cbl                                             *
000345*      (C) Copyright IBM Corp. 2000. All Rights Reserved.     *
000346                                                              *
000347* Element of Designing and Programming CICS Applications book *
000348*               @BANNER_END@                                  *
000349*                                                             *
000350*-------------------------------------------------------------*
000351*
000360***************************************************************
000361*    DESCRIPTION
000362*
000363*    This program provides the Name Search (Browse) function
000364*    for the CICS Application Design and Programming book
000365*    sample application. It is designed to be LINKed to in
000370*    order to allow any number of front-ends to use its
000380*    services, e.g., BMS front-end (NACT01), VB, etc.
000390*
000394***************************************************************
000395*
000396*     AMENDMENT HISTORY
000397*
000398*      DATE         AUTHOR          DESCRIPTION
000399*
000400*
000401***************************************************************
000402*     FILES
000403*
000404*     ACCTNAM - WS-LITS-FILES-NAME
000405*         STARTBR
000407*         ENDBR
000409*         READNEXT
000411*
000412***************************************************************
000413*     CICS RESOURCES
000414*
000415***************************************************************
000416*     UTILITIES
000417*
000418***************************************************************
000419*     COPYBOOKS
000420*
000421*     NACWERRH - Working storage layout of the data passed to
000422*                the Error Handler program.
000423*     NACWLITS - Common working storage.
000425*     NACWTREC - Working storage layout of the Account record.
000426*     NACCBRWS - Commarea layout of the data passed to this
000427*                program from the calling program.
000428*
000429***************************************************************
000430*
000900 ENVIRONMENT DIVISION.
001000 DATA DIVISION.
001010*
001100 WORKING-STORAGE SECTION.
001120*
001130*    STORE EYE CATCHER DETAILS TO AID DUMP READING
001140*
001150 01  WS-DEBUG-DETAILS.
001160     05  FILLER                        PIC X(32)
001170           VALUE 'NACT05-------WORKING STORAGE  '.
001180     05  WS-DEBUG-EYE.
001190         10  WS-DEBUG-TRANID           PIC X(4) VALUE SPACES.
001191         10  WS-DEBUG-TERMID           PIC X(4) VALUE SPACES.
001192         10  WS-DEBUG-TASKNO           PIC 9(7) VALUE ZERO.
001193     05  FILLER                        PIC X    VALUE SPACE.
001194     05  WS-DEBUG-COMMAREA-ADDR        USAGE IS POINTER.
001195*
001210 01  FILLER.
001300*
001400* This field is used for interfacing with the
001500* ABEND/Error Handler program in the suite.
001600*
001610     05  WS-PROGRAM-NAME               PIC X(8) VALUE SPACES.
001620     05  ABEND-PROGRAM.
001630         10  WS-ABEND-PROGRAM-PREFIX   PIC X(4) VALUE SPACES.
001640         10  FILLER                    PIC X(4) VALUE '04  '.
001800*
001810* Store of EIBRESP and EIBRESP2 set up in each EXEC CICS statement
001820*
001830     05  RESPONSE                      PIC S9(8) COMP-4 VALUE 0.
001840     05  REASON-CODE                   PIC S9(8) COMP-4 VALUE 0.
001850*
001900* The EIBFN is defined as character but the error interface
002000* expects a numeric value.
002100*
002200     05  WS-WORK-EIBFN                   PIC 9(4) COMP VALUE ZERO.
002300     05  WS-WORK-EIBFN-X REDEFINES WS-WORK-EIBFN PIC X(2).
002400*
002500* This field is used to keep track of the results of the search.
002600*
002700     05  WS-AVAILABILITY-IND             PIC X.
002800         88  SOME-AVAILABLE              VALUE 'Y'.
002900         88  NONE-AVAILABLE              VALUE 'N'.
003000*
003100* These fields are used to keep track of the search
003200* criteria and for setting the bounds of the search
003300* against both surname and forename.
003400*
003500     05  WS-PASSED-NAMES.
003600         10  WS-PASSED-SNAME             PIC X(18) VALUE SPACES.
003700         10  WS-PASSED-FNAME             PIC X(12) VALUE SPACES.
003800     05  WS-LIMIT-NAMES.
003900         10  WS-BROWSE-SNAME             PIC X(18) VALUE SPACES.
004000         10  WS-MAX-SNAME                PIC X(18) VALUE SPACES.
004100         10  WS-MIN-FNAME                PIC X(12) VALUE SPACES.
004200         10  WS-MAX-FNAME                PIC X(12) VALUE SPACES.
004300*
004400* This field is used to keep track of the number of
004500* records found which match the search criteria.
004600*
004700     05  WS-RECORDS-READ                 PIC 9(4) COMP VALUE ZERO.
004800*
004810* This field is used to indicate whether input data is valid or
004820* invalid
004821*
004830     05  WS-REQUEST-VALIDITY             PIC X.
004840         88  VALID-REQUEST               VALUE 'Y'.
004850         88  INVALID-REQUEST             VALUE 'N'.
004900*
005000* The interface to the error handler program is described
005100* in a copy book in order to ensure correctness.
005200*
005300 01  FILLER.
005310     05  FILLER                          PIC X(36) VALUE
005320         '********  NACWERRH COPYBOOK  *******'.
005330     COPY NACWERRH.
005400*
005500* Various values which you might wish to modify are placed in one
005600* copy book in order to make those sorts of changes more easily.
005700*
005800 01  FILLER.
005900     05  FILLER                          PIC X(36) VALUE
005910         '********  NACWLITS COPYBOOK  *******'.
005920     COPY NACWLITS.
006000*
006100* The description of the account record is placed in a copy book.
006200* This area is used to read a record before placing it into the
006300* next available slot in the interface area.
006400*
006420 01  FILLER                              PIC X(36) VALUE
006430         '********  NACWTREC COPYBOOK  *******'.
006440*
006500 01  AN-ACCTREC.
006600     COPY NACWTREC.
007000*
007020 01  FILLER                              PIC X(36) VALUE
007030        '********  LINKAGE SECTION   ********'.
007040*
007100 EJECT.
007110*
007200 LINKAGE SECTION.
007210*
007220* The interface to this program is described in
007230* a copy book in order to ensure consistency.
007240*
007300 01  DFHCOMMAREA.
007400     COPY NACCBRWS.
007410*
007420 EJECT.
007430*
008300 PROCEDURE DIVISION.
008310*
008380*
008390 NACT05-MAIN SECTION.
008391*
008402*
008403 NACT05-010.
008404*
008405* First we establish the ABEND handler in case unexpected
008406* errors arise, such as program interrupts. The technique
008407* used here assumes a naming convention where the variable
008408* part of the program names is in the 5th and 6th positions.
008409* This allows for changes to the names in case the provided
008410* names conflict with existing applications.
008411*
008412* ASSIGN returns system information to the program.
008413* This example returns the name of the current program
008414* to WS-PROGRAM-NAME.
008415*
008420     EXEC CICS ASSIGN
008500               PROGRAM(WS-PROGRAM-NAME)
008600               NOHANDLE
008700     END-EXEC.
008710*
008800     MOVE WS-PROGRAM-NAME TO WS-ABEND-PROGRAM-PREFIX.
008910*
009000     EXEC CICS HANDLE ABEND
009100               PROGRAM(ABEND-PROGRAM)
009210               RESP(RESPONSE)
009220               RESP2(REASON-CODE)
009300     END-EXEC.
009310*
009400     IF  RESPONSE NOT = DFHRESP(NORMAL)
009500         EXEC CICS ABEND
009600                   ABCODE(WS-LITS-ABEND-ERROR-ABEND)
009700         END-EXEC
009800     END-IF.
009801*
009802 NACT05-020.
009803*
009804*  Set up values in the eye-catcher
009805*
009806     MOVE EIBTRNID TO WS-DEBUG-TRANID.
009807     MOVE EIBTRMID TO WS-DEBUG-TERMID.
009808     MOVE EIBTASKN TO WS-DEBUG-TASKNO.
009809*
009810*  Set up the commarea address
009811*
009812     SET WS-DEBUG-COMMAREA-ADDR TO ADDRESS OF DFHCOMMAREA.
009813*
009820 NACT05-030.
009900*
010400* When correct length COMMAREA has been passed and the
010410* browse request is valid, move the commarea name data
010411* to the working storage name data and start the browse.
010440* When a relevant name record is present and the request
010441* is a new browse, the relevant account records are read
010450* and moves to the commarea.
010451* When a relevant name record is present and the request
010452* is to continue a browse, reposition the account file at
010453* the last record that was read in the previous browse and
010454* read the following relevant name records moving them to
010460* the commarea.
010461* Note that an ABEND must be forced if the passed commarea is
010462* too small to be able to indicate an error in the normal way.
010470*
010500     IF  EIBCALEN >= LENGTH OF DFHCOMMAREA
010510         SET VALID-REQUEST TO TRUE
010520         PERFORM A-VALIDATE-REQUEST
010600         IF  VALID-REQUEST
011401             PERFORM B-INITIALISE-WS
011402             PERFORM C-START-BROWSE
011403             IF SOME-AVAILABLE
011410                EVALUATE TRUE
011450                    WHEN CA-BRWS-REQ-BROWSE
011460                      PERFORM D-FILL-IN-MATCHES
011492                    WHEN CA-BRWS-REQ-CONTINUE
011498                      PERFORM E-CONTINUE-BROWSE
011499                      IF NONE-AVAILABLE
011500                         PERFORM Z-ERROR-HANDLER
011501                      ELSE
011502                         ADD 1 TO CA-BRWS-FOUND
011503                         MOVE AN-ACCTREC
011504                                 TO CA-BRWS-ENTRY (CA-BRWS-FOUND)
011505                         PERFORM D-FILL-IN-MATCHES
011506                      END-IF
011507                END-EVALUATE
011508             END-IF
011509             PERFORM F-TERMINATE-BROWSE
011510         ELSE
011511             SET CA-BRWS-BAD-FORMAT TO TRUE
011512         END-IF
011513     ELSE
011514         IF  EIBCALEN > 11
011515             SET CA-BRWS-BAD-FORMAT   TO TRUE
011516             SET CA-BRWS-LENGTH-ERROR TO TRUE
011517         ELSE
011518             EXEC CICS ABEND
011519                       ABCODE(WS-LITS-ABEND-BRWS-IF)
011520             END-EXEC
011530         END-IF
011540     END-IF.
013301*
013302 NACT05-040.
013400     EXEC CICS RETURN
013500     END-EXEC.
013510*
013520 END-NACT05-MAIN.
013600     EXIT.
013700     EJECT.
013710*
013711 A-VALIDATE-REQUEST SECTION.
013712*
013713* Check the the data passed to ths program is correct and
013714* generate appropriate error responses where needed.
013718*
013719 A-010.
013725*
013726* Check that the CA-BRWS-limit-to-get passed to this program is
013727* numeric and in the range of 0 to WS-LITS-MAX-MATCHES which is
013728* the maximum number of name matches deliverable by the browsing
013729* function and is specified in the NACLITS copy library.
013730*
013740     IF  CA-BRWS-LIMIT-TO-GET NUMERIC
013750     AND (CA-BRWS-LIMIT-TO-GET < 0
013760          OR  CA-BRWS-LIMIT-TO-GET > WS-LITS-MAX-MATCHES)
013780              SET CA-BRWS-LIMIT-ERROR TO TRUE
013781              SET INVALID-REQUEST     TO TRUE
013782     END-IF.
013783*
013784     IF  CA-BRWS-LIMIT-TO-GET-X NOT NUMERIC
013785         SET CA-BRWS-LIMIT-ERROR TO TRUE
013786         SET INVALID-REQUEST     TO TRUE
013787     END-IF.
013788*
013789 A-020.
013790*
013791* When the request is to continue and obtain the next set of
013792* records by name, ensure CA-BRWS-MORE contains a valid number.
013795*
013796     IF CA-BRWS-REQ-CONTINUE
013797        AND (CA-BRWS-NO-MORE
013800             OR CA-BRWS-MORE-X NOT NUMERIC)
014100                SET CA-BRWS-MORE-ERROR TO TRUE
014110                SET INVALID-REQUEST    TO TRUE
014150     END-IF.
014151*
014152 A-030.
014153*
014154* Check that the request to this browse program is correct
014155* i.e. 'B' or 'C'.
014156*
014157     IF  NOT CA-BRWS-VALID-REQUEST
014158         SET CA-BRWS-REQUEST-ERROR TO TRUE
014159         SET INVALID-REQUEST       TO TRUE
014160     END-IF.
014161*
014162 A-040.
014163*
014164* Check that the version of the browse program is correct.
014166*
014167     IF  NOT CA-BRWS-CORRECT-VERSION
014168         SET CA-BRWS-VERSION-ERROR TO TRUE
014169         SET INVALID-REQUEST       TO TRUE
014170     END-IF.
014171*
014172 END-A-VALIDATE-REQUEST.
014173     EXIT.
014174     EJECT.
014180*
014200 B-INITIALISE-WS SECTION.
014210*
014220* Once the input parameters have been vetted for correct format,
014230* then working storage is initialised with commarea fields.
014250*
014260 B-010.
014300     MOVE SNAMEDO IN CA-BRWS-ENTRY (1) TO WS-PASSED-SNAME
014310                                          WS-BROWSE-SNAME
014400                                          WS-MAX-SNAME.
014410*
014500     INSPECT WS-MAX-SNAME REPLACING ALL SPACES BY HIGH-VALUES.
014510*
014600     MOVE FNAMEDO IN CA-BRWS-ENTRY (1) TO WS-PASSED-FNAME
014610                                          WS-MAX-FNAME
014700                                          WS-MIN-FNAME.
014710*
014800     INSPECT WS-MAX-FNAME REPLACING ALL SPACES BY HIGH-VALUES.
014900     INSPECT WS-MIN-FNAME REPLACING ALL SPACES BY LOW-VALUES.
014910*
015000     SET CA-BRWS-NONE-FOUND TO TRUE.
015100     SET CA-BRWS-NO-ERROR   TO TRUE.
017310*
017320 END-B-INITIALISE-WS SECTION.
017400     EXIT.
017410     EJECT.
017411*
017412 C-START-BROWSE SECTION.
017413*
017418*
017419* This routine initializes the browse of the file via the
017420* STARTBR command and sets the availability indicator based
017421* on the possibility of a match.
017422*
017423     SET CA-BRWS-NONE-FOUND TO TRUE.
017424*
017425     EXEC CICS STARTBR
017426               FILE(WS-LITS-FILES-NAME)
017427               RIDFLD(WS-BROWSE-SNAME)
017429               RESP(RESPONSE)
017430               RESP2(REASON-CODE)
017431     END-EXEC.
017432*
017433     EVALUATE RESPONSE
017434         WHEN DFHRESP(NORMAL)
017435             SET SOME-AVAILABLE  TO TRUE
017436         WHEN DFHRESP(NOTFND)
017437             SET NONE-AVAILABLE  TO TRUE
017438             SET CA-BRWS-NO-MORE TO TRUE
017439*
017440* If any other condition other than success or NOTFND
017441* occurs, then a serious problem has occurred, so the
017442* error handler is invoked.
017443*
017444         WHEN OTHER
017445             PERFORM Z-ERROR-HANDLER
017446     END-EVALUATE.
017447*
017448 END-C-START-BROWSE.
017449     EXIT.
017450     EJECT.
021330*
022000 D-FILL-IN-MATCHES SECTION.
022010*
022020* This routine finds matches until either the maximum number
022030* requested is reached or until it determines there are no
022040* more matches on file. When it finds a match it moves it to
022050* the interface area for the front-end.
022060*
022070 D-010.
022100     PERFORM UNTIL NONE-AVAILABLE
022200              OR  (CA-BRWS-FOUND = CA-BRWS-LIMIT-TO-GET)
022300         PERFORM Y-READ-ONE
022400         IF  SOME-AVAILABLE
022500             IF  FNAMEDO IN AN-ACCTREC >= WS-MIN-FNAME
022600             AND FNAMEDO IN AN-ACCTREC <= WS-MAX-FNAME
022700                 ADD 1           TO CA-BRWS-FOUND
022800                 MOVE AN-ACCTREC TO CA-BRWS-ENTRY (CA-BRWS-FOUND)
022900             END-IF
023000         END-IF
023100     END-PERFORM.
023200*
023210 D-020.
023220*
023300* If we have filled up the area with the maximum requested,
023400* we need to see if a continuation of the browse is possible
023500* in case the end user desires to see more.
023600*
023700     IF  CA-BRWS-FOUND = CA-BRWS-LIMIT-TO-GET
023800         PERFORM Y-READ-ONE
023900*
024000* This condition will be true if the number of matches exactly
024100* fills the interface area with the maximum requested.
024200*
024300         IF  NONE-AVAILABLE
024400             SET CA-BRWS-NO-MORE TO TRUE
024500*
024600* If there are more than the maximum number requested, the data
024700* area is set to indicate where we need to reposition to in the
024800* event of a subsequent continuation request.
024900*
025000         ELSE
025100             IF  FNAMEDO IN AN-ACCTREC > WS-MIN-FNAME
025200             AND FNAMEDO IN AN-ACCTREC < WS-MAX-FNAME
025300                 MOVE WS-RECORDS-READ TO CA-BRWS-MORE
025400             ELSE
025500                 SET CA-BRWS-NO-MORE TO TRUE
025600             END-IF
025700         END-IF
025800*
025900* If there are less than the maximum number requested,
026000* we need to indicate a continuation is not possible.
026100*
026200     ELSE
026300         SET CA-BRWS-NO-MORE TO TRUE
026400     END-IF.
026600*
026700 END-D-FILL-IN-MATCHES.
029300     EXIT.
029310     EJECT.
029311*
029312 E-CONTINUE-BROWSE SECTION.
029313*
029314* This routine continues a browse by checking to see if there is
029315* at least one match. If there is it repositions to where it had
029316* left off previously.
029317*
029318 E-010.
029320     PERFORM Y-READ-ONE UNTIL WS-RECORDS-READ = CA-BRWS-MORE
029321                        OR   NONE-AVAILABLE.
029322*
029323* If it cannot reposition correctly, then a serious problem
029324* has occurred, so the error handler is invoked.
029325*
029326*
029327* On a successful repositioning operation, it fills in the
029328* passed area up to the maximum number of matches requested.
029329*
029339 END-E-CONTINUE-BROWSE.
029340     EXIT.
029341     EJECT.
029342*
029343 F-TERMINATE-BROWSE SECTION.
029344*
029345* This routine terminates the browsing operation against the file.
029346*
029347 F-010.
029348     EXEC CICS ENDBR
029349               FILE(WS-LITS-FILES-NAME)
029351               RESP(RESPONSE)
029352               RESP2(REASON-CODE)
029360     END-EXEC.
029370*
029380     EVALUATE RESPONSE
029390         WHEN DFHRESP(NORMAL)
029400             CONTINUE
029500*
029600* An invalid request response is allowed since a STARTBR
029610* may not have been successfully completed previously.
029620* This is verified by testing the sub-reason found in
029630* the EIBRESP2 (REASON-CODE) field where the value of 35
029640* indicates this specific condition which is acceptable here.
029650*
029660         WHEN DFHRESP(INVREQ)
029670*
029680* If any other condition occurs, then a serious problem
029690* has occurred, so the error handler is invoked.
029691*
029692             IF  REASON-CODE NOT = 35
029693                 PERFORM Z-ERROR-HANDLER
029694             END-IF
029695         WHEN OTHER
029696             PERFORM Z-ERROR-HANDLER
029697     END-EVALUATE.
029698*
029699 END-F-TERMINATE-BROWSE.
029700     EXIT.
029701     EJECT.
029702*
029703 Y-READ-ONE SECTION.
029710*
029720* This routine attempts to read a record from the file and
029730* sets the availability indicator based on its success.
029740*
029741* This section is performed from the following sections -
029742*      D-FILL-IN-MATCHES
029743*      E-CONTINUE-BROWSE
029744*
029750 Y-010.
029800     EXEC CICS READNEXT
029900               FILE(WS-LITS-FILES-NAME)
030000               RIDFLD(WS-BROWSE-SNAME)
030100               INTO(AN-ACCTREC)
030210               RESP(RESPONSE)
030220               RESP2(REASON-CODE)
030300     END-EXEC.
030310*
030400     EVALUATE RESPONSE
030500*
030600* If either condition occurs, it means a record was read.
030700*
030800         WHEN DFHRESP(NORMAL)
030900         WHEN DFHRESP(DUPKEY)
031000*
031100* But it may not match the full criteria.
031200*
031300             IF  SNAMEDO IN AN-ACCTREC > WS-MAX-SNAME
031400                 SET NONE-AVAILABLE TO TRUE
031500             ELSE
031600                 SET SOME-AVAILABLE TO TRUE
031700                 ADD 1 TO WS-RECORDS-READ
031800             END-IF
031900*
032000* If we have exhausted the file, then there
032100* are obviously no more matches.
032200*
032300         WHEN DFHRESP(ENDFILE)
032400             SET NONE-AVAILABLE TO TRUE
032500*
032600* If any other condition occurs, then a serious problem
032700* has occurred, so the error handler is invoked.
032800*
032900         WHEN OTHER
033000             PERFORM Z-ERROR-HANDLER
033100     END-EVALUATE.
033200*
033210 END-Y-READ-ONE.
033220     EXIT.
033230     EJECT.
033300*
036700 Z-ERROR-HANDLER SECTION.
036710*
036720* This routine invokes the error handler for unexpected
036730* conditions from CICS.
036740*
036741* This section is performed from the following sections -
036742*      NACT05-MAIN
036743*      C-START-BROWSE
036744*      F-TERMINATE-BROWSE
036745*      Y-READ-ONE
036746*
036750 Z-010.
036800     SET WS-ERRH-CORRECT-VERSION TO TRUE.
036900     MOVE RESPONSE            TO WS-ERRH-ERROR.
037000     MOVE REASON-CODE         TO WS-ERRH-REASON.
037100     MOVE EIBFN               TO WS-WORK-EIBFN-X.
037200     MOVE WS-WORK-EIBFN       TO WS-ERRH-CICS-FUNCTION.
037201     MOVE WS-PROGRAM-NAME     TO WS-ERRH-PROGRAM.
037210*
037300     EXEC CICS XCTL
037400               PROGRAM(ABEND-PROGRAM)
037500               COMMAREA(WS-ERRH-ERROR-COMMAREA)
037600               NOHANDLE
037700     END-EXEC.
037710*
037800 Z-020.
037810*
037900* The following will only be executed if the XCTL fails.
038000* The primary reason that might happen is if the error
038100* handling program has become unavailable for some reason.
038200*
038300     EXEC CICS ABEND
038400               ABCODE(WS-LITS-ABEND-ERROR-ABEND)
038500     END-EXEC.
038600*
038700 END-Z-ERROR-HANDLER.
038800     EXIT.
