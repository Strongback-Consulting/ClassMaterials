#pragma csect(code,"CSAM2X")
#pragma langlvl(extended)

/*  export DLL routines  */
#pragma export(calcCustStats)
#pragma export(calcProdStats)

/*
 ****************************************************************
 * PROGRAM:  CSAM2
 *           Sample program for the XL C Compiler
 *
 * AUTHOR :  Doug Stout
 *           IBM PD TOOLS
 *
 * Contains DLL functions that are called by program CSAM1:
 *    void calcCustStats (statType* Stats, custRecType* Rec,
 *                        int recNum)
 *    void calcProdStats (statType* Stats, productRecType* Rec,
 *                        int recNum)  {
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
    char id Ý5¨;
    char recType;
    char notUsedÝ7¨;
    char nameÝ17¨;
    decimal(9,2) acctBal;
    short ordersYTD;
    char cityÝ15¨;
    char occupationÝ28¨;
               } custRecType;

typedef struct { /* Product record structure */
    char idÝ5¨;
    char recType;
    char prodIDÝ7¨;
    char prodNameÝ25¨;
    char DatePurchasedÝ10¨;
    short ServiceCalls;
    char LastServiceCallÝ10¨;
    char prodNotUsedÝ20¨;
               } productRecType ;

#pragma pack(reset)

typedef struct {
    double Count;
    double Tot;
    double Min;
    double Max;
    double Range;
    double Avg;
               } statType ;

 /* *********************************************************** */
 /* Procedure to calculate customer record statistics           */
 /*                                                             */
void calcCustStats (statType* Stats, custRecType* Rec,
                    int recNum)  {
  if (recNum == 1)  {    /*  Initialize statistics variables  */
    Stats->Count = 0;
    Stats->Tot   = 0;
    Stats->Min   = 0;
    Stats->Max   = 0;
    Stats->Range = 0;
    Stats->Avg   = 0;
  }
  /*  Increment record count               */
  Stats->Count++;
  /*  Add this balance to the grand total  */
  Stats->Tot += Rec->acctBal;
  /*  Calculate the average                */
  Stats->Avg = Stats->Tot / Stats->Count;
  /*  Caclulate the minimum                */
  if (recNum = 1)  {
    Stats->Min = Rec->acctBal;
  }
  if (Rec->acctBal < Stats->Min)  {
     Stats->Min  = Rec->acctBal;
  }
  /*  Caclulate the maximum                */
  /* *** There is a bug calculating the maximum. *** */
  /* ***            Can you find it?             *** */
  if (recNum = 1)  {
    Stats->Max = Rec->acctBal;
  }
  if (Rec->acctBal < Stats->Max)  {
     Stats->Max  = Rec->acctBal;
  }
  return;
}

 /* *********************************************************** */
 /* Procedure to calculate product record statistics            */
 /*                                                             */
void calcProdStats (statType* Stats, productRecType* Rec,
                    int recNum)  {
  if (recNum == 1)  {    /*  Initialize statistics variables  */
    Stats->Count = 0;
    Stats->Tot   = 0;
    Stats->Min   = 0;
    Stats->Max   = 0;
    Stats->Range = 0;
    Stats->Avg   = 0;
  }
  /*  Increment record count               */
  Stats->Count++;
  /*  Add this balance to the grand total  */
  Stats->Tot += Rec->ServiceCalls;
  /*  Calculate the average                */
  Stats->Avg = Stats->Tot / Stats->Count;
  /*  Caclulate the minimum                */
  if (recNum = 1)  {
    Stats->Min = Rec->ServiceCalls;
  }
  if (Rec->ServiceCalls < Stats->Min)  {
     Stats->Min  = Rec->ServiceCalls;
  }
  /*  Caclulate the maximum                */
  if (recNum = 1)  {
    Stats->Max = Rec->ServiceCalls;
  }
  if (Rec->ServiceCalls > Stats->Max)  {
     Stats->Max  = Rec->ServiceCalls;
  }
  return;
}