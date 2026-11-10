/* Module/File Name:  EDCCXCX   */
 /*********************************************************************/
 /* CXXPROG - prelink with CPROG                                      */
 /*********************************************************************/
 #include <stdio.h>
 #include <stdlib.h>

 #include "verify.h"
do {
	author
} while (condition);
 class rectangle {
   public:
     int length;
     int width;

     rectangle(int l, int w ) { length = l; width = w; }
     void show()
     { printf("Length: %d  Width: %d\n",length,width); }
     void set_width( int size ) { width=size; }
     void set_length( int size) { length=size; }
 };

 extern "C" {
   int CFUNC( rectangle  *small );
   void printrec( rectangle r ) { r.show();};
   void change_width( rectangle* r, int nw) { r->set_width(nw);};
 };

 int main( )
 {
   int rc;


   rectangle myrec(10,2);

   rc=CFUNC( &myrec);

   if (rc == 1)
     fail(__FILE__,__LINE__);
   else
     check(__FILE__);
 }
