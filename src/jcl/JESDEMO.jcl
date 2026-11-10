//JCLDEMO1 JOB ,NOTIFY=&SYSUID,
// MSGCLASS=H,MSGLEVEL=(1,1),TIME=(,4),REGION=144M
//*********************************************************************
//*  This is a sample JCL to run and show general commands
//*********************************************************************
//STEP001  EXEC PGM=IEBGENER
//SYSIN    DD DUMMY
//SYSPRINT DD SYSOUT=*
//SYSUT1   DD *
HELLO, WORLD
/*
//SYSUT2   DD SYSOUT=*
/*


