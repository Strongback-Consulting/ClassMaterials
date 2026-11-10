      * DATA AREA FOR TERMINAL INPUT

       01  INPUT-AREA.
           02  IN-BLANK  PIC  X(80).
           02  IN-TEXT REDEFINES IN-BLANK.
               03  IN-COMMAND    PIC  X(8).
               03  TEMP-COMMAND REDEFINES IN-COMMAND.
                   04  TEMP-IOCMD PIC  X(3).
                   04  FILLER     PIC  X(5).
               03  IN-LAST-NAME  PIC  X(10).
               03  IN-FIRST-NAME PIC  X(10).
               03  IN-EXTENSION  PIC  X(10).
               03  IN-ZIP-CODE   PIC  X(7).
               03  INFILL        PIC  X(35).

      * DATA AREA OUTPUT

       01  OUTPUT-AREA.
           02  OUT-BLANK  PIC  X(85).
           02  OUT-TEXT REDEFINES OUT-BLANK.
               03  OUT-MESSAGE   PIC  X(40).
               03  OUT-COMMAND   PIC  X(8).
               03  OUT-DATA.
                   04  OUT-LAST-NAME   PIC  X(10).
                   04  OUT-FIRST-NAME  PIC  X(10).
                   04  OUT-EXTENSION   PIC  X(10).
                   04  OUT-ZIP-CODE    PIC  X(7).
           02  OUT-SEGMENT-NO    PIC  9(4).
           02  OUT-FILL          PIC  X(32).