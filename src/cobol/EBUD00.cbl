       IDENTIFICATION DIVISION.
       PROGRAM-ID. EBUD00.
      *----------------------------------------------------------------
      * EBUD00 - batch entry point for the debugger and coverage labs
      *
      * Copyright (c) 2026 Strongback Consulting
      * SPDX-License-Identifier: MIT
      * Released under the MIT License; see LICENSE at the root of the
      * ClassMaterials repository.
      *----------------------------------------------------------------
      *
      * Run it with src/jcl/EBUDRUN.jcl, passing a date in the form
      * CCYYMMDD as the PARM - for example PARM='19900315'.
      *
      * z/OS hands a PARM to the first program of a step as a halfword
      * length followed by the text, which is the layout of PARM-AREA
      * below. EBUD00 checks that it was given an eight-digit date,
      * then calls EBUD01, which reports the days since that date (by
      * calling EBUD02) and the retirement date 65 years on (by
      * calling EBUD03). That chain, EBUD00 -> EBUD01 -> EBUD02 and
      * EBUD03, is what the debugger lab steps into.
      *
      * EBUD01, EBUD02 and EBUD03 are IBM sample programs and keep
      * their own notices; this licence covers EBUD00 only.
      *----------------------------------------------------------------
       ENVIRONMENT DIVISION.
       DATA DIVISION.
       WORKING-STORAGE SECTION.
       01  W-CALL-PROGRAM          PIC X(8) VALUE 'EBUD01'.
      *
       LINKAGE SECTION.
       01  PARM-AREA.
           05  PARM-LENGTH         PIC S9(4) COMP.
           05  PARM-DATE           PIC X(8).
      *
       PROCEDURE DIVISION USING PARM-AREA.
       A000-MAINLINE.
      *    Only look at PARM-DATE once we know eight bytes were passed.
           IF PARM-LENGTH = 8
               IF PARM-DATE IS NUMERIC
                   PERFORM A100-CALL-EBUD01
               ELSE
                   PERFORM A900-REJECT-PARM
               END-IF
           ELSE
               PERFORM A900-REJECT-PARM
           END-IF
           GOBACK.
      *
       A100-CALL-EBUD01.
           DISPLAY 'EBUD00 - INPUT DATE:  ' PARM-DATE
           CALL W-CALL-PROGRAM USING PARM-AREA
      *    EBUD01 leaves the input year in RETURN-CODE. Reset it, so a
      *    good run of this step ends with return code 0.
           MOVE 0 TO RETURN-CODE.
      *
       A900-REJECT-PARM.
           DISPLAY 'EBUD00 - PARM MUST BE A DATE AS CCYYMMDD, '
                   'FOR EXAMPLE PARM=''19900315'''
           MOVE 8 TO RETURN-CODE.
