#pragma strings(readonly)
/*+-----------------------------------------------------------------+
  |         Experian Consumer Credit Services System                |
  |               Copyright (c) 2000 Experian Inc.                  |
  |                                                                 |
  | System Name ---> Pin Purge                                      |
  | Process Name --> Identify Legally Obsolete Trade Assoc.         |
  | File Name -----> CXM0PPFL.c  patterned after FCDRVR1.c          |
  |                                                                 |
  +-Description-----------------------------------------------------+
  |                                                                 |
  | This module extracts TA keys with L/O Trade                     |
  |                                                                 |
  +-List of Functions Contained Within------------------------------+
  |                                                                 |
  |  NAME                    DESCRIPTION                            |
  |                                                                 |
  |  OpenFiles               Open all Input and Output files        |
  |  ProcessInput            Process all Input records              |
  |                                                                 |
  +-O/S Dependancies/Considerations---------------------------------+
  |                                                                 |
  |                                                                 |
  +-Revision History------------------------------------------------+
  |   Date       By                   Reason                        |
  | -------- ----------- ------------------------------------------ |
  | 06/27/13 U Banerjee  Identify PIn with LO Trade                 |
  |                                                                 |
  |  RELEASE        ICP #            DATE                PROGRAMMER |
  |    Q213         43237         06/27/2013             UBanerjee  |
  |                                                                 |
  |  DESCRIPTION: Initial Implementation.                           |
  |                                                                 |
  +-----------------------------------------------------------------+*/

/*-----------------------------------------------------------------*
 | Include Statements                                              |
 *-----------------------------------------------------------------*/

#include "cxp00007.h"   /* ErrorPost/Abend interface */


#if !defined(TRW_CSECT_NAME)
   #define TRW_CSECT_NAME "CXM0PPFL"
   #pragma csect(CODE,"CXM0PPFL")
#endif

#define DetDbg      2


#define TRDASSFL "DD:TRDASSFL"     /* Trade Assoc     Unload file  */
#define TRDUNLD  "DD:TRDUNLD "     /* Trade           Unload file  */
#define OUTFILE  "DD:LOPINFL "     /* LO TA                        */

/*-----------------------------------------------------------------*
 | global definitions                                              |
 *-----------------------------------------------------------------*/
FILE        * pInTAFile = NULL;            /* input file pointer   */
FILE        * pInTRDFile = NULL;           /* input file pointer   */
FILE        * pOutFile   = NULL;           /* output file pointer  */

INT4          DebugSw = 0;
INT4          DisplayCnt=500000;
INT4          TARecCnt = 0;
INT4          TRDRecCnt = 0;
INT4          OrphanTACnt = 0;
INT4          OutCnt = 0;
INT4          NONLOCnt=0;
DATETIME      RunDate;                     /* Run date and time */

char          TARec[92], * pTA = TARec;
char          TRDUnldRec[1588], * pTRD = TRDUnldRec;
char          OutRec[80];
char          TRDCmpKy[57];
char          TACmpKy[57];

/*-----------------------------------------------------------------*
 | Function Prototypes                                             |
 *-----------------------------------------------------------------*/
static void OpenFiles (void);
static void ProcessInput(void);
/*-----------------------------------------------------------------*
 | MAIN function  (entry point)                                    |
 *-----------------------------------------------------------------*/
int  main(int argc, char * argv[])
{
  static char EyeCatcher [] =
              {"CXM0PPFL: COMPILE TIMESTAMP: " __DATE__ " - " __TIME__};

  INT4         x;
 /*-----------------------------------------*
  | display compile date and time           |
  *-----------------------------------------*/
  printf("CXM0PPFL: %s\n", EyeCatcher);

 /*-----------------------------------------*
  | process JCL parm                        |
  *-----------------------------------------*/
  printf("CXM0PPFL: argc=%d\n", argc);

  for (x = 1; x < argc; x++)
  {
    printf("CXM0PPFL: argv %d = %s\n", x, argv[x]);
    if (memcmp(argv[x], "DEBUG=", 6) == 0)
    {
       DebugSw = atoi(&argv[x][6]);
       continue;
    }

    if (memcmp(argv[x], "DISP=", 5) == 0)
    {
       DisplayCnt = atoi(&argv[x][5]);
       continue;
    }


    printf("CXM0PPFL: JCL PARM %s IGNORED\n", argv[x]);
  }

  printf("CXM0PPFL: DebugSw set to %d\n", DebugSw);
  printf("CXM0PPFL: DisplayCnt set to %d\n", DisplayCnt);
 /*-----------------------------------------*
  | open input / output files, Initialize   |
  *-----------------------------------------*/
  OpenFiles();

  /*---------------------------------------------*/
  /* Process input file(s) and produce output(s) */
  /*---------------------------------------------*/
  ProcessInput();

 /*-----------------------------------------------------*
  | display final stats                                 |
  *-----------------------------------------------------*/
  printf("\n\n");
  printf("Process name:                 <CXM0PPFL>\n");
  printf("--------- ----------------- ------------\n")                      ;
  printf("DD name   Description       Count       \n")                      ;
  printf("--------- ----------------- ------------\n")                      ;
  printf("TRD ASSN: TA Recs Count     - <%010d>\n",TARecCnt);
  printf("TRDUNLD : TRD Recs Count    - <%010d>\n",TRDRecCnt);
  printf("LOPINFL: Output Rec Count   - <%010d>\n",OutCnt);
  printf("--------- ----------------- ------------\n");                     ;
  printf("CXM0PPFL: ENDED SUCCESSFULLY\n");
 /*-----------------------------------------------------*
  | close files                                         |
  *-----------------------------------------------------*/
  fclose (pInTAFile);
  fclose (pInTRDFile);
  fclose (pOutFile);

  if (TARecCnt == 0 || TRDRecCnt == 0)
  {
      printf("Both TA & TA Opt files EMPTY !!! -- Aborting \n");
      TRWAbort(1000,0,0);
  }
  else
  {
      return (0);
  }

} /* end of main */



/*+-----------------------------------------------------------------+
  |                                                                 |
  | Function Name --------> OpenFiles                               |
  |                                                                 |
  | Description:     This function is responsible for opening       |
  |                  all the input and output files.                |
  |                                                                 |
  | Parameters:      none                                           |
  |                                                                 |
  | Returns:         void                                           |
  |                                                                 |
  +-----------------------------------------------------------------+*/
static void OpenFiles (void)
{
#undef  FUNCNAME
#define FUNCNAME "OpenFiles"


  /** open input files  **/
  pInTAFile = fopen (TRDASSFL, "rb,type=record,recfm=*"); /* RECFM=VB */
  if (pInTAFile == NULL)
  {
     printf("CXM0PPFL: Unable to open TRDASSFL -- aborting\n");
     TRWAbort(1000,0,0);
  }

  pInTRDFile = fopen (TRDUNLD, "rb,type=record,recfm=*"); /* RECFM=VB */
  if (pInTRDFile == NULL)
  {
     printf("CXM0PPFL: Unable to open TRDUNLD -- aborting\n");
     TRWAbort(1000,0,0);
  }
  /** open output files **/
  pOutFile = fopen (OUTFILE, "wb,type=record,recfm=*"); /* RECFM=FB */
  if (pOutFile == NULL)
  {
     printf("CXM0PPFL: Unable to open TAPURGE  -- aborting\n");
     TRWAbort(1000,0,0);
  }

  return;

} /* end-of OpenFiles */


/*------------------------------------------------------------------+
 |                                                                  |
 | Function Name -------> ProcessInput                              |
 |                                                                  |
 | Description:                                                     |
 | This procedure reads all input records and writes TA with LO Trd |
 |                                                                  |
 | Parameter     Type           Description                         |
 | ----------- ---------        ---------------------------------   |
 | none                                                             |
 |                                                                  |
 | Returns :  none                                                  |
 +------------------------------------------------------------------*/
void ProcessInput(void)
{
#undef  FUNCNAME
#define FUNCNAME "ProcessInput"
char         TASw,TRDSw;
DATETIME     Now;             /* current date and time */
size_t       RecSize;         /* fread return */
INT2         AcctId2Sz;
INT2         AcctArrSz;
char         *p;
char         LOInd='N';
RC           Rc=0;

  TASw = 1;
  TRDSw = 1;
  memset(pTRD, 0x00, sizeof(*pTRD));
  memset(pTA, 0x00, sizeof(*pTA));

 /*-----------------------------------------------------*
  | Process all records                                 |
  *-----------------------------------------------------*/
  while (1)
  {
    if (TRDSw)
    {
        RecSize = fread(pTRD, 1, sizeof(TRDUnldRec), pInTRDFile);

        if (RecSize == 0)    /* EOF , process remaining TAOCC recs */
        {
            printf("EOF TRD reached\n");
            break;
        }
        else
        {
            TRDRecCnt++;
            if (TRDRecCnt  % DisplayCnt == 0)
            {
               SystemDateGet(&Now);
               printf("\n As of: %s %02d:%02d:%02d",
                      Now.DTGregDate,
                      Now.DTHour,
                      Now.DTMinute,
                      Now.DTSecond);
               printf(" TRD Cnt <%d> TA Cnt<%d>", TRDRecCnt, TARecCnt);
               printf("NON LO TRD Cnt <%d> LO TA Cnt<%d>\n",
                      NONLOCnt, OutCnt);
            }
        /* Form the TAO key before the memcompare */
            memset(TRDCmpKy,0,sizeof(TRDCmpKy));
        /* Copy Sin , Vndr , Cycl , AcctId1       */
            memcpy(TRDCmpKy,pTRD,27);

            p = pTRD;
            // Scroll up past AcctId
            AcctId2Sz = *((INT2*) (p + 115));
            if (AcctId2Sz != 0)
            {
               memcpy(&TRDCmpKy[27], p+117, AcctId2Sz);
               p+=AcctId2Sz+117;
            }
            else
               p+=117;
            // Scroll up past the Acct Array
            AcctArrSz = *((INT2*)p);
            if (AcctArrSz != 0)
               p+=AcctArrSz+2;
            else
               p+=2;

            LOInd = *p;

        /* Copy Opendate  */
            memcpy(&TRDCmpKy[50], pTRD+27, 6);
        }
    }
    if (TASw)
    {
        RecSize = fread(pTA, 1, sizeof(TARec), pInTAFile);
        /* Process remaining TRD records if TAOCC hits EOF   */
        if (RecSize == 0)
        {
            printf("EOF TAOCC reached\n");
            break;
        }
        else
        {
            TARecCnt++;
        /* Form the TA  key before the memcompare */
            memset(TACmpKy,0,sizeof(TACmpKy));
        /* Copy Sin , Vndr , Cycl , AcctId1       */
            memcpy(TACmpKy, pTA+4, 27);

        /* If AcctId2 exists Copy                 */
            AcctId2Sz = *((INT2*) (pTA + 63));
            if (AcctId2Sz != 0)
               memcpy(&TACmpKy[27], pTA+65, AcctId2Sz);

        /* Copy Opendate */
            memcpy(&TACmpKy[50], pTA+31, 6);
        }
    }

    Rc = memcmp(TRDCmpKy, TACmpKy, 56);

    if (Rc < 0)                /* TRD does not have matching TA */
    {
        TASw = 0;              /* Read next TRD till >= TAOCC key */
        TRDSw = 1;
    }
    else if (Rc == 0)          /* Matched TRD & TA    */
    {
        if (LOInd == 'Y')
        {
           memset(&OutRec,0x40,sizeof(OutRec));
           memcpy(OutRec,pTA,31);
           fwrite(&OutRec, sizeof(OutRec), 1, pOutFile);
           OutCnt++;
        }
        else
           NONLOCnt++;

        TASw = 1;              /* Read next TRD   */
        TRDSw = 0;             /* Read next TA    */
    }
    else                       /* Orphan TA    , do nothing file */
    {
        TASw = 1;
        TRDSw = 0;             /* Read next TAOCC till >= TRD key */
        OrphanTACnt++;
    }

  } /* end-of while (1) */

}