000100*--------------------------------------------------------------*
000110*                                                              *
000120*               @BANNER_START@                                 *
000130*      nacwlock.cpy                                            *
000131*      (C) Copyright IBM Corp. 2000. All Rights Reserved.      *
000132*                                                              *
000133* Element of Designing and Programming CICS Applications book  *
000194*               @BANNER_END@                                   *
000195*                                                              *
000196*--------------------------------------------------------------*
000197*
000210* The description of the logical locking ('in use') record is
000300* placed in a copy book as a matter of convenience. It is only
000400* used in the CRUD program but could, theoretically, be used in
000500* some other program.
000600*
000700     05  WS-LOCK-INUSE-REC.
000800*
000900* The account is Primary Record Identifier.
001000*
001100         10  WS-LOCK-INUSE-ACCOUNT       PIC X(5) VALUE SPACES.
001200*
001300* The logical 'owner' of the account lock is a combination of the
001400* USERID (obtained via an ASSIGN command) and the terminal
001500* (obtained from the EIBTRMID field) since neither on its own
001600* can be guaranteed to be unique. First, CICS allows the same
001700* USERID to be used at multiple terminals. Second, the terminal
001800* identifier may not be relevant if entry to the system is via
001900* the CICS Client technology or Distributed Program Link (DPL).
002000*
002100         10  WS-LOCK-INUSE-OWNER.
002200             15  WS-LOCK-INUSE-USERID    PIC X(8) VALUE SPACES.
002300             15  WS-LOCK-INUSE-TERMID    PIC X(4) VALUE SPACES.
002400*
002500* The lock has a limited lifetime. When it is created it is
002600* timestamped from the EIBDATE and EIBTIME fields.
002700*
002800         10  WS-LOCK-INUSE-DATE          PIC S9(7) COMP-3 VALUE 0.
002900         10  WS-LOCK-INUSE-TIME          PIC S9(7) COMP-3 VALUE 0.
