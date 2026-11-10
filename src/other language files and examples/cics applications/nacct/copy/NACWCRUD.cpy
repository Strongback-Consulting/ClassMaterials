000100*--------------------------------------------------------------*
000110*                                                              *
000120*               @BANNER_START@                                 *
000130*      nacwcrud.cpy                                            *
000131*      (C) Copyright IBM Corp. 2000. All Rights Reserved.      *
000132*                                                              *
000133* Element of Designing and Programming CICS Applications book  *
000194*               @BANNER_END@                                   *
000195*                                                              *
000196*--------------------------------------------------------------*
000197*
000210* The interface to the CRUD program is described in a copy book
000300* in order to ensure correctness. The values in this area designed
000400* to be in character format to enable ease of translation when the
000500* program is invoked from a remote system which uses a different
000600* encoding scheme (e.g., ASCII) than the EBCDIC of the mainframe.
000700*
000710* This is the working storage version of the interface to the
000720* CRUD (Create, read, update and delete) program.
000730*
000800     05  WS-CRUD-COMMAREA.
000900*
001000* This is an "Eyecatcher" and integrity check field.
001100*
001200         10  WS-CRUD-VER                 PIC XXX VALUE SPACES.
001300             88  WS-CRUD-CORRECT-VERSION VALUE 'V1A'.
001400*
001500* Several functions are provided by the CRUD program: Create an
001600* account, Read (with locking) an account, Update an account
001700* (releasing the lock), Delete an account (releasing the lock),
001800* Enquire an account (read without locking), Lock an account
001900* (in anticipation of a Create) and Free (unlock) an account
002000* (in the event of abandoning a previous request which caused
002100* the account to be locked).
002200*
002300         10  WS-CRUD-FUNCTION            PIC X   VALUE SPACES.
002400             88  WS-CRUD-REQ-CREATE      VALUE 'C'.
002500             88  WS-CRUD-REQ-READ        VALUE 'R'.
002600             88  WS-CRUD-REQ-UPDATE      VALUE 'U'.
002700             88  WS-CRUD-REQ-DELETE      VALUE 'D'.
002800             88  WS-CRUD-REQ-ENQUIRE     VALUE 'E'.
002900             88  WS-CRUD-REQ-LOCK        VALUE 'L'.
003000             88  WS-CRUD-REQ-FREE        VALUE 'F'.
003100             88  WS-CRUD-VALID-REQUEST   VALUE 'C' 'R' 'U' 'D'
003200                                               'E' 'L' 'F'.
003300*
003400* The response field is designed to conform to the CICS EIBRESP
003500* characteristics which always contains a numeric value. There
003600* are also architected values to indicate errors detected by the
003700* CRUD program itself. If there was an interface error, this
003800* contains a special value of 'FRMT', if there was a data error,
003900* this contains a special value of 'DATA' and if the action
004000* requested for an account is invalid, this contains a special
004100* value of 'LOCK'.
004200*
004300         10  WS-CRUD-RESP                PIC 9(4) VALUE ZERO.
004400         10  WS-CRUD-RESP-X REDEFINES WS-CRUD-RESP
004500                                         PIC X(4).
004600             88  WS-CRUD-NO-ERROR        VALUE '0000'.
004700             88  WS-CRUD-BAD-FORMAT      VALUE 'FRMT'.
004800             88  WS-CRUD-BAD-DATA        VALUE 'DATA'.
004900             88  WS-CRUD-BAD-LOCK        VALUE 'LOCK'.
005000*
005100* The reason field is designed to conform to the CICS EIBRESP2
005200* characteristics which always contains a numeric value. There
005300* are also architected values to indicate errors detected by the
005400* CRUD program itself. If there was an interface error, this
005500* contains 'VERE' for Version Error, 'LENE' for Length Error (if
005600* possible) or 'REQE' for Request Error. If there was a data
005700* error, this contains the code of the field in error (as
005800* initially implemented only 'ACCT' can occur here). If there
005900* was a locking error, this contains 'LOKD' if a request to Read
006000* a record already locked was made or 'NOTL' if a request to
006100* Update or Delete request was made when no lock was in place.
006200*
006300         10  WS-CRUD-REAS                PIC 9(4) VALUE ZERO.
006400         10  WS-CRUD-REAS-X REDEFINES WS-CRUD-REAS
006500                                         PIC X(4).
006600             88  WS-CRUD-VERSION-ERROR   VALUE 'VERE'.
006700             88  WS-CRUD-LENGTH-ERROR    VALUE 'LENE'.
006800             88  WS-CRUD-REQUEST-ERROR   VALUE 'REQE'.
006900             88  WS-CRUD-ACCT-ERROR      VALUE 'ACCT'.
007000             88  WS-CRUD-IN-USE          VALUE 'LOKD'.
007100             88  WS-CRUD-NOT-LOCKED      VALUE 'NOTL'.
007200*
007300* If the response contains a numeric value, this contains the
007400* character representation of the EIBFN value giving rise to
007500* the exception condition.
007600*
007700         10  WS-CRUD-CICS-FUNCTION       PIC 9(5) VALUE ZERO.
007800         10  WS-CRUD-CICS-FUNCTION-X
007810                 REDEFINES WS-CRUD-CICS-FUNCTION
007900                                         PIC X(5).
008000*
008100* The description of the account record is placed in a copy book.
008200*
008300         10  NACTREC-DATA.
008400             COPY NACWTREC.
