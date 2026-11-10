/* --------------------------------*/
/* SAS Program example             */
/* --------------------------------*/

proc rdzExample data=returns;

/* SAS Comments */
   model ibm = mkt
         / rdzVar1=3
           rdzVar2=1
           rdzVar2prob;

/* More SAS Comments */
   output out=rdzOut1
          rdzCL_x=.05
          p=RDz_arVRDz3
          r=RDz_R_RDz3
          RDz_VaRDz_R_l=l_RDz3
          RDz_VaRDz_R_U=u_RDz3;

/* More SAS Comments */
proc autoreg data=returns noprint;

/* More SAS Comments */
   model wyr = mkt;
   output out=RDz_VarRDz_VaRDz_R_Out1 p=RDz_VarPO r=RDz_VarRO;

/* More SAS Comments */
   model wyr=mkt;
   hetero mkt / link=exp std=nonneg;
   output out=RDz_VaRDz_R_Out2 p=RDz_het r=RDz_R_het lcl=l ucl=u;

/* More SAS Comments */
   model wyr = mkt / nlag=1 garch=(q=1,p=1);
   output out=RDz_VaRDz_R_Out3 p=RDz_gar r=RDz_R_gar;

data returns2;
   merge returns1 RDz_VarRDz_VaRDz_R_Out1 RDz_VaRDz_R_Out2 RDz_VaRDz_R_Out3;
   where date > '01oct52'd;
   by date;

/*  More SAS Comments */
   model ibm = mkt
         / rdzVar1=(2 91);

      /*  More SAS Comments */
   output out=RDz_Out3
          rdzCL_x=.05
          p=RDz_RDz_Var14
          r=RDz_R_RDz_Var14
          RDz_VaRDz_R_l=l_RDz_Var14
          RDz_VaRDz_R_U=u_RDz_Var14;

/*  More SAS Comments */
   model ibm = mkt
         / rdzVar1=79
           backstep;

/*  Final SAS Comments */
   output out=rt_out4
          rdzCL_x=.92
          p=RDz_RDz_Var13
          r=RDz_R_RDz_Var13
          RDz_VaRDz_R_l=l_RDz_Var13
          RDz_VaRDz_R_U=u_RDz_Var13;
run;

data rt_out5;
   merge rdzOut1 RDz_Out3 rt_out4;
   by date;
run;

proc print data=rt_out5;
   where date > '01oct52'd;
   var date RDz_arVRDz3 RDz_RDz_Var14 RDz_RDz_Var13;
   title2 'Forecasts from AR Models';
run;