//<MYTSOID> JOB ,MSGCLASS=H,MSGLEVEL=(1,1),TIME=(,4),REGION=0M
//* JCLLIB ORDER=<Dataset where ELAXF procs are located>
/*********************************************************************
//*********************** BUILD AND RUN *******************************
//*********************************************************************
//** 1. Change the two instances of <MYTSOID> to your TSO ID **
//** 2. Submit the JCL and verify the GO:RUN:SYSOUT
//**        - Ensure that the Job finishes with a 0000 completion code
//**        - Verify the GO:RUN:SYSOUT
//*********************************************************************
//        SET LODLIB=&SYSUID..CLASS.LOAD
//*
//GO    EXEC   PROC=ELAXFGO,GO=LOANCOB,
//        LOADDSN=&LODLIB,
//        PARM='20220622'
//STEPLIB DD DISP=SHR,DSN=&LODLIB
//*//CEEOPTS DD *
//*   TEST(,,,DBMDT%<MYTSOID>:)
//*********************************************************************
//**************************  DEBUG  **********************************
//*********************************************************************
//** 3. Uncomment the above //CEEOPTS DD * and TEST... statement
//** 4. Submit the JCL and Debug the program - as follows
//**    - Resume (F8) - this will run to EOJ. Resubmit this JCL
//**    - Step (F5) thru the code. Hover over the variables
//**    - Step Return (F7) this ends the program. Resubmit this JCL
//**    - Set a Breakpoint on the GOBACK & Resume(F8) to the Breakpoint
//**    - Terminate the Debug session(Ctrl+2)
//**
//*********************************************************************
//*********************** CODE COVERAGE *******************************
//*********************************************************************
//** 5. Copy the ENVAR statement below the TEST statement
//** 6. Uncomment the ENVAR statement and Submit the JCL
//** 7. Open and explore the Code Coverage Report
//*********************************************************************
//*ENVAR("EQA_STARTUP_KEY=CC")
//
//*********************************************************************
//******************* PLACE HOLDER INSTRUCTIONS ***********************
//*********************************************************************
//** REPLACE THE TEST(,,,  STATEMENT WITH A WORKING DEBUG TEST CARD ***
//** REPLACE JOB STATEMENT WITH A WORKING JCL JOB CARD FOR YOUR SHOP