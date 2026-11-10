//IDIVPCOB JOB  MSGCLASS=H,MSGLEVEL=(1,1),TIME=(,4),
//  REGION=0M,COND=(16,LT)
//*
//********************************************************************
//*   Licensed Materials - Property of IBM                           *
//*                                                                  *
//*   5655-Q41                                                       *
//*                                                                  *
//*   Copyright IBM Corp. 2000, 2017. All rights reserved.           *
//*   Copyright HCL Technologies Ltd. 2017. All rights reserved.     *
//*                                                                  *
//*   US Government Users Restricted Rights - Use,                   *
//*   duplication or disclosure restricted by GSA ADP                *
//*   Schedule Contract with IBM Corp.                               *
//*                                                                  *
//********************************************************************
//********************************************************************
//*                                                                  *
//* IDIVPCOB JOB                                                     *
//*                                                                  *
//* THIS JCL WILL VERIFY THE INSTALLATION OF FAULT ANALYZER USING    *
//* A COBOL PROGRAM                                                  *
//*                                                                  *
//*  CAUTION: THIS IS NEITHER A JCL PROCEDURE NOR A COMPLETE JOB.    *
//*  BEFORE USING THIS JOB, YOU WILL HAVE TO MAKE THE FOLLOWING      *
//*  MODIFICATIONS:                                                  *
//*                                                                  *
//*  1. CHANGE THE JOB CARD TO MEET YOUR SYSTEM REQUIREMENTS         *
//*  2. CHANGE ECOBOL.V610.SIGYPROC ON THE JCLLIB STATEMENT TO THE   *
//*     NAME OF YOUR COBOL PROCEDURE LIBRARY.                        *
//*  3. REVIEW THE COBOL LISTINGS DATA SET ALLOCATION AND REFERENCE  *
//*     ON THE //COBOL.SYSPRINT AND //GO.IDILCOB DD STATEMENTS       *
//*     RESPECTIVELY.                                                *
//*  4. USE A REGION OF AT LEAST 200M.                               *
//*                                                                  *
//********************************************************************
//         JCLLIB ORDER=(IGY640.SIGYPROC)
//*------------------------------------------------------------------
//* Allocate a temporary dataset to hold Compiler Listing:
//*------------------------------------------------------------------
// SET LISTING=&SYSUID..TEMPFILE.IVP.COBOL.LISTING
//TEMPLIST EXEC PGM=IEFBR14
//LISTING  DD DSN=&LISTING,DISP=(MOD,PASS),
//         SPACE=(TRK,(5,5,2),RLSE),
//         RECFM=FBA,LRECL=133,DSNTYPE=LIBRARY
//*------------------------------------------------------------------
//* Compile, Link & Run:
//*------------------------------------------------------------------
//CBLRUN   EXEC IGYWCLG,LNGPRFX='IGY640',GOPGM=IDISCBL1,
// PARM.COBOL='LIST,NOOFFSET,OPT(0),MAP,SOURCE,XREF(SHORT),TEST'
//COBOL.SYSIN DD DATA,DLM='##'
       IDENTIFICATION DIVISION.
       PROGRAM-ID. IDISCBL1
       ENVIRONMENT DIVISION.
       INPUT-OUTPUT SECTION.
       FILE-CONTROL.
       DATA DIVISION.
       FILE SECTION.

       WORKING-STORAGE SECTION.
       01  FILLER                 PIC X(20)  VALUE 'WORKING-STORAGE'.
       01  NUMBERX PIC 999999 COMP-3.
       01  ERROR-FLD.
           05  ERROR-COUNT PIC 999999 COMP-3.
           05  FLDY REDEFINES ERROR-COUNT.
               07 FLDZ PIC XXXX.
       01  BAD-RESULT PIC 99 COMP-3 Value 42.

       PROCEDURE DIVISION.
       MAIN SECTION.
           DISPLAY '*** IDISCBL1 - START OF PROGRAM'.
       LOOP SECTION.
       START000.
           MOVE 3 TO ERROR-COUNT.
           ADD 986885 TO ERROR-COUNT GIVING NUMBERX.
           MOVE 'ABCD' TO FLDZ.
           IF NUMBERX > 0 THEN PERFORM CLEAR.
           DISPLAY '*** IDISCBL1 - END OF PROGRAM'.
           GOBACK.
       CLEAR SECTION.
       START001.
           DIVIDE NUMBERX BY ERROR-COUNT GIVING BAD-RESULT.
           EXIT.
       END PROGRAM IDISCBL1.
##
//COBOL.SYSPRINT DD DISP=(SHR,PASS),DSN=&LISTING(IDISCBL1)
//COBOL.SYSDEBUG DD DISP=(SHR),DSN=&SYSUID..CLASS.SYSDEBUG
//LKED.SYSIN     DD *
    NAME IDISCBL1(R)
//GO.IDILCOB     DD DISP=(SHR,PASS),DSN=&LISTING
//GO.CEEDUMP     DD DUMMY