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
      * ANAGRAM.cbl                                                    *
      *                                                                *
      * This file contains a program ANAGRAM that is part of the       *
      * Enterprise COBOL zUnit test case sample AZUTC001. ANAGRAM      *
      * tests if one word or phrase is an anagram of another, but it   *
      * has an intentional flaw where punctuation causes false         *
      * negatives.                                                     *
      *                                                                *
      * @since   8.5.0.0                                               *
      * @version 8.5.0.0                                               *
      ******************************************************************
       IDENTIFICATION DIVISION.
        PROGRAM-ID. 'ANAGRAM'.
       DATA DIVISION.
       WORKING-STORAGE SECTION.
       01 WORD-BUF-1 PIC X(999).
       01 WORD-BUF-2 PIC X(999).
       01 CMPTMPA PIC S9(9) COMP-5.
       LINKAGE SECTION.
       COPY ANAGRAM.
       PROCEDURE DIVISION USING ANAGRMIO.
       MAINLINE SECTION.
           DISPLAY 'ANAGRAM STARTED...'
           PERFORM VALIDATE-INPUT
           PERFORM ANAGRAM-TEST
           DISPLAY 'ANAGRAM SUCCESSFUL'
           GOBACK
           .
       VALIDATE-INPUT.
           INITIALIZE STATUS-MSG-LEN STATUS-MSG
           IF FIRST-WORD-LEN = 0
             MOVE 1 TO CMPTMPA
             STRING 'ANAGRAM ERROR, FIRST-WORD-LEN IS ZERO.'
               DELIMITED BY SIZE INTO STATUS-MSG
               WITH POINTER CMPTMPA
             END-STRING
             COMPUTE STATUS-MSG-LEN = CMPTMPA - 1
             SET INPUT-ERROR TO TRUE
             MOVE 16 TO RETURN-CODE
             GOBACK
           END-IF
           IF FIRST-WORD = SPACES
             MOVE 1 TO CMPTMPA
             STRING 'ANAGRAM ERROR, FIRST-WORD IS BLANK.'
               DELIMITED BY SIZE INTO STATUS-MSG
               WITH POINTER CMPTMPA
             END-STRING
             COMPUTE STATUS-MSG-LEN = CMPTMPA - 1
             SET INPUT-ERROR TO TRUE
             MOVE 16 TO RETURN-CODE
             GOBACK
           END-IF
           IF SECOND-WORD-LEN = 0
             MOVE 1 TO CMPTMPA
             STRING 'ANAGRAM ERROR, SECOND-WORD-LEN IS ZERO.'
               DELIMITED BY SIZE INTO STATUS-MSG
               WITH POINTER CMPTMPA
             END-STRING
             COMPUTE STATUS-MSG-LEN = CMPTMPA - 1
             SET INPUT-ERROR TO TRUE
             MOVE 16 TO RETURN-CODE
             GOBACK
           END-IF
           IF SECOND-WORD = SPACES
             MOVE 1 TO CMPTMPA
             STRING 'ANAGRAM ERROR, SECOND-WORD IS BLANK.'
               DELIMITED BY SIZE INTO STATUS-MSG
               WITH POINTER CMPTMPA
             END-STRING
             COMPUTE STATUS-MSG-LEN = CMPTMPA - 1
             SET INPUT-ERROR TO TRUE
             MOVE 16 TO RETURN-CODE
             GOBACK
           END-IF
           .
       ANAGRAM-TEST.
           SET NOT-ANAGRAM TO TRUE
           INITIALIZE WORD-BUF-1
           MOVE FUNCTION UPPER-CASE(FIRST-WORD(1:FIRST-WORD-LEN))
             TO WORD-BUF-1(1:FIRST-WORD-LEN)
           DISPLAY
              'o FIRST-WORD:' FIRST-WORD(1:FIRST-WORD-LEN) '.'
           CALL 'SORTCHAR' USING FIRST-WORD-LEN WORD-BUF-1
           DISPLAY
              'o WORD-BUF-1:' WORD-BUF-1(1:FIRST-WORD-LEN) '.'
           INITIALIZE WORD-BUF-2
           MOVE FUNCTION UPPER-CASE(SECOND-WORD(1:SECOND-WORD-LEN))
             TO WORD-BUF-2(1:SECOND-WORD-LEN)
           DISPLAY
              'o SECOND-WORD:' SECOND-WORD(1:SECOND-WORD-LEN) '.'
           CALL 'SORTCHAR' USING SECOND-WORD-LEN WORD-BUF-2
           DISPLAY
             'o WORD-BUF-2:' WORD-BUF-2(1:SECOND-WORD-LEN) '.'
           COMPUTE CMPTMPA = FUNCTION MAX(FIRST-WORD-LEN,
                   SECOND-WORD-LEN)
           IF WORD-BUF-1(1:CMPTMPA) = WORD-BUF-2(1:CMPTMPA)
             SET IS-ANAGRAM TO TRUE
           END-IF
           DISPLAY 'o RESULT=' RESULT '.'
           .
       END PROGRAM 'ANAGRAM'.
      ******************************************************************
      * Progam: SORTCHAR
      * Purpose: Sort characters in descending order
      * Author: cipresso@us.ibm.com
      ******************************************************************
       IDENTIFICATION DIVISION.
        PROGRAM-ID. 'SORTCHAR'.
       DATA DIVISION.
       WORKING-STORAGE SECTION.
       01 CMPTMPN PIC S9(9) COMP.
       01 CMPTMPI PIC S9(9) COMP.
       01 CHARTMP PIC X.
       01 SWAPPED PIC X.
       LINKAGE SECTION.
       01 WORD-LEN PIC 9(3).
       01 WORD-BUF PIC X(999).
       PROCEDURE DIVISION USING WORD-LEN WORD-BUF.
       MAINLINE SECTION.
           MOVE WORD-LEN TO CMPTMPN
           PERFORM WITH TEST AFTER UNTIL SWAPPED = 'N'
              MOVE 'N' TO SWAPPED
              PERFORM VARYING CMPTMPI FROM 1 BY 1 UNTIL
                      CMPTMPI >= CMPTMPN
                 IF WORD-BUF(CMPTMPI:1) < WORD-BUF(CMPTMPI + 1:1)
                   MOVE WORD-BUF(CMPTMPI:1) TO CHARTMP
                   MOVE WORD-BUF(CMPTMPI + 1:1)
                     TO WORD-BUF(CMPTMPI:1)
                   MOVE CHARTMP
                     TO WORD-BUF(CMPTMPI + 1:1)
                   MOVE 'Y' TO SWAPPED
                 END-IF
              END-PERFORM
              SUBTRACT 1 FROM CMPTMPN
           END-PERFORM
           .
       END PROGRAM 'SORTCHAR'.