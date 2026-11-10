#include <leawi.h>
#include <string.h>
main ()
{
  _FEEDBACK   fbcode;            /* fbcode for all callable services */

/*********************************************************************/
/* Parameters passed to CEEMOUT.  Typedefs found in leawi.h.         */
/*********************************************************************/
  _VSTRING    msg;
  _INT4       destination;
/*********************************************************************/
/* Parameters passed to CEELOCT.  Typedefs found in leawi.h.         */
/*********************************************************************/
  _INT4       lildate;
  _FLOAT8     lilsecs;
  _CHAR17     greg;
/*********************************************************************/
/* Parameters passed to CEEDATE.  Typedefs found in leawi.h.         */
/*********************************************************************/
  _CHAR80  str_date;
  _VSTRING pattern;
/*********************************************************************/
/* Starting and ending messages                                      */
/*********************************************************************/
  _CHAR80  startmsg  = "Callable service example starting (C/370).";
  _CHAR80  endingmsg = "Callable service example ending (C/370).";

/*********************************************************************/
/* Start execution. Print the first message.                         */
/*********************************************************************/
  destination = 2;
  strcpy( msg.string, startmsg );
  msg.length  = strlen( msg.string );
  CEEMOUT ( &msg, &destination, &fbcode );
/*********************************************************************/
/* Get the local date and time, format it, and print it out.         */
/*********************************************************************/
  CEELOCT ( &lildate, &lilsecs, greg, &fbcode );
  strcpy  ( pattern.string,\
          "Today is Wwwwwwwwwwwwz, Mmmmmmmmmmz ZD, YYYY." );
  pattern.length = strlen( pattern.string );
  memset ( msg.string , ' ' , 80 );
  CEEDATE ( &lildate, &pattern, msg.string, &fbcode );
  msg.length = 80;
  CEEMOUT ( &msg, &destination, &fbcode );
/*********************************************************************/
/* Say goodbye.                                                      */
/*********************************************************************/
  strcpy  ( msg.string, endingmsg );
  msg.length = strlen( msg.string );
  CEEMOUT ( &msg, &destination, &fbcode );
}
