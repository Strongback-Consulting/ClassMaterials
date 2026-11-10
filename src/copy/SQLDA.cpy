      *****************************************************
      * SQL DESCRIPTOR AREA                               *
      *****************************************************
       01  SQLDA.
               02  SQLDAID     PIC X(8)   VALUE 'SQLDA   '.
               02  SQLDABC     PIC S9(8) COMPUTATIONAL  VALUE 33016.
               02  SQLN        PIC S9(4) COMPUTATIONAL  VALUE 750.
               02  SQLD        PIC S9(4) COMPUTATIONAL  VALUE 0.
               02  SQLVAR      OCCURS 1 TO 750 TIMES
                                        DEPENDING ON SQLN.
                   03  SQLTYPE     PIC S9(4) COMPUTATIONAL.
                   03  SQLLEN      PIC S9(4) COMPUTATIONAL.
                   03  SQLDATA     POINTER.
                   03  SQLIND      POINTER.
                   03  SQLNAME.
                       49  SQLNAMEL    PIC S9(4) COMPUTATIONAL.
                       49  SQLNAMEC    PIC X(30).