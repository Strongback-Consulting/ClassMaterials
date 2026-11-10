#pragma csect(code,"CSAM1X")
#pragma langlvl(extended)

/*
 ****************************************************************
 * PROGRAM:  CSAM1
 *           Sample program for the XL C Compiler
 *
 * AUTHOR :  Doug Stout
 *           IBM PD TOOLS
 *
 * Reads a sequential file and writes a report
 * Processing i#pragma csect(code,"CSAM1X")
#pragma langlvl(extended)

/*
 ****************************************************************
 * PROGRAM:  CSAM1
 *           Sample program for the XL C Compiler
 *
 * AUTHOR :  Doug Stout
 *           IBM PD TOOLS
 *
 * Reads a sequential file and writes a report
 * Processing is controlled by a transaction file
 *
 * This example application is a teaching aid.  Intended uses are:
 *   For Debug Tool workshop:
 *      - determine why max value is incorrect in the report
 *      - intercept the S0C7 abend that can occur in program CSAM2
 *   For Fault Analyzer workshop:
 *      - determine why the CSAM2 program abends in some cases
 *   For Application Performance Analyzer workshop:
 *      - determine where the program is spending the most time
 *****************************************************************
 *
 * Transaction file record descriptions:
 *     0    1    1    2    2    3    3    4    4    5    5    6    6
 * ....5....0....5....0....5....0....5....0....5....0....5....0....5
 * *        <== an asterisk in first column is a comment
 * PRINT    <== produces a detail report
 * TOTALS   <== produces a summary report
 * ABEND    <== force a divide by zero abend
 *
 *****************************************************************
 */

#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include <math.h>
#include <string.h>
#include <decimal.h>

#pragma pack(1)  /* needed to properly map fields in the
                     record structure typedefs that follow    */

typedef struct { /* Customer record structure */
    char id;
    char recType;
    char notUsed;
    char name;
    decimal(9,2) acctBal;
    short ordersYTD;
    char city;
    char occupation;
               } custRecType;

typedef struct { /* Product record structure */
    char id;
    char recType;
    char prodID;
    char prodName;
    char DatePurchased;
    short ServiceCalls;
    char LastServiceCall;
    char prodNotUsed;
               } productRecType ;

#pragma pack(reset)

typedef struct { /* Transaction record structure */
    char tranCode;
    char tranRecNotUsed;
               } tranRecType;

typedef struct {
    double Count;
    double Tot;
    double Min;
    double Max;
    double Range;
    double Avg;
               } statType ;

FILE* tranFile;
char  tranRecBuffer;
tranRecType* tranRec;
char  EOFTranFile='N';
int   tranRecCount;
int   tranRecLen;

FILE *custFile;
char  custRecBuffer;
custRecType *custRec;
productRecType *productRec;
char  EOFCustFile='N';
int   FileRecCount;
int   custRecCount;
int   prodRecCount;
int   custRecLen;

statType custStats;
statType prodStats;

 /* *********************************************************** */
 /* External function definitions that will run from DLL        */
 /*                                                             */
extern void calcCustStats (statType* Stats, custRecType* Rec,
            int recNum);
extern void calcProdStats (statType* Stats, productRecType* Rec,
            int recNum);

 /* *********************************************************** */
 /* Procedure to read records from TRANFILE                     */
 /*                                                             */
char readTranFile () {
  tranRecLen = fread( tranRecBuffer, 1,\
                      sizeof(tranRecBuffer), tranFile );
  if (tranRecLen > 0) {         /* fread success */
    tranRecCount++;
    return('Y');
  }
  if ( ferror(tranFile) )       /* fread fail possibility 1 */
    printf( "Error reading TRANFILE" );
  else if ( feof(tranFile)) {   /* fread fail possibility 2 */
    EOFTranFile = 'Y';
  }
  return('N');
}

 /* *********************************************************** */
 /* Procedure to read records from CUSTFILE                     */
 /*                                                             */
char readCustFile () {
  custRecLen = fread( custRecBuffer, 1, \
                      sizeof(custRecBuffer), custFile );
  if (custRecLen > 0) {         /* fread success */
    FileRecCount++;
    return('Y');
  }
  if ( ferror(custFile) )       /* fread fail possibility 1 */
    printf( "Error reading CUSTFILE" );
  else if ( feof(custFile)) {   /* fread fail possibility 2 */
    EOFCustFile = 'Y';
  }
  return('N');
}

 /* *********************************************************** */
 /* Process PRINT transaction                                   */
 /*                                                             */
void processPrintTran()  {

  double workAcctBal;
  custRec = (custRecType*)custRecBuffer;
  productRec = (productRecType*)custRecBuffer;

  /*Open the custFile */
  if ((custFile = fopen("DD:CUSTFILE", "rb, lrecl=80,\
                         recfm=fb, type=record")) == NULL) {
    printf("Could not open file Custfile\n");
    return;
  }

  printf(" \nCUSTOMER FILE REPORT\n \n");
  printf("ID    CUSTOMER NAME     OCCUPATION                     "
         "   BALANCE ORDERS-YTD\n");
  printf("----- ----------------- ------------------------------ "
         "---------- ----------\n");

  FileRecCount = 0;
  custRecCount = 0;
  prodRecCount = 0;
  while ( EOFCustFile != 'Y' ) {
    if ( readCustFile() != 'Y' ) continue ;

    /* If the record type is C it is a customer record */
    if ( custRec->recType == 'C' ) {
      custRecCount++;
      workAcctBal = custRec->acctBal;
      printf( "%5.5s %17.17s %30.30s %10.2f %10d\n", \
            custRec->id, custRec->name, custRec->occupation, \
            workAcctBal, custRec->ordersYTD );
      /* Calculate customer record statistics */
      calcCustStats(&custStats, custRec, custRecCount);
    }
    /* If the record type is P it is a product record */
    else if (custRec->recType == 'P') {
      prodRecCount++;
      /* Calculate product record statistics */
      calcProdStats(&prodStats, productRec, prodRecCount);
    }
    else printf("Invalid record found in Custfile");
  }
  fclose( custFile );
}

int ReportTime() /*Current Time and Date */  {
  time_t currentTime;
  time (&currentTime);

  char * currentdatetime = (asctime(localtime(&currentTime)));
  struct tm * ptm = localtime(&currentTime);
  int year = ptm->tm_year+1900;
  int month = ptm->tm_mon;
  int day = ptm->tm_mday;
  int hour = ptm->tm_hour;
  int min = ptm->tm_min;
  int sec = ptm->tm_sec;
  printf("DATE/TIME: %s",currentdatetime);
  return 0;
}


 /* *********************************************************** */
 /* Main routine                                                */
 /*                                                             */
void main ()
{
  printf( "Program CSAM1 Started\n" );       /*Begin the Report */
  ReportTime();
  tranRecCount = 0;
  tranRec = (tranRecType*)tranRecBuffer;

  /* Open the Transaction input file */
  if ((tranFile = fopen("DD:TRANFILE", "rb, lrecl=80,\
                         recfm=fb, type=record")) == NULL) {
    printf("Could not open file TRANFILE\n");
    return;
  }

  while ( EOFTranFile != 'Y' ) {
    if ( readTranFile() != 'Y' ) continue ;
    if ( tranRecBuffer != '*' )  {
      printf(" \n");
      printf("Transaction:       %80s\n",tranRecBuffer);
      if (strncmp(tranRec->tranCode,"PRINT ",6) == 0)  {
          processPrintTran();
      }
      else if (strncmp(tranRec->tranCode,"TOTALS",6) == 0)  {
        double prtTot, prtMax, prtAvg;
        statType* ptrStat;
        ptrStat = &custStats;
        prtTot = ptrStat->Tot;
        prtMax = ptrStat->Max;
        prtAvg = ptrStat->Avg;
        printf(" \nTOTALS REPORT\n");
        printf("----------------------------------------"
               "----------------------------------------\n");
        printf("  Acct Balance:     Total:%10.2f        "
               "Max:%8.2f        Average:%8.2f \n", \
               prtTot, prtMax, prtAvg);
        printf("  Customer file records:      Read:%10i \n", \
               FileRecCount);
      }
      else if (strncmp(tranRec->tranCode,"ABEND ",6) == 0)  {
        int result, numbera, numberb;
        result = 999;
        numbera = 100;
        numberb = 0;
        result = numbera - numberb;
        result = numbera + numberb;
        result = numbera / numberb;
        result = numbera * numberb;
      }
      else  {
        printf("    Transaction Error: INVALID TRAN CODE\n");
        printf(" \n");
      }          /* switch tranCode                  */
    }         /* if readTranRecBuffer›1® != '*'   */
  }        /* while EOFTranfile != 'Y'         */

  fclose( tranFile );
  return;
}
