//*Jobcard
//*-------------------------------------------------------------*
//*                                                             *
//*               @BANNER_START@                                *
//*               Licensed Materials - Property of IBM          *
//*                                                             *
//*               "Restricted Materials of IBM"                 *
//*                                                             *
//*               5655-147                                      *
//*                                                             *
//*               (C) Copyright IBM Corp. 1999                  *
//*                                                             *
//*               (Element of CICS Applications - Design and    *
//*                 Programming Book)                           *
//*               @BANNER_END@                                  *
//*                                                             *
//*-------------------------------------------------------------*
//*  DELETE/REDEFINE/SETUP jobs for the new CICS Applications   *
//*  Design and Programming Book sample VSAM datasets           *
//*-------------------------------------------------------------*
//*     CICS/ESA sample jobs to define ACCT files               *
//*                                                             *
//* This job deletes and defines the data sets for the          *
//* NACT sample described in the CICS Applications - Design and *
//*                              Programming Book               *
//*                                                             *
//*  THE HIGH-LEVEL-QUALIFIER(S) OF THE DATASETS: <<<<---->>>>  *
//*  THE VOLUME SERIAL                            SYSDAV        *
//*  THE UNIT TYPE                                3390          *
//*                                                             *
//*-------------------------------------------------------------*
//SETUP    EXEC PGM=IDCAMS,REGION=2M
//SYSPRINT DD SYSOUT=*
//SYSIN    DD *
 /*-------------------------------------------------------------*
 /*                                                             *
 /* Delete and define the datasets for files                    *
 /* ACCTFIL and ACINUSE                                         *
 /*                                                             *
 /*-------------------------------------------------------------*
 DELETE <<<<---->>>>.ACCTFILE
 DELETE <<<<---->>>>.ACTINUSE
 SET MAXCC=0
 DEFINE CLUSTER(NAME(<<<<---->>>>.ACCTFILE)         -
          KEYS(5 0)                                 -
          INDEXED                                   -
          RECORDSIZE(383 383)                       -
          REC(80)                                   -
          SHR(2 3)                                  -
          LOG(UNDO)                                 -
          VOLUMES(SYSDAV))                          -
        DATA(NAME(<<<<---->>>>.ACCTFILE.DATA)       -
          UNIQUE)                                   -
       INDEX(NAME(<<<<---->>>>.ACCTFILE.INDEX)      -
          UNIQUE)
 /*                              */
 DEFINE CLUSTER(NAME(<<<<---->>>>.ACTINUSE)         -
          KEYS(5 0)                                 -
          INDEXED                                   -
          RECORDSIZE(25 25)                         -
          REC(80)                                   -
          SHR(2 3)                                  -
          LOG(UNDO)                                 -
          VOLUMES(SYSDAV))                          -
        DATA(NAME(<<<<---->>>>.ACTINUSE.DATA)       -
          UNIQUE)                                   -
       INDEX(NAME(<<<<---->>>>.ACTINUSE.INDEX)      -
        UNIQUE)
 /*-------------------------------------------------------------*
 /*                                                             *
 /* Populate the main account file - ACCTFIL                    *
 /* with initial data from  <<-->>.DATA                         *
 /*                                                             *
 /*-------------------------------------------------------------*
   IF LASTCC = 0                                    -
     THEN DO
       REPRO                                        -
         IDS(<<-->>.DATA)                           -
         ODS(<<<<---->>>>.ACCTFILE)
   END
 /*-------------------------------------------------------------*
 /*                                                             *
 /* Create the AIX and path for file ACCTNAM                    *
 /*                                                             *
 /*-------------------------------------------------------------*
   IF MAXCC = 0                                     -
     THEN DO
       DEFINE AIX(NAME(<<<<---->>>>.ACCTNAIX)       -
                RELATE(<<<<---->>>>.ACCTFILE)       -
                VOLUMES(SYSDAV)                     -
                KEYS(18 5)                          -
                NONUNIQUEKEY                        -
                UPGRADE                             -
                REC(80)                             -
                SHR(2 3))                           -
              DATA(NAME(<<<<---->>>>.ACCTNAIX.DATA) -
                UNIQUE)                             -
             INDEX(NAME(<<<<---->>>>.ACCTNAIX.INDEX)-
                UNIQUE)
   END
   IF LASTCC = 0                                    -
     THEN DO
       DEFINE PATH(NAME(<<<<---->>>>.ACCTNAME)      -
                PATHENTRY(<<<<---->>>>.ACCTNAIX) -
                UPDATE)
   END
 /*-------------------------------------------------------------*
 /*                                                             *
 /* Create the alternate index for file ACCTNAM                 *
 /*                                                             *
 /*-------------------------------------------------------------*
   IF MAXCC = 0                                     -
     THEN DO
       BLDINDEX INDATASET(<<<<---->>>>.ACCTFILE) -
            OUTDATASET(<<<<---->>>>.ACCTNAIX)       -
            INTERNALSORT
   END
 /*
