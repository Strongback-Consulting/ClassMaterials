      ******************************************************************
      * Licensed materials - Property of IBM                           *
      * 5724-T07 © Copyright IBM Corp. 2012                            *
      * All rights reserved                                            *
      * US Government users restricted rights  -  Use, duplication or  *
      * disclosure restricted by GSA ADP schedule contract with IBM    *
      * Corp.                                                          *
      *                                                                *
      * IBM Rational Developer for System z (RDz)                      *
      * IBM z/OS Automated Unit Testing Framework (zUnit)              *
      * Enterprise COBOL zUnit Test Case Sample AZUTC001               *
      * ANAGRAM.cpy                                                    *
      *                                                                *
      * This file contains the input-output interface for program      *
      * ANAGRAM which is part of the Enterprise COBOL zUnit test case  *
      * sample AZUTC001.                                               *
      *                                                                *
      * @since   8.5.0.0                                               *
      * @version 8.5.0.0                                               *
      ******************************************************************
       01 ANAGRMIO.
          02 FIRST-WORD-LEN PIC 9(3).
          02 FIRST-WORD PIC X(128).
          02 SECOND-WORD-LEN PIC 9(3).
          02 SECOND-WORD PIC X(128).
          02 RESULT PIC X(1).
             88 IS-ANAGRAM  VALUE 'Y'.
             88 NOT-ANAGRAM VALUE 'N'.
             88 INPUT-ERROR VALUE 'E'.
          02 STATUS-MSG-LEN PIC 9(3).
          02 STATUS-MSG PIC X(128).