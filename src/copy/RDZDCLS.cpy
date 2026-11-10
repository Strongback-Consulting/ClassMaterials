      ******************************************************************
      * DCLGEN TABLE(IBMUSER.FRIENDZ)                                  *
      *        LIBRARY(IBMUSER.ZUNIT.COPYLIB(RDZDCLS))                 *
      *        LANGUAGE(COBOL)                                         *
      *        STRUCTURE(FRIENDZRECORD)                                *
      *        APOST                                                   *
      * ... IS THE DCLGEN COMMAND THAT MADE THE FOLLOWING STATEMENTS   *
      ******************************************************************
           EXEC SQL DECLARE IBMUSER.FRIENDZ TABLE
           ( FNAME                          CHAR(10) NOT NULL,
             LNAME                          CHAR(10) NOT NULL,
             PHONE                          CHAR(10) NOT NULL,
             EMAIL                          CHAR(30) NOT NULL
           ) END-EXEC.
      ******************************************************************
      * COBOL DECLARATION FOR TABLE IBMUSER.FRIENDZ                    *
      ******************************************************************
       01  FRIENDZRECORD.
           10 FNAME                PIC X(10).
           10 LNAME                PIC X(10).
           10 PHONE                PIC X(10).
           10 EMAIL                PIC X(30).
      ******************************************************************
      * THE NUMBER OF COLUMNS DESCRIBED BY THIS DECLARATION IS 4       *
      ******************************************************************