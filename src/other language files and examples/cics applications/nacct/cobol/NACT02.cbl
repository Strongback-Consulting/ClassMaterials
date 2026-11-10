000100 IDENTIFICATION DIVISION.
000200 PROGRAM-ID. NACT02.
000300 AUTHOR.       A PROGRAMMER.
000310 INSTALLATION. IBM HURSLEY.
000320 DATE-WRITTEN. AUGUST 1999.
000330 DATE-COMPILED.
000340*
000341*-------------------------------------------------------------*
000342*                                                             *
000343*               @BANNER_START@                                *
000344*      nact02.cbl                                             *
000345*      (C) Copyright IBM Corp. 2000. All Rights Reserved.     *
000346*                                                             *
000347* Element of Designing and Programming CICS Applications book *
000348*               @BANNER_END@                                  *
000349*                                                             *
000350*-------------------------------------------------------------*
000351*
000361***************************************************************
000362*
000370*    DESCRIPTION
000396*
000400* This program provides the Create, Read, Update, Delete (CRUD)
000500* functions of the CICS Application Design and Programming
000500* book sample application. It is designed to be LINKed to in
000600* order to allow any number of front-ends to use its services,
000700* e.g., BMS front-end (NACT01), VB, etc.
000800*
000810* However in this application we decided to put the validation
000820* with the presentation logic in order to ensure that the end
000830* user is able to correct errors at the earliest possible time.
000840* This is particularly useful for front-end interfaces where
000850* interactivity is an essential part of their nature, such as
000860* Graphical User Inerfaces (GUIs). The unfortunate consequence
000870* of this decision is that the validation rules must be
000880* implemented in each of the front-end programs, e.g., NACT01,
000890* VB, etc.
000891*
000892***************************************************************
000893*     AMENDMENT HISTORY
000894*
000895*      DATE         AUTHOR          DESCRIPTION
000896*
000897*
000898***************************************************************
000899*     FILES
000900*
000902*     ACCTFIL - WS-LITS-FILES-ACCOUNT
000903*         WRITE
000904*         READ
000905*         READ UPDATE
000906*         REWRITE
000907*         DELETE
000908*
000909*     ACINUSE - WS-LITS-FILES-LOCKING
000910*         DELETE
000911*         WRITE
000912*         REWRITE
000913*         READ UPDATE
000914*
000915***************************************************************
000916*     CICS RESOURCES
000917*
000918***************************************************************
000919*     UTILITIES
000920*
000921***************************************************************
000922*     COPYBOOKS
000923*
000924*     NACWERRH - Working storage layout of the data passed to
000925*                the Error Handler program.
000926*     NACWLITS - Common working storage.
000927*     NACWLOCK - Working storage layout of the Logical Locking,
000928*                In Use record.
000929*     NACWTREC - Working storage layout of the Account record.
000934*     NACCCRUD - Commarea layout of the data passed to this
000935*                program from the calling program.
000936*
000937***************************************************************
000938*
000940 ENVIRONMENT DIVISION.
001000 DATA DIVISION.
001010*
001100 WORKING-STORAGE SECTION.
001101*
001102*    Store eye-catcher details to aid dump reading
001103*
001104 01  WS-DEBUG-DETAILS.
001105        05  FILLER                     PIC X(32)
001106              VALUE 'NACT02-------WORKING STORAGE  '.
001107        05  DEBUG-EYE.
001108              10  DEBUG-TRANID         PIC X(4) VALUE SPACES.
001109              10  DEBUG-TERMID         PIC X(4) VALUE SPACES.
001110              10  DEBUG-TASKNO         PIC 9(7) VALUE ZERO.
001111        05  FILLER                     PIC X    VALUE SPACE.
001112        05  DEBUG-COMMAREA-ADDR  USAGE IS POINTER.
001113*
001114* These fields are used for interfacing with other
001115* programs in the suite.
001116*
001117     05  WS-PROGRAM-NAME               PIC X(8) VALUE SPACES.
001118     05  CRUD-PROGRAM.
001119         10  WS-CRUD-PROGRAM-PREFIX    PIC X(4) VALUE SPACES.
001120         10  FILLER                    PIC X(4) VALUE '02  '.
001130     05  PRINT-PROGRAM.
001140         10  WS-PRINT-PROGRAM-PREFIX   PIC X(4) VALUE SPACES.
001150         10  FILLER                    PIC X(4) VALUE '03  '.
001160     05  ABEND-PROGRAM.
001170         10  WS-ABEND-PROGRAM-PREFIX   PIC X(4) VALUE SPACES.
001180         10  FILLER                    PIC X(4) VALUE '04  '.
001190     05  BROWSE-PROGRAM.
001191         10  WS-BROWSE-PROGRAM-PREFIX  PIC X(4) VALUE SPACES.
001192         10  FILLER                    PIC X(4) VALUE '05  '.
001193*
001200 01  FILLER.
001800*
001900* These fields are used for managing the logical
002000* locking status of the account when needed.
002100*
002200     05  USERID                        PIC X(8).
002300     05  LOCK-ACTIVITY                 PIC X.
002400         88  LOCK-ACTION-OK            VALUE 'S'.
002500         88  LOCK-ACTION-FAILED        VALUE 'F'.
002600         88  LOCK-ACTION-ERROR         VALUE 'E'.
002700     05  LOCK-VALIDITY                 PIC X.
002800         88  LOCK-VALID                VALUE 'Y'.
002900         88  LOCK-INVALID              VALUE 'N'.
003010*
003020* Store of EIBRESP and EIBRESP2 set up in each EXEC CICS statement
003030*
003040     05  RESPONSE                      PIC S9(8) COMP-4 VALUE 0.
003050     05  REASON-CODE                   PIC S9(8) COMP-4 VALUE 0.
003060*
003100* The EIBFN is defined as character but the error interface
003200* expects a numeric value.
003300*
003400     05  WORK-FN                       PIC 9(4) COMP.
003500     05  WORK-FN-X REDEFINES WORK-FN   PIC X(2).
003600*
003700* This is a constant set of values for initializing
003800* the history fields when an account is added. This has been
003900* included to allow for future development of the application,
003950* but is not actively used
003955*
004000     05  PAY-INIT                      PIC X(36) VALUE
004100         '    0.00000000    0.00000000    0.00'.
004200*
004300* The interface to the error handler program is described
004400* in a copy book in order to ensure consistency.
004500*
004510 01  FILLER.
004520     05  FILLER                        PIC X(36) VALUE
004530        '********  NACWERRH COPYBOOK  *******'.
004600     COPY NACWERRH.
004700*
004800* Various values which you might wish to modify are placed in one
004900* copy book in order to make those sorts of changes more easily.
005000*
005010 01  FILLER.
005020     05  FILLER                        PIC X(36) VALUE
005030        '********  NACWLITS COPYBOOK  *******'.
005100     COPY NACWLITS.
005200*
005300* The description of the account locking record is
005400* placed in a copy book.
005500*
005510 01  FILLER.
005520     05  FILLER                        PIC X(36) VALUE
005530        '********  NACWLOCK COPYBOOK  *******'.
005600     COPY NACWLOCK.
005700*
005800* The description of the account record is placed in a copy book.
005900* This area is used to obtain the old record when an update is
006000* requested.
006100*
006110 01  FILLER.
006120     05  FILLER                        PIC X(36) VALUE
006130        '********  NACWTREC COPYBOOK  *******'.
006200 01  OLD-ACCTREC.
006300     COPY NACWTREC.
006400*
006410 01  FILLER.
006420     05  FILLER                        PIC X(36) VALUE
006430         '********  LINKAGE SECTION   ********'.
006440*
006450 EJECT.
006460*
006500* Between pseudo-conversational tasks various data needs to
006600* be saved. This area describes that data.
006700*
006800 LINKAGE SECTION.
006900 01  DFHCOMMAREA.
007000     COPY NACCCRUD.
007100*
007200 EJECT.
007300*
008200 PROCEDURE DIVISION.
008210*
008220 NACT02-MAIN SECTION.
008230*
008240*  Return the name of the current program to WS-PROGRAM-NAME
008250*
008260 NACT02-010.
008300     EXEC CICS ASSIGN
008400               PROGRAM(WS-PROGRAM-NAME)
008500               USERID(USERID)
008600               NOHANDLE
008700     END-EXEC.
008701*
008702     MOVE WS-PROGRAM-NAME TO WS-CRUD-PROGRAM-PREFIX
008703                             WS-PRINT-PROGRAM-PREFIX
008704                             WS-ABEND-PROGRAM-PREFIX
008705                             WS-BROWSE-PROGRAM-PREFIX.
008706*
008712 NACT02-020.
008713*
008720* Establish the abend handler in case unexpected
008730* errors arise, such as program interrupts. The technique
008740* used here assumes a naming convention where the variable
008750* part of the program names is in the 5th and 6th positions.
008760* This allows for changes to the names in case the provided
008770* names conflict with existing applications. Note also that
008780* we also take the opportunity here to obtain the USERID at
008790* the same time since this will be needed if an account lock
008791* needs to be processed.
008792*
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
009802 NACT02-030.
009810*
009811*  Set up values in the eye-catcher
009812*
009813     MOVE EIBTRNID TO DEBUG-TRANID.
009814     MOVE EIBTRMID TO DEBUG-TERMID.
009815     MOVE EIBTASKN TO DEBUG-TASKNO.
009816*
009817*  Set up the commarea address
009818*
009819     SET DEBUG-COMMAREA-ADDR TO ADDRESS OF DFHCOMMAREA.
009820*
009830 NACT02-040.
009900*
010000* Next the passed data is analyzed an validated generating
010100* appropriate error responses where necessary.
010200* Processing is dependant upon the value of the CA-CRUD-FUNCTION
010210* field in the commarea.
010220* Note that an ABEND must be forced if the passed area is too
010300* small to be able to indicate an error in the normal way.
010400*
010500     IF  EIBCALEN > 21
010600         IF  CA-CRUD-CORRECT-VERSION
010700             IF  CA-CRUD-VALID-REQUEST
010800                 PERFORM A-ANALYZE-REQUEST
010810                 EVALUATE TRUE
010820                     WHEN CA-CRUD-REQ-CREATE
010830                         PERFORM B-CREATE-NEW-RECORD
010840                     WHEN CA-CRUD-REQ-READ
010850                         PERFORM C-READ-THE-RECORD
010860                     WHEN CA-CRUD-REQ-UPDATE
010870                         PERFORM D-UPDATE-THE-RECORD
010880                     WHEN CA-CRUD-REQ-DELETE
010890                         PERFORM E-DELETE-THE-RECORD
010891                     WHEN CA-CRUD-REQ-ENQUIRE
010892                         PERFORM C-READ-THE-RECORD
010893                     WHEN CA-CRUD-REQ-LOCK
010894                         PERFORM F-LOCK-ACCOUNT
010895                     WHEN CA-CRUD-REQ-FREE
010896                         PERFORM G-REMOVE-LOCK
010897                 END-EVALUATE
010910             ELSE
011000                 SET CA-CRUD-BAD-FORMAT    TO TRUE
011100                 SET CA-CRUD-REQUEST-ERROR TO TRUE
011200             END-IF
011300         ELSE
011400             SET CA-CRUD-BAD-FORMAT    TO TRUE
011500             SET CA-CRUD-VERSION-ERROR TO TRUE
011600         END-IF
011700     ELSE
011800         IF  EIBCALEN > 11
011900             SET CA-CRUD-BAD-FORMAT   TO TRUE
012000             SET CA-CRUD-LENGTH-ERROR TO TRUE
012100         ELSE
012200             EXEC CICS ABEND
012300                       ABCODE(WS-LITS-ABEND-CRUD-IF)
012400             END-EXEC
012500         END-IF
012600     END-IF.
012601*
012602 NACT02-050.
012603*
012700     EXEC CICS RETURN
012800     END-EXEC.
012801*
012810 END-NACT02-MAIN.
012900     EXIT.
012910     EJECT.
013400*
013500 A-ANALYZE-REQUEST SECTION.
013510*
013520* Once the input parameters have been vetted for correct format,
013530* then standard fields are initialised before deciding what it
013540* is that we need to do.
013550*
013560 A-010.
013600     MOVE ACCTDO IN NACTREC-DATA TO WS-LOCK-INUSE-ACCOUNT.
013700     MOVE USERID                 TO WS-LOCK-INUSE-USERID.
013800     MOVE EIBTRMID               TO WS-LOCK-INUSE-TERMID.
013900     MOVE EIBDATE                TO WS-LOCK-INUSE-DATE.
014000     MOVE EIBTIME                TO WS-LOCK-INUSE-TIME.
014010*
014100     SET CA-CRUD-NO-ERROR TO TRUE.
014200     MOVE CA-CRUD-RESP    TO CA-CRUD-REAS.
014300     MOVE ZERO            TO CA-CRUD-CICS-FUNCTION.
016200*
016210 END-A-ANALYZE-REQUEST.
016300     EXIT.
016310     EJECT.
016320*
016600 B-CREATE-NEW-RECORD SECTION.
016601*
016602* A request to add a record logically requires data vetting.
016603*
016610*
016620 B-010.
016800     IF  ACCTDO IN NACTREC-DATA NOT NUMERIC
016900         SET CA-CRUD-BAD-DATA   TO TRUE
017000         SET CA-CRUD-ACCT-ERROR TO TRUE
017100     END-IF.
017200*
017210 B-020.
017220*
017300* Once the data is vetted, then we must check that the
017400* front-end logic already locked the account.
017500*
017700     PERFORM Y-READ-LOCK.
017710*
017800 B-030.
017810*
017900* If the account lock is owned by this user, then a record can
018000* be added to the file. This requires completing the data record
018100* area with initial values and issuing the CICS WRITE command.
018200*
018300     IF  LOCK-ACTION-OK
018400         MOVE 'N'        TO STATDO   IN NACTREC-DATA
018500         MOVE ' 1000.00' TO LIMITDO  IN NACTREC-DATA
018600         MOVE PAY-INIT   TO PAY-HIST IN NACTREC-DATA (1)
018700                            PAY-HIST IN NACTREC-DATA (2)
018800                            PAY-HIST IN NACTREC-DATA (3)
018900         EXEC CICS WRITE
019000                   FILE(WS-LITS-FILES-ACCOUNT)
019100                   RIDFLD(ACCTDO IN NACTREC-DATA)
019200                   FROM(NACTREC-DATA)
019300                   RESP(CA-CRUD-RESP)
019400                   RESP2(CA-CRUD-REAS)
019500         END-EXEC
019600         MOVE EIBFN    TO WORK-FN-X
019700         MOVE WORK-FN  TO CA-CRUD-CICS-FUNCTION
019800*
019900* Once the record has been added, the lock must be released.
020000*
020100         PERFORM X-DELETE-LOCK-AFTER-READ
020200*
020300* If the account lock is not owned by this user,
020400* then the front-end must be told.
020500*
020600     ELSE
020700         SET CA-CRUD-BAD-LOCK TO TRUE
020800         SET CA-CRUD-IN-USE   TO TRUE
020900     END-IF.
021100*
021110 END-B-CREATE-NEW-RECORD.
021200     EXIT.
021210     EJECT.
021220*
021600 C-READ-THE-RECORD SECTION.
021601*
021602* A Read request implies that some change is going to take place
021603* in the near future, so an account lock must be requested.
021610*
021620 C-010.
021700     IF  CA-CRUD-REQ-READ
021800         PERFORM W-ADD-LOCK
021900*
022000* If the account is already locked by someone else,
022100* then the front-end must be told.
022200*
022300         IF  LOCK-ACTION-FAILED
022400             SET CA-CRUD-BAD-LOCK TO TRUE
022500             SET CA-CRUD-IN-USE   TO TRUE
022600         END-IF
022700     ELSE
022800         SET LOCK-ACTION-OK TO TRUE
022900     END-IF
023000*
023100* If the account lock was successful, then we can get the data.
023200*
023300     IF  LOCK-ACTION-OK
023400         EXEC CICS READ
023500                   FILE(WS-LITS-FILES-ACCOUNT)
023600                   RIDFLD(ACCTDO IN NACTREC-DATA)
023700                   INTO(NACTREC-DATA)
023800                   RESP(CA-CRUD-RESP)
023900                   RESP2(CA-CRUD-REAS)
024000         END-EXEC
024100         MOVE EIBFN    TO WORK-FN-X
024200         MOVE WORK-FN  TO CA-CRUD-CICS-FUNCTION
024300*
024400* If the request to get the data was unsuccessful, we need
024500* to release the lock we just obtained.
024600*
024700         IF (EIBRESP NOT = DFHRESP(NORMAL))
024800         AND CA-CRUD-REQ-READ
024900             PERFORM CA-DELETE-LOCK
025000         END-IF
025100     END-IF.
025204*
025210 END-C-READ-THE-RECORD.
025300     EXIT.
025310     EJECT.
025311*
025312 CA-DELETE-LOCK SECTION.
025313*
025314* This routine attempts to delete a lock record from the special
025315* file set up for this purpose. Depending on the response to the
025316* attempt, further action may need to be taken.
025317*
025318 CA-010.
025319     EXEC CICS DELETE
025320               FILE(WS-LITS-FILES-LOCKING)
025321               RIDFLD(WS-LOCK-INUSE-ACCOUNT)
025323               RESP(RESPONSE)
025324               RESP2(REASON-CODE)
025325     END-EXEC.
025326*
025327     EVALUATE RESPONSE
025328         WHEN DFHRESP(NORMAL)
025329             SET LOCK-ACTION-OK TO TRUE
025330*
025331* If the attempt to delete the lock was unsuccessful for
025332* any reason, then a serious problem has occurred,
025333* so the error handler is invoked.
025334*
025335         WHEN OTHER
025336             SET LOCK-ACTION-ERROR TO TRUE
025337             PERFORM Z-ERROR-HANDLER
025338     END-EVALUATE.
025339*
025340 END-CA-DELETE-LOCK.
025341     EXIT.
025350     EJECT.
025360*
025600 D-UPDATE-THE-RECORD SECTION.
025601*
025610* A request to update a record logically requires data vetting.
025620*
025630 D-010.
025640*
025900* Once the data is vetted, then we must check that the
026000* front-end logic already locked the account.
026100*
026300     PERFORM Y-READ-LOCK.
026400*
026410 D-020.
026420*
026500* If the account lock is owned by this user, then the record
026600* can be updated on the file. This requires READing the data
026700* from the file again to inform CICS and VSAM that we intend
026800* to UPDATE the record before actually changing the data in
026900* the file via the CICS REWRITE command.
027000*
027100     IF  LOCK-ACTION-OK
027200         EXEC CICS READ UPDATE
027300                   FILE(WS-LITS-FILES-ACCOUNT)
027400                   RIDFLD(ACCTDO IN NACTREC-DATA)
027500                   INTO(OLD-ACCTREC)
027600                   RESP(CA-CRUD-RESP)
027700                   RESP2(CA-CRUD-REAS)
027800         END-EXEC
027900         MOVE EIBFN    TO WORK-FN-X
028000         MOVE WORK-FN  TO CA-CRUD-CICS-FUNCTION
028100         IF  EIBRESP = DFHRESP(NORMAL)
028200             MOVE STATDO   IN OLD-ACCTREC
028300                  TO  STATDO   IN NACTREC-DATA
028400             MOVE LIMITDO  IN OLD-ACCTREC
028500                  TO  LIMITDO  IN NACTREC-DATA
028600             MOVE PAY-HIST IN OLD-ACCTREC (1)
028700                  TO  PAY-HIST IN NACTREC-DATA (1)
028800             MOVE PAY-HIST IN OLD-ACCTREC (2)
028900                  TO  PAY-HIST IN NACTREC-DATA (2)
029000             MOVE PAY-HIST IN OLD-ACCTREC (3)
029100                  TO  PAY-HIST IN NACTREC-DATA (3)
029200             EXEC CICS REWRITE
029300                       FILE(WS-LITS-FILES-ACCOUNT)
029400                       FROM(NACTREC-DATA)
029500                       RESP(CA-CRUD-RESP)
029600                       RESP2(CA-CRUD-REAS)
029700             END-EXEC
029800             MOVE EIBFN    TO WORK-FN-X
029900             MOVE WORK-FN  TO CA-CRUD-CICS-FUNCTION
030000         END-IF
030100*
030200* Once the record has been updated, the lock must be released.
030300*
030400         PERFORM X-DELETE-LOCK-AFTER-READ
030500*
030600* If the account lock is not owned by this user,
030700* then the front-end must be told.
030800*
030900     ELSE
031000         SET CA-CRUD-BAD-LOCK   TO TRUE
031100         SET CA-CRUD-NOT-LOCKED TO TRUE
031200     END-IF.
031400*
031410 END-D-UPDATE-THE-RECORD.
031500     EXIT.
031510     EJECT.
031520*
031900 E-DELETE-THE-RECORD SECTION.
031910*
031920* A request to delete a record requires the front-end logic
031930* to have already locked the account.
031940*
031950 E-010.
032000     PERFORM Y-READ-LOCK.
032100*
032200* If the account lock is owned by this user, then the record
032300* can be deleted from the file. This is performed via the
032400* CICS DELETE command.
032500*
032600     IF  LOCK-ACTION-OK
032700         EXEC CICS DELETE
032800                   FILE(WS-LITS-FILES-ACCOUNT)
032900                   RIDFLD(ACCTDO IN NACTREC-DATA)
033000                   RESP(CA-CRUD-RESP)
033100                   RESP2(CA-CRUD-REAS)
033200         END-EXEC
033300         MOVE EIBFN    TO WORK-FN-X
033400         MOVE WORK-FN  TO CA-CRUD-CICS-FUNCTION
033500*
033600* Once the record has been deleted, the lock must be released.
033700*
033800         PERFORM X-DELETE-LOCK-AFTER-READ
033900*
034000* If the account lock is not owned by this user,
034100* then the front-end must be told.
034200*
034300     ELSE
034400         SET CA-CRUD-BAD-LOCK   TO TRUE
034500         SET CA-CRUD-NOT-LOCKED TO TRUE
034600     END-IF.
034700*
034710 END-E-DELETE-THE-RECORD.
034800     EXIT.
034810     EJECT.
034820*
035200 F-LOCK-ACCOUNT SECTION.
035210*
035220* A request to lock an account requires that
035230* the account number has a valid format.
035240*
035250 F-010.
035300     IF  ACCTDO IN NACTREC-DATA NOT NUMERIC
035400         SET CA-CRUD-BAD-DATA   TO TRUE
035500         SET CA-CRUD-ACCT-ERROR TO TRUE
035600*
035700* If the the account number has a valid format,
035800* then we must lock the account.
035900*
036000     ELSE
036100         PERFORM W-ADD-LOCK
036200*
036300* If the account is already locked by someone else,
036400* then the front-end must be told.
036500*
036600         IF  LOCK-ACTION-FAILED
036700             SET CA-CRUD-BAD-LOCK TO TRUE
036800             SET CA-CRUD-IN-USE   TO TRUE
036900         END-IF
037000     END-IF.
037100*
037110 END-F-LOCK-ACCOUNT.
037200     EXIT.
037210     EJECT.
037220*
037600 G-REMOVE-LOCK SECTION.
037610*
037620* A request to free an account requires that the
037630* lock is owned by this user, so we need find it.
037640*
037650 G-010.
037700     PERFORM Y-READ-LOCK.
037800*
037900* If the lock is owned by this user, we need to release it.
038000*
038100     IF  LOCK-ACTION-OK
038200         PERFORM X-DELETE-LOCK-AFTER-READ
038300*
038400* If the lock is not owned by this user,
038500* then the front-end must be told.
038600*
038700     ELSE
038800         SET CA-CRUD-BAD-LOCK   TO TRUE
038900         SET CA-CRUD-NOT-LOCKED TO TRUE
039000     END-IF.
039100*
039110 END-G-REMOVE-LOCK.
039200     EXIT.
039210     EJECT.
040800*
041300 W-ADD-LOCK SECTION.
041310*
041320* This routine attempts to add a lock record to the special
041330* file set up for this purpose. Depending on the response
041340* to the attempt, further action may need to be taken.
041350*
041351* This section is performed from the following sections -
041352*      C-READ-THE-RECORD
041353*      F-LOCK-ACCOUNT
041354*
041360 W-010.
041400     EXEC CICS WRITE
041500               FILE(WS-LITS-FILES-LOCKING)
041600               RIDFLD(WS-LOCK-INUSE-ACCOUNT)
041700               FROM(WS-LOCK-INUSE-REC)
041810               RESP(RESPONSE)
041820               RESP2(REASON-CODE)
041900     END-EXEC.
041910*
042000     EVALUATE RESPONSE
042100*
042200* If the attempt to add the lock was successful,
042300* no further action is required.
042400*
042500         WHEN DFHRESP(NORMAL)
042600             SET LOCK-ACTION-OK TO TRUE
042700*
042800* If the attempt to add the lock was unsuccessful due to a
042900* duplicate being found, then an attempt to read the lock
043000* data is required. If that is successful, it means that the
043100* user already owns the lock, so the time of the lock needs
043200* to be updated.
043300*
043400         WHEN DFHRESP(DUPREC)
043500             PERFORM Y-READ-LOCK
043600             IF  LOCK-ACTION-OK
043700                 PERFORM WA-UPDATE-LOCK
043800             ELSE
043900                 SET LOCK-ACTION-FAILED TO TRUE
044000             END-IF
044100*
044200* If the attempt to add the lock was unsuccessful due to
044300* any other reason, then a serious problem has occurred,
044400* so the error handler is invoked.
044500*
044600         WHEN OTHER
044700             SET LOCK-ACTION-ERROR TO TRUE
044800             PERFORM Z-ERROR-HANDLER
044900     END-EVALUATE.
045000*
045100 END-W-ADD-LOCK.
047600     EXIT.
047700     EJECT.
047710*
047720 WA-UPDATE-LOCK SECTION.
047730*
047740* This routine allows for the fact that a lock may have existed
047750* but has now expired or requires that the time of the lock be
047760* changed. It performs this via the REWRITE command which
047770* requires that a previous READ with the UPDATE option was
047780* successful.
047790*
047791 WA-010.
047792     MOVE USERID   TO WS-LOCK-INUSE-USERID.
047793     MOVE EIBTRMID TO WS-LOCK-INUSE-TERMID.
047794     MOVE EIBDATE  TO WS-LOCK-INUSE-DATE.
047795     MOVE EIBTIME  TO WS-LOCK-INUSE-TIME.
047796*
047797     EXEC CICS REWRITE
047798               FILE(WS-LITS-FILES-LOCKING)
047799               FROM(WS-LOCK-INUSE-REC)
047801               RESP(RESPONSE)
047802               RESP2(REASON-CODE)
047803     END-EXEC.
047804*
047810     EVALUATE RESPONSE
047820         WHEN DFHRESP(NORMAL)
047830             SET LOCK-ACTION-OK TO TRUE
047840*
047850* If the attempt to update the lock was unsuccessful due
047860* to any reason, then a serious problem has occurred,
047870* so the error handler is invoked.
047880*
047890         WHEN OTHER
047891             SET LOCK-ACTION-ERROR TO TRUE
047892             PERFORM Z-ERROR-HANDLER
047893     END-EVALUATE.
047894*
047895 END-WA-UPDATE-LOCK.
047896     EXIT.
047897     EJECT.
047900*
048100 X-DELETE-LOCK-AFTER-READ SECTION.
048101*
048110* This routine attempts to delete a lock record from the special
048120* file set up for this purpose after the lock has already been
048130* read (with the UPDATE option). Depending on the response to
048140* the attempt, further action may need to be taken.
048150*
048151* This section is performed from the following sections -
048152*      B-CREATE-NEW-RECORD
048153*      D-UPDATE-THE-RECORD
048154*      E-DELETE-THE-RECORD
048155*      G-REMOVE-LOCK
048156*
048160 X-010.
048200     EXEC CICS DELETE
048300               FILE(WS-LITS-FILES-LOCKING)
048410               RESP(RESPONSE)
048420               RESP2(REASON-CODE)
048500     END-EXEC.
048510*
048600     EVALUATE RESPONSE
048700         WHEN DFHRESP(NORMAL)
048800             SET LOCK-ACTION-OK TO TRUE
048900*
049000* If the attempt to delete the lock was unsuccessful for
049100* any reason, then a serious problem has occurred,
049200* so the error handler is invoked.
049300*
049400         WHEN OTHER
049500             SET LOCK-ACTION-ERROR TO TRUE
049600             PERFORM Z-ERROR-HANDLER
049700     END-EVALUATE.
049800*
049810 END-X-DELETE-LOCK-AFTER-READ.
049900     EXIT.
049910     EJECT.
049920*
050700 Y-READ-LOCK SECTION.
050710*
050720* This routine attempts to read a lock record from the
050730* special file set up for this purpose. It uses the
050740* UPDATE option since it anticipates that the lock will
050750* either need to be subsequently updated or deleted.
050760* Depending on the response to the attempt, further
050770* action may need to be taken.
050780*
050781* This section is performed from the following sections -
050782*      B-CREATE-NEW-RECORD
050783*      D-UPDATE-THE-RECORD
050784*      E-DELETE-THE-RECORD
050785*      G-REMOVE-LOCK
050786*      W-ADD-LOCK
050788*
050790 Y-010.
050800     EXEC CICS READ UPDATE
050900               FILE(WS-LITS-FILES-LOCKING)
051000               RIDFLD(WS-LOCK-INUSE-ACCOUNT)
051100               INTO(WS-LOCK-INUSE-REC)
051210               RESP(RESPONSE)
051220               RESP2(REASON-CODE)
051300     END-EXEC.
051310*
051400     EVALUATE RESPONSE
051500*
051600* Simply because the lock exists does not mean that it is
051700* owned by this user. That must also be checked.
051800*
051900         WHEN DFHRESP(NORMAL)
052000             PERFORM YA-CHECK-LOCK-DATA
052100             IF  LOCK-VALID
052200                 SET LOCK-ACTION-OK     TO TRUE
052300             ELSE
052400                 SET LOCK-ACTION-FAILED TO TRUE
052500             END-IF
052600*
052700* If the attempt to read the lock was unsuccessful due to it
052800* not being found, then this user does not own it.
052900*
053000         WHEN DFHRESP(NOTFND)
053100             SET LOCK-ACTION-FAILED TO TRUE
053200*
053300* If the attempt to read the lock was unsuccessful due to
053400* any other reason, then a serious problem has occurred,
053500* so the error handler is invoked.
053600*
053700         WHEN OTHER
053800             SET LOCK-ACTION-ERROR TO TRUE
053900             PERFORM Z-ERROR-HANDLER
054000     END-EVALUATE.
054100*
054110 END-Y-READ-LOCK.
054200     EXIT.
054210     EJECT.
054211*
054212 YA-CHECK-LOCK-DATA SECTION.
054213*
054214* This routine checks that a lock found on the special file
054215* set up for this purpose is either owned by the current user
054216* or, if owned by someone else, it has expired. It checks for
054217* the second possibility by adding the time limit to the time
054218* in the lcok. (It allows for rolling over midnight.) If as a
054219* result of adding in the time limit, the date in the lock is
054220* greater than the current date, or if the dates are the same
054221* but the time in the lock is earlier than the current time,
054222* then the lock is expired and can be assigned to this user.
054223*
054224 YA-010.
054225     IF  USERID   = WS-LOCK-INUSE-USERID
054226     AND EIBTRMID = WS-LOCK-INUSE-TERMID
054227         SET LOCK-VALID TO TRUE
054228     ELSE
054229         ADD WS-LITS-USE-LIMIT TO WS-LOCK-INUSE-TIME
054230         IF  WS-LOCK-INUSE-TIME > 236000
054231             ADD 1 TO WS-LOCK-INUSE-DATE
054232             SUBTRACT 236000 FROM WS-LOCK-INUSE-TIME
054233         END-IF
054234         IF  WS-LOCK-INUSE-DATE > EIBDATE
054235         OR (WS-LOCK-INUSE-DATE = EIBDATE
054236             AND WS-LOCK-INUSE-TIME < EIBTIME)
054237             SET LOCK-VALID   TO TRUE
054238         ELSE
054239             SET LOCK-INVALID TO TRUE
054240         END-IF
054241     END-IF.
054242*
054243 END-YA-CHECK-LOCK-DATA.
054244     EXIT.
054245     EJECT.
057220*
063000 Z-ERROR-HANDLER SECTION.
063010*
063020* This routine invokes the error handler for unexpected
063030* conditions from CICS.
063040*
063041* This section is performed from the following sections -
063042*      CA-DELETE-LOCK
063043*      W-ADD-LOCK
063044*      WA-UPDATE-LOCK
063045*      X-DELETE-LOCK-AFTER-READ
063046*      Y-READ-LOCK
063048*
063050 Z-010.
063100     SET WS-ERRH-CORRECT-VERSION TO TRUE.
063200     MOVE RESPONSE               TO WS-ERRH-ERROR.
063300     MOVE REASON-CODE            TO WS-ERRH-REASON.
063400     MOVE EIBFN                  TO WORK-FN-X.
063500     MOVE WORK-FN                TO WS-ERRH-CICS-FUNCTION.
063501     MOVE WS-PROGRAM-NAME        TO WS-ERRH-PROGRAM.
063510*
063600     EXEC CICS XCTL
063700               PROGRAM(ABEND-PROGRAM)
063800               COMMAREA(WS-ERRH-ERROR-COMMAREA)
063900               NOHANDLE
064000     END-EXEC.
064100*
064200* The following will only be executed if the XCTL fails.
064300* The primary reason that might happen is if the error
064400* handling program has become unavailable for some reason.
064500*
064600     EXEC CICS ABEND
064700               ABCODE(WS-LITS-ABEND-ERROR-ABEND)
064800     END-EXEC.
064900*
065000 END-Z-ERROR-HANDLER.
065100     EXIT.
