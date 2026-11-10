       IDENTIFICATION DIVISION.
       PROGRAM-ID. PBILOG.

      * This COBOL program is generated from following ruleset:
      *     IMS_Phonebook
      * It is created from JRules Studio at 2009/05/27 14:47:27.
      * It includes following rules:
      *     validation.Zipcode

       DATA DIVISION.
       WORKING-STORAGE SECTION.
       01 LOCALAREA.
           02 MAPPEDMETHOD1-MSG PIC X(40).
           02 STRTEMP1 PIC X(27) VALUE "The Zip Code is  not valid ".
       LINKAGE SECTION.
           COPY IMSPHBK2.

       PROCEDURE DIVISION USING INPUT-AREA OUTPUT-AREA.
      * Task: mainflow
       TASK1-MAINFLOW.
           MOVE SPACES TO MAPPEDMETHOD1-MSG.
           PERFORM TASK2-MAINFLOW-VALIDATION

           GOBACK.
      * Task: mainflow#validation
       TASK2-MAINFLOW-VALIDATION.
           PERFORM RULE1-VALIDATION-ZIPCODE.
      * Rule: validation.Zipcode
       RULE1-VALIDATION-ZIPCODE.
           IF IN-ZIP-CODE OF IN-TEXT OF INPUT-AREA < 96162 AND
           IN-ZIP-CODE OF IN-TEXT OF INPUT-AREA > 90001
               MOVE STRTEMP1 OF LOCALAREA TO MAPPEDMETHOD1-MSG
               PERFORM MAPPEDMETHOD1
               PERFORM MAPPEDMETHOD2
           END-IF.

      * Mapped method: Util.addMessage
       MAPPEDMETHOD1.

      * Mapped method: Util.reject
       MAPPEDMETHOD2.
           MOVE MAPPEDMETHOD1-MSG TO OUT-FILL.