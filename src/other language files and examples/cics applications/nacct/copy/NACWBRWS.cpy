000100*--------------------------------------------------------------*
000110*                                                              *
000120*               @BANNER_START@                                 *
000130*      nacwbrws.cpy                                            *
000131*      (C) Copyright IBM Corp. 2000. All Rights Reserved.      *
000132*                                                              *
000133* Element of Designing and Programming CICS Applications book  *
000194*               @BANNER_END@                                   *
000195*                                                              *
000196*--------------------------------------------------------------*
000197*
000210* The interface to the Browse program is described in a copy book
000300* in order to ensure consistency. The values in this area designed
000400* to be in character format to enable ease of translation when the
000500* program is invoked from a remote system which uses a different
000600* encoding scheme (e.g., ASCII) than the EBCDIC of the mainframe.
000700*
000720* This is the working storage version of the interface to the
000730* Browse program.
000740*
000800     05  WS-BRWS-COMMAREA.
000900*
001000* This is an "Eyecatcher" and integrity check field.
001100*
001200         10  WS-BRWS-VERSION             PIC XXX VALUE SPACES.
001300             88  WS-BRWS-CORRECT-VERSION VALUE 'V1A'.
001400*
001500* Only two functions are provided by the Browse program:
001600* initiation of a Browse and Continuation of a previously
001700* initiated browse.
001800*
001900         10  WS-BRWS-FUNCTION            PIC X VALUE SPACE.
002000             88  WS-BRWS-REQ-BROWSE      VALUE 'B'.
002100             88  WS-BRWS-REQ-CONTINUE    VALUE 'C'.
002200             88  WS-BRWS-VALID-REQUEST   VALUE 'B' 'C'.
002300*
002400* The response field is designed to conform to the CICS EIBRESP
002500* characteristics which always contains a numeric value. There
002600* are also architected values to indicate errors detected by the
002700* Browse program itself. If there was an interface error, this
002800* contains a special value of 'FRMT'.
002900*
003000         10  WS-BRWS-RESP                PIC 9(4) VALUE ZERO.
003100         10  WS-BRWS-RESP-X REDEFINES WS-BRWS-RESP
003200                                         PIC X(4).
003300             88  WS-BRWS-NO-ERROR        VALUE '0000'.
003400             88  WS-BRWS-BAD-FORMAT      VALUE 'FRMT'.
003500*
003600* The reason field is designed to conform to the CICS EIBRESP2
003700* characteristics which always contains a numeric value. There
003800* are also architected values to indicate errors detected by the
003900* Browse program itself. If there was an interface error, this
004000* contains 'VERE' for Version Error, 'LENE' for Length Error (if
004100* possible), 'REQE' for Request Error, 'LIME' for Limit Error or
004200* 'MORE' for More Error (only occurs for a continuation request).
004300*
004400         10  WS-BRWS-REAS                PIC 9(4) VALUE ZERO.
004500         10  WS-BRWS-REAS-X REDEFINES WS-BRWS-REAS
004600                                         PIC X(4).
004700             88  WS-BRWS-VERSION-ERROR   VALUE 'VERE'.
004800             88  WS-BRWS-LENGTH-ERROR    VALUE 'LENE'.
004900             88  WS-BRWS-REQUEST-ERROR   VALUE 'REQE'.
005000             88  WS-BRWS-LIMIT-ERROR     VALUE 'LIME'.
005100             88  WS-BRWS-MORE-ERROR      VALUE 'MORE'.
005200*
005300* If the response contains a numeric value, this contains the
005400* character representation of the EIBFN value giving rise to
005500* the exception condition.
005600*
005700         10  WS-BRWS-CICS-FUNCTION       PIC 9(5) VALUE ZERO.
005800         10  WS-BRWS-CICS-FUNCTION-X
005810                REDEFINES WS-BRWS-CICS-FUNCTION
005900                                         PIC X(5).
006000*
006100* In order to prevent excessive searches, the caller must specify
006200* the maximum number of matches (s)he is prepared to handle.
006300* Also because a COMMAREA is limited to a maximum of approximately
006400* 32,000 bytes, the maximum limit has been set at 80.
006500*
006600         10  WS-BRWS-LIMIT-TO-GET        PIC 9(4) VALUE ZERO.
006700         10  WS-BRWS-LIMIT-TO-GET-X REDEFINES WS-BRWS-LIMIT-TO-GET
006800                                         PIC X(4).
006900*
007000* The Browse program indicates the number of matches found.
007100* The range is zero to the limit.
007200*
007300         10  WS-BRWS-FOUND               PIC 9(4) VALUE ZERO.
007400             88  WS-BRWS-NONE-FOUND      VALUE ZERO.
007500*
007600* After satisfying the limit, the Browse program will place
007700* either '0000' in here if there are no more records satisfying
007800* the search criteria or a number if there are more. On a
007900* continuation request this number must be returned to the Browse
008000* program since it is used to reposition the request.
008100*
008200         10  WS-BRWS-MORE                PIC 9(4) VALUE ZERO.
008300         10  WS-BRWS-MORE-X REDEFINES WS-BRWS-MORE
008310                                         PIC X(4).
008400             88  WS-BRWS-NO-MORE         VALUE '0000'.
008500*
008600* The records found on file for a match. Input is in the
008700* surname and first name fields of the first Entry.
008800*
008900         10  WS-BRWS-MATCHES.
009000             15  WS-BRWS-ENTRY           OCCURS 80.
009100*
009200* The description of the account record is placed in a copy book.
009300*
009400             COPY NACWTREC.
