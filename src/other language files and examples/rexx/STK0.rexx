/* rexx */
/*-------------------------------------------------------------------*/
/* Exec Name:    STK0000                                             */
/* Date Written: 02/05/1999                                          */
/* Description:  Generate control cards for StorageTek utilities.    */
/* Author:       Bruce R. Gillispie - email: gillispi@texasrock.com  */
/* Invocation:   Batch Job  - see JCL called: SYTSTK00               */
/*-------------------------------------------------------------------*/
/* Disclaimer:                                                       */
/* The "SORTCNTL" REXX IS NOT in the Public Domain Freeware Software.*/
/* You may use the "SORTCNTL" REXX AT YOUR OWN RISK, it is provided  */
/* for your enjoyment and neither the Author or his Employer provides*/
/* any warranty for its use.                                         */
/*-------------------------------------------------------------------*/
/* Updates:  04/14/1999 (brg) - add call pullnums indata routine     */
/*-------------------------------------------------------------------*/
 signal on error                           /* catch all routine   */

 NumCntlStmts  = "20"   /* Num of Control Statments per move Stmt */
 NumRecPerCard = "5"    /* Num of Volume records per Cntl Stmt    */

 con_cmd     = "¢D LSM  007"             ; /* Console Command     */
 Head_Cntl.1 = "  MOVE VOLUME( - "       ; /* Header Control Card */
 Last_Cntl.1 = "  ) TLSM(007)    "       ; /* Last  Control Card  */
 Body_Cntl   = "TEST.STK.SLSXVSCN.RPT.SORTED2";    /* input data  */
 wkname      = "TEST.STK.SLSXVSCN.MOVE.CARDS2";    /* output data */
/*              ....5....+....5....+....5....+....5....+....5.... */

call issue_console_command
call parse_console_feedback
call alloc_input_file
call read_input_rec
call close_input_file
call num_rec_in
call cre_rec_grps
call alloc_wrkfile
call write_group_recs
call close_work_file
exit 00
/*                                                                */
/* call display_job                        used for development   */
/* call delete_work_file                   used for development   */

/* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */
/*  Allocate Work file                                               */
/* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */
alloc_wrkfile:
  Address 'TSO'
    "ALLOC NEW CAT F($TMPLIB$) DSO(PS) SP(1,1) CYL "||,
    "DA('" || wkname || "') REUSE "||,
    "RECFM(F) BLKSIZE(0) LRECL(80) UNIT(SYSALLDA)";
 retcode = rc;                             /* Save the return code    */
 if retcode <> 0                           /* Did it work ??          */
    then do;                               /*     no, tell them       */
            Say "Allocation failed with rc=" retcode;
            Say "For the Temp Work File";
            return retcode;
            end;

return retcode;

/* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */
/*  Allocate Input files                                             */
/* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */
alloc_input_file:

 dsname = Body_Cntl ;

 Address 'TSO'
  "ALLOC F(INPCNTL),
            DA('" || dsname || "') ",
            "SHR REUSE";
 retcode = rc;                             /* Save the return code    */
 if retcode <> 0                           /* Did it work ??          */
    then do;                               /*     no, tell them       */
            Say "Allocation failed with rc=" retcode;
            Say "For the INPCNTL File " dsname;
            return retcode;
            end;

return retcode;

/* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */
/* Read Input records into a Stem                                    */
/* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */
read_input_rec:
 drop record. ;                            /* uninitialize variable  */
 "execio * diskr INPCNTL (STEM record.";
 "execio 0 diskr INPCNTL (FINIS";
return retcode;

/* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */
/* Close Input file                                                  */
/* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */
close_input_file:
Address 'TSO' 'FREE F(INPCNTL)'
return retcode;

/* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */
/* Build Control cards                                               */
/* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */
num_rec_in:
 if record.0 >= '5000' | record.0 <= '0' then
  do
   'clear'
   say ' = = = = = = = = = = = = = = = = = = = = = = = = = = ='
   say '  The number of records being processed is:' record.0
   say '     FUD factor index = ''afraid to continue''        '
   say ' = = = = = = = = = = = = = = = = = = = = = = = = = = ='
   exit 666
   return 666
  end
 else
  do
   /* - - - - - - - - - - - - - - - - - -  - - - - - */
   /* Set Number of Records to Process               */
   /* - - - - - - - - - - - - - - - - - -  - - - - - */
   trace on
   trace i
   if record.0 > num_fca then
    do
     record.0 = num_fca
    end
  end
   trace off
return retcode;

/* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */
/* Write Header record                                               */
/* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */
write_header_rec:
"execio 1 diskw $TMPLIB$(STEM Head_Cntl.";
return retcode;

/* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */
/* Write End record                                                  */
/* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */
write_end_rec:
"execio 1 diskw $TMPLIB$(STEM Last_Cntl.";
return retcode;

/* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */
/* Write record group                                                */
/* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */
write_record_grp:
queue rec_grp.counter
"execio 1 diskw $TMPLIB$"
return retcode;

/* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */
/* Write Body records                                                */
/* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */
write_group_recs:
drop pass01 pass02 counter x y ;  /* start fresh                   */
x = rg  % NumCntlStmts
y = rg // NumCntlStmts
pass01 = x ; pass02 = y; counter = 1;

if pass01 <> 0 then          /* do we have data to process ?       */
do
 do i = 1 to pass01          /* num of complete record groups      */
 call write_header_rec;
  do j = 1 to NumCntlStmts   /* num of cntl stmt = to NumCntlStmts */
   call write_record_grp
   counter = counter + 1
  end j
  call write_end_rec;
 end i
end

if pass02 <> 0 then      /* do we have data to process ?           */
do
 do i = 1 to 1           /* should never required more than 1 pass */
 call write_header_rec;
  do j = 1 to pass02     /* num of record groups <> NumCntlStmts   */
   call write_record_grp
   counter = counter + 1
  end j
  call write_end_rec;
 end i
end
return retcode;

/* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */
/* Close Work file                                                   */
/* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */
close_work_file:
"execio 0 diskw $TMPLIB$ (FINIS";
return retcode;

/* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */
/* Parse Console Command Feedback                                    */
/* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */
parse_console_feedback:
sva_l = length('SCRATCH VOLUMES AVAILABLE')
do i = 1 to feed_back.0
 sva = substr(feed_back.i,2,sva_l)
 if sva = "SCRATCH VOLUMES AVAILABLE" then
  do
   nw = words(feed_back.i)
    do j=1 to nw
     dw.j = word(feed_back.i,j)
     if datatype(dw.j) = "NUM" then
     num_sva = strip(dw.j,b,.)
    end j
   say 'Scratch Volumes Available = 'num_sva
  end
 else
  iterate i
end i
fca_l = length('FREE CELLS AVAILABLE')
do i = 1 to feed_back.0
 fca = substr(feed_back.i,2,fca_l)
 if fca = "FREE CELLS AVAILABLE" then
  do
   indata = feed_back.i          /* string to be parsed...        */
   call pullnums indata           /* parseing routine            */
   num_fca = pnums                 /* output from parse routine */
   say 'Free Cells Available = 'num_fca
    if num_fca <= '0' then exit 1
  end
 else
  iterate i
end i
return retcode;

/* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */
/* Issue Console Command                                             */
/* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */
issue_console_command:
address 'TSO'
drop Cart_V ;
Cart_V = 'MVSBI'random(100,)
 "consprof soldisp(no) solnum(30) unsoldisp(no)"
  "console activate name("Cart_V")"
 retcode = rc;                             /* Save the return code    */
 if retcode <> 0                           /* Did it work ??          */
    then do;                               /*     no, tell them       */
            Say "Console Activate Failed with rc=" retcode;
            return retcode;
            end;
  "CONSOLE SYSCMD("con_cmd") CART("Cart_V")"
  getcode = getmsg('feed_back.','SOL',Cart_V,,30)
 retcode = getcode;                        /* Save the return code    */
 if retcode <> 0                           /* Did it work ??          */
    then do;                               /*     no, tell them       */
            Say "Console GetMsg Failed with rc=" retcode;
            return retcode;
            end;
 "console deactivate"
 retcode = rc;                             /* Save the return code    */
 if retcode <> 0                           /* Did it work ??          */
    then do;                               /*     no, tell them       */
            Say "Console Deactivate Failed with rc=" retcode;
            return retcode;
            end;
return retcode;

/* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */
/* Turn off Console                                                  */
/* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */
con_off:
 address TSO
  msg_status = MSG("OFF");
  "console deactivate"
  msg_status = MSG("ON");
return retcode;

/* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */
/* Display Job using Library Services                                */
/* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */
display_job:
"ISPEXEC LMINIT DATAID(LMID) DDNAME($TMPLIB$)"
"ISPEXEC browse DATAID(&LMID)"
"ISPEXEC LMFREE DATAID(&LMID)"
return retcode;

/* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */
/* Free and Delete Work file                                         */
/* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */
delete_work_file:
Address 'TSO' 'FREE F($TMPLIB$) DELETE'
return retcode;

/* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */
/* Group Records                                                     */
/* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */
cre_rec_grps: procedure ,
 expose NumRecPerCard record. rec_grp. rg ;
 wrk_var = ''; counter = 1; rg = 0;
 do i = 1 to record.0               /* process all records   */
  wrk_var = wrk_var || ' ' || strip(record.i,b) ;
  if counter = NumRecPerCard | i = record.0 then
   do
    rg = rg + 1; rec_grp.rg = wrk_var||' -';
    wrk_var = ''; counter = 0 ;
   end
  counter = counter + 1;
 end i
return retcode;

/* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */

/* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */
/* Pull only Numbers...                          04/12/1999 - brg    */
/* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */
pullnums: procedure expose indata pnums ;
 j = '1'; pnums = ''; ln = length(indata);    /* init vars     */
  do j = 1 to ln
   do while datatype(substr(indata,j,1))='NUM' /* it's a number */
    pnums=pnums||substr(indata,j,1); j=j+1;   /* concat & ink  */
   end
  end j
return pnums
/* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */

/* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */
/* Signal On Error Routine                                           */
/* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */
error:
say '----------------------------------------------------------- '
say ' The return code from the command on line' SIGL 'is:' RC
say '----------------------------------------------------------- '
call close_work_file
call close_input_file
exit 13;
return retcode;

/* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */
/* End of exec...                                                    */
/* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */