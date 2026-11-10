//IBMUSER1 JOB ,
// MSGCLASS=H,MSGLEVEL=(1,1),TIME=(,4),REGION=144M,COND=(16,LT)
//*
//STP0000 EXEC PROC=ELAXFCPC
//C.SYSLIN DD DISP=SHR,
//        DSN=&SYSUID..CPPOBJS.OBJ(CCNUAAN)
//C.SYSLIB DD DISP=SHR,
//        DSN=CEE.SCEEH.H
//        DD DISP=SHR,
//        DSN=CEE.SCEEH.SYS.H
//        DD DISP=SHR,
//        DSN=CEE.SCEEH.NET.H
//        DD DISP=SHR,
//        DSN=CEE.SCEEH.NETINET.H
//C.SYSEVENT DD DUMMY
//C.SYSIN DD DISP=SHR,
//        DSN=&SYSUID..SOURCE.CPP(CCNUAAN)
//*
//OPTION DD DATA,DLM='@@'
@@
//******* additional jcl for compile here ******
//LKED EXEC PROC=ELAXFLNK
//LINK.OBJ0000 DD DISP=SHR,
//        DSN=&SYSUID..CPPOBJS.OBJ(CCNUAAN)
//LINK.SYSLIN DD *
     include obj0000
/*
//LINK.SYSLMOD   DD  DISP=SHR,
//        DSN=&SYSUID..LOAD(CCNUAAN)
//*
//******* additional jcl for link here ******
//GO    EXEC   PROC=ELAXFGO,GO=CCNUAAN,
//           LOADDSN=&SYSUID..LOAD
//******* additional runtime jcl here ******
//