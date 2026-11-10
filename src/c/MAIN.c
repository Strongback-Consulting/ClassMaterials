/* Module/File Name:  EDCCXC  */
/*  Program-ID: MAIN  */
/* Resolved Conflict */
/*********************************************************************/
/* CPROGRAM, compile with rent and longname                          */
/*********************************************************************/
#include <stdio.h>
#include <stdlib.h>

typedef struct
{
int length;
int width;
  } rectngl;

extern void printrec(rectngl r);
extern void change_width(rectngl* r, int w);

int CFUNC(rectngl *mine)
    {
  int rc;

 printrec(*mine);
    change_width(mine, rc, 5);

#ifdef debug
    printrec( *mine);
#endif

  printrec(*mine);

  if (mine->width != 5)
return (1);
    else
return (0);

    }
