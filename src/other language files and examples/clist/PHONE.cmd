PROC 0 NAME(SMITH)

 /**********************************************************************/
 /* THIS CLIST (PHONE) SEARCHES A DATA SET FOR A NAME THAT MATCHES THE */
 /* NAME SUPPLIED TO THE CLIST. IF A MATCH IS FOUND, THE CORRESPONDING */
 /* TELEPHONE NUMBER IS DISPLAYED AT THE TERMINAL. OTHERWISE, A MESSAGE IS */
 /* ISSUED INFORMING THE USER THAT A MATCH WAS NOT FOUND.              */
 /**********************************************************************/

 /**********************************************************************/
 /* ALLOCATE THE INPUT DATA SET FOR THE CLIST.                         */
 /**********************************************************************/

 alloc f(sysdval) da('DDS0001.PHONE.DATA') shr reu


 /* OPEN THE FILE, AND SET UP AN ERROR ROUTINE TO HANDLE END-OF-FILE.  */
 /**********************************************************************/

 CONTROL NOMSG NOFLUSH
 ERROR +
  DO
   IF &LASTCC = 400 THEN +
    DO
     WRITENR The name requested, &NAME, was not found in the staff
     WRITE directory.
     SET DONE=YES
    END
   RETURN
  END /* END OF END-OF-FILE ROUTINE                                    */
 SET DONE=NO
 OPENFILE SYSDVAL
 /**********************************************************************/
 /* THIS LOOP RETRIEVES RECORDS FROM THE INPUT DATA SET UNTIL A MATCH  */
 /* IS FOUND OR END OF FILE IS REACHED.  IF A MATCH IS FOUND, THE      */
 /* SECOND VARIABLE ON THE READDVAL STATEMENT (THE ONE CONTAINING      */
 /* THE TELEPHONE NUMBER) IS DISPLAYED.                                */
 /**********************************************************************/

 DO WHILE &DONE=NO
  GETFILE SYSDVAL
  READDVAL LNAME PHONUMBR
  IF &STR(&NAME) = &STR(&LNAME) THEN +
   DO
    WRITE &PHONUMBR
    SET DONE=YES
   END
 END
 CLOSFILE SYSDVAL
 free file(sysdval)