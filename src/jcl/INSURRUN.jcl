//<MYTSOID> JOB ,MSGCLASS=H,MSGLEVEL=(1,1),TIME=(,4),REGION=0M
//* JCLLIB ORDER=<Dataset where ELAXF procs are located>
//*********************************************************************
//*********************** BUILD AND RUN *******************************
//*********************************************************************
//** 1. Change the two instances of <MYTSOID> to your TSO ID **
//** 2. Submit the JCL and verify the GO:RUN:SYSOUT
//**        - Ensure that the Job finishes with a 0000 completion code
//**        - Verify the GO:RUN:SYSOUT
//*********************************************************************
//        SET LODLIB=&SYSUID..CLASS.LOAD
//*
//GO    EXEC   PROC=ELAXFGO,GO=INSURCOB,
//        LOADDSN=&LODLIB,
//        PARM='20220622'
//STEPLIB DD DISP=SHR,DSN=&LODLIB
//CEEOPTS DD *
   TEST(,,,DBMDT%&SYSUID.:)
/*
//**************************  DEBUG  **********************************
//** Uncomment the above //CEEOPTS DD * and TEST... statement
//*********************************************************************
//************* INSTREAM TEST DATA FOR INSURANCE CLAIMS ***************
//*********************************************************************
//CLAIM DD *
1111111Schafer        Natalie   120181224111111111111111111111111111111111
2222222McKernan       Joseph    220191225222222222222222222222222222222222
3333333Mariano        Thomas    320201226333333333333333333333333333333333
4444444Alexandra Mary Elizabeth 120210228444444444444444444444444444444444
5555555Harden         Matthew   220220525555555555555555555555555555555555
6666666Rogers         Will      320220626666666666666666666666666666666666
7777777Monster        Cookie    220220727777777777777777777777777777777777
8888888Fenwick        Nell      120220828888888888888888888888888888888888
/*
//************** OUTPUT CLAIMS REPORT - WRITTEN TO SYSOUT *************
//CLAIMRPT DD SYSOUT=*
//