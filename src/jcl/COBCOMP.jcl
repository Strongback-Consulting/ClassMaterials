//COBCOMP  JOB CLASS=A,MSGCLASS=A,NOTIFY=&SYSUID,MSGLEVEL=(1,1)
//*--------------------------------------------------------------------
//* COBCOMP - Compile and link one COBOL program
//*
//* Copyright (c) 2026 Strongback Consulting
//* SPDX-License-Identifier: MIT
//* Released under the MIT License; see LICENSE at the root of the
//* ClassMaterials repository.
//*--------------------------------------------------------------------
//*
//* Compiles the member named by MEM from &SYSUID..CLASS.COBOL and
//* links it into &SYSUID..CLASS.LOAD under the same name. &SYSUID is
//* your TSO id, so the data-set names need no editing; to compile a
//* different program, change MEM and nothing else.
//*
//* LIST, MAP, XREF and SOURCE put the full listing - source lines,
//* data map, cross-reference and any diagnostics - in the job's spool,
//* where the remote compile lab reads them.
//*
//* IGYWCL is the compile-and-link procedure Enterprise COBOL installs.
//* If your site renamed it or keeps it in its own procedure library,
//* change the EXEC statement or add a JCLLIB statement.
//*
//* The step should end with return code 0, or 4 for warnings only.
//*--------------------------------------------------------------------
//         SET MEM=COBLOAN
//*
//COMPLINK EXEC IGYWCL,
//             PARM.COBOL='LIST,MAP,XREF,SOURCE'
//COBOL.SYSIN  DD DISP=SHR,DSN=&SYSUID..CLASS.COBOL(&MEM)
//LKED.SYSLMOD DD DISP=SHR,DSN=&SYSUID..CLASS.LOAD(&MEM)
