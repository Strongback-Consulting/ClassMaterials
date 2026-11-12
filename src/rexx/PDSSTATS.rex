/*REXX ROUTINE TO READ A PDS DIRECTORY AND SHOW THE ISPF STATS     */
/*     NON LOAD MODULE ONLY.                                       */
/* AUTHOR: BODI 2004.02.10, WITH UPDATES BY GREGCZ                 */
/* TRACE ALL */

T1 = TIME('E')              /* CLEAR TIMER */
PARSE UPPER ARG DSNAME .
IF DSNAME = '' THEN DSNAME = "'MISSING.DATA.SET.NAME'"
IF 0<>LISTDSI(DSNAME) THEN
  DO
    SAY 'DATA SET 'DSNAME' NOT ALLOCATED'
    EXIT 4
  END
IF 'PO' <> SUBSTR(SYSDSORG,1,2) THEN
  DO
    SAY 'DATA SET 'DSNAME' IS NOT A PDS'
    EXIT 4
  END

JUNK = MSG(OFF)
/* ALLOCATE AND READ DIR */
'ALLOC F(AREAD) DS('DSNAME') SHR REUSE DSORG(PS) LRECL(256) RECFM(F B)'
'EXECIO * DISKR AREAD ( FINIS STEM DIRS.'
'FREE F(AREAD)'
  /*   SAY 'NUMBER OF PDS MEMBERS: ' DIRS.0;                */

  /*  /* ALLOCATE NEW FILE FOR MEMBER LIST */               */
  /*  DSNAME = "'"||USERID()||"."||"MEM.LIST"||"'"          */
  /*  Z = LISTDSI(DSNAME)                                   */
  /*  IF Z = 0 THEN 'DELETE' DSNAME                         */
  /*  JUNK = MSG(ON)                                        */
  /*  IF RC <> 0 THEN DO                                    */
  /*    SAY 'DATASET' DSNAME 'IN USE'                       */
  /*    EXIT 4                                              */
  /*  END                                                   */
  /*                                                        */
  /*  /* ALLOCATE PS FOR MEMBER LIST OUTPUT */              */
  /*  'ALLOC F(AWRITE) DS('DSNAME') NEW DSORG(PS) LRECL(80), */
  /*      RECFM(F B) BLKSIZE(0) SPACE(1,10) TRACKS'         */

/* CLEAR STACK  */
'DELSTACK'

/* READ AND DECODE DIRECTORY ENTRY */
I = 0;
DO BLOCKNUM = 1 TO DIRS.0
  BLOCK=DIRS.BLOCKNUM
  PARSE VAR DIRS.BLOCKNUM BL 3 BLOCK
  BLOCK=SUBSTR(BLOCK,1,C2D(BL)-2)
  DO WHILE BLOCK<>''
    PARSE VAR BLOCK NAME 9 TTR 12 C 13 BLOCK
    C=C2D(BITAND(C,'1F'X))
    IF NAME='FFFFFFFFFFFFFFFF'X THEN
      LEAVE BLOCKNUM
    STATS=''
    IF C=15 & SYSRECFM <> 'U' THEN
      STATS=DECODESTATS(SUBSTR(BLOCK,1,30))
    X = NAME||"  "||STATS
    I = I + 1;
    STAT.I = X;
    BLOCK=DELSTR(BLOCK,1,C*2)
  END
END

/* WRITE ALL DIR ELEMENTS FROM STACK */
IF I > 0 THEN DO;
  STAT.0 = I;
  'EXECIO 'STAT.0' DISKW AWRITE (FINIS STEM STAT.'
END;
SAY TIME('E')
EXIT 0

DECODESTATS:  PROCEDURE  /* DECODE THE DIRECTORY */
DIRENTRY=ARG(1)
  PARSE VAR DIRENTRY,
    VV 2 MM 3 FLAGS 4 SS 5 CRECC 6 CRDATE 9 MODCC 10 MODDATE 13 HH,
    14 TM 15 LINES 17 INIT 19 MOD 21 USERID 28 .
  PARSE VALUE C2X(CRDATE)  WITH CYY 3 CJJJ 6 .
  PARSE VALUE C2X(MODDATE) WITH MYY 3 MJJJ 6 .
  OUT=LEFTD(VV)'.'LEFTD(MM)                       /* VV.MM         */
  OUT=OUT 19+C2X(CRECC)CYY'.'CJJJ                 /* CREATE DATE   */
  OUT=OUT 19+C2X(MODCC)MYY'.'MJJJ                 /* MOD DATE      */
  OUT=OUT LEFTX(HH)':'LEFTX(TM)':'LEFTX(SS)       /* MOD TIME      */
  OUT=OUT RIGHT(C2D(LINES),5)                     /* LINES         */
  OUT=OUT RIGHT(C2D(INIT),5)                      /* INITIAL LINES */
  OUT=OUT RIGHT(C2D(MOD),5)                       /* MOD LINES     */
  OUT=OUT USERID                                  /* USER ID       */
  IF BITAND(FLAGS,'80'X) = '80'X THEN
    OUT=OUT '(SCLM)'                              /* SAVED BY SCLM */
  RETURN OUT
LEFTD: RETURN RIGHT(C2D(ARG(1)),2,'0')
LEFTX: RETURN RIGHT(C2X(ARG(1)),2,'0')
