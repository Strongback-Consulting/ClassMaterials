//EBUDCMP  JOB CLASS=A,MSGCLASS=A,NOTIFY=&SYSUID,MSGLEVEL=(1,1)
//*--------------------------------------------------------------------
//* EBUDCMP - Compile and link EBUD00-EBUD03 for debugging
//*
//* Copyright (c) 2026 Strongback Consulting
//* SPDX-License-Identifier: MIT
//* Released under the MIT License; see LICENSE at the root of the
//* ClassMaterials repository.
//*--------------------------------------------------------------------
//*
//* Builds the four programs the debugger and coverage labs run, each
//* as its own load module in &SYSUID..CLASS.LOAD. EBUD00 calls EBUD01,
//* which calls EBUD02 and EBUD03 - all dynamically, so each one has to
//* be a separate member. Source comes from &SYSUID..CLASS.COBOL, where
//* the mvs-datasets lab uploads src/cobol. Run them with EBUDRUN.jcl.
//*
//* Every program is compiled with TEST, which keeps the debug data and
//* source with the load module so the debugger and code coverage can
//* map execution back to source lines; LIST, MAP, XREF and SOURCE for
//* the listing; and OPT(0) so statements run in source order.
//*
//* IGYWCL is the compile-and-link procedure Enterprise COBOL installs.
//* If your site renamed it or keeps it in its own procedure library,
//* change the EXEC statements or add a JCLLIB statement. EBUD03 copies
//* CEEIGZCT from the Language Environment sample library, shown here
//* as CEE.SCEESAMP; change that if your site uses another prefix.
//*
//* Each step should end with return code 0 (4 means warnings only).
//*--------------------------------------------------------------------
//         SET SRC=&SYSUID..CLASS.COBOL
//         SET LOAD=&SYSUID..CLASS.LOAD
//*
//EBUD00   EXEC IGYWCL,
//             PARM.COBOL='TEST,LIST,MAP,XREF,SOURCE,OPT(0)'
//COBOL.SYSIN  DD DISP=SHR,DSN=&SRC(EBUD00)
//LKED.SYSLMOD DD DISP=SHR,DSN=&LOAD(EBUD00)
//*
//EBUD01   EXEC IGYWCL,
//             PARM.COBOL='TEST,LIST,MAP,XREF,SOURCE,OPT(0)'
//COBOL.SYSIN  DD DISP=SHR,DSN=&SRC(EBUD01)
//LKED.SYSLMOD DD DISP=SHR,DSN=&LOAD(EBUD01)
//*
//EBUD02   EXEC IGYWCL,
//             PARM.COBOL='TEST,LIST,MAP,XREF,SOURCE,OPT(0)'
//COBOL.SYSIN  DD DISP=SHR,DSN=&SRC(EBUD02)
//LKED.SYSLMOD DD DISP=SHR,DSN=&LOAD(EBUD02)
//*
//EBUD03   EXEC IGYWCL,
//             PARM.COBOL='TEST,LIST,MAP,XREF,SOURCE,OPT(0)'
//COBOL.SYSIN  DD DISP=SHR,DSN=&SRC(EBUD03)
//COBOL.SYSLIB DD DISP=SHR,DSN=CEE.SCEESAMP
//LKED.SYSLMOD DD DISP=SHR,DSN=&LOAD(EBUD03)
