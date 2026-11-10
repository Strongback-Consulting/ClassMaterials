//RUNECHO  JOB CLASS=A,MSGCLASS=A,NOTIFY=&SYSUID,MSGLEVEL=(1,1)
//***************************************************************
//* This JCL is set to execute the compiled SOCKY7 COBOL module.
//* and is used for demonstrating set up of z/OS Debugger Profiles
//*
//*  1. Update the job card as appropriate for your site
//*  2. Change the the <HLQ> to match your own HLQ
//*  3. Uncomment and change EQAF to match the high level qualifer for where
//* your SITE'S debugger is installed, but only if it is not in your system's
//* link list concatenation.
//* Hint: If deubgger does not kick off, even when your debugger profile
//* is active, you'll likely need to uncomment and change this.
//***************************************************************
//*
//        SET EQAHLQ=EQAF00
//STEP1 EXEC PGM=ECHO,
//           PARM='/TEST()'
//STEPLIB DD DISP=SHR,DSN=&SYSUID.CLASS.LOAD
//* Uncomment below if the debugger is not part of your systems
//* link list concatenation. Change the HLQ to the correct one for your
//* environment
//        DD DISP=SHR,DSN=&EQAHLQ..SEQAMOD
//SYSOUT  DD SYSOUT=*