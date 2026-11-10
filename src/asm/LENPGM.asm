* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * **  00010000
* This program read a 255 byte input string, reverses it, fills low- *  00020006
* values with spaces and return the length of the string to the      *  00030000
* caller.                                                            *  00040000
* Program Input : 255 byte input string                              *  00050006
* Program Output: Length of Input String                             *  00060012
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * **  00061006
* Sample COBOL invocation :                                          *  00062006
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * **  00062106
*   WORKING-STORAGE SECTION.                                         *  00063006
*   01 WORK1.                                                        *  00064006
*     02 LEN1   PIC 9(4).                                            *  00065006
*     02 STRING1 PIC X(255).                                         *  00066006
*   PROCEDURE DIVISION.                                              *  00067006
*   PROGRAM-PARA.                                                    *  00068006
*       MOVE 'INPUT STRING            ' TO STRING1.                  *  00069006
*       CALL 'LENPGM' USING WORK1.                                   *  00069106
*String length will be returned in variable LEN1.                    *  00069206
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * **  00070000
         PRINT GEN                                                      00080000
LENPGM   CSECT                                                          00090000
         STM   14,12,12(13)      HOUSEKEEPING                           00100000
         LR    12,15             LOAD BASE REGISTER WITH PGM ENTRY      00110000
         USING LENPGM,12         ESTABLISH BASE REGISTER                00120000
         LR    11,13             LOAD OLD SAVEA TO R11                  00130000
         LA    13,SAVE           LOAD NEW SAVEA TO R13                  00140000
         ST    11,4(13)          BACKWARD CHAIN                         00150000
         ST    13,8(11)          FWD CHAIN                              00160000
         L     R7,0(R1)          LOAD PARM ADDRESS TO R7                00170007
         USING MYD1,R7           DSECT IT                               00180000
         MVC   STR1,VAR1         MOVE INPUT STRING TO STR1              00190000
*                                                                       00200000
         LR    R9,R1             SAVE PARM ADDRESS TO R9                00210000
*                                                                       00220000
         LA    R2,STR1           ADDRESS STR1                           00230003
         LA    R1,STR2           ADDRESS STR2                           00240003
*                                                                       00250000
         MVCIN 0(255,1),254(2)   REVERSE INPUT STR1                     00290010
*                                                                       00291007
         LA    R5,STR2           LOAD STR2(REVERSED STRING)             00300000
         L     R4,=F'255'        LOAD MAX VALUE                         00310011
         SR    R10,R10           CLEAR R10                              00320000
LOOP1    DS    0H                LOOP1 ROUTINE                          00330000
         CLC   0(1,R5),=X'00'    CHECK FOR NULL                         00360000
         BE    MLOWVAL           FOUND ? BRANCH TO MLOWVAL              00370000
         B     AROUND1           NO ? BRANCH TO AROUND1                 00380000
MLOWVAL  DS    0H                                                       00390000
         MVC   0(1,R5),=CL1' '   CONVERT LOW VALUES TO SPACES           00400000
AROUND1  DS    0H                                                       00410000
         LA    R5,1(R5)          BUMP R5                                00420000
         BCT   R4,LOOP1          DECREMENT R4 AND GOTO LOOP1            00430000
*                                                                       00440000
LAROUND  DS    0H                                                       00450000
         LA    R5,STR2           ADDRESS STR2                           00460000
         L     R4,=F'255'        LOAD MAX VALUE OF I/P TO R4            00470011
LOOP2    DS    0H                LOOP2 ROUTINE                          00480000
         CLC   0(1,R5),=CL1' '   COMPARE STR2 FOR SPACES                00490000
         BE    AROUND2           FOUND ? BRANCH TO AROUND1              00500000
         A     R10,=F'1'         NO ? BUMP COUNTER                      00510000
AROUND2  DS    0H                                                       00520000
         LA    R5,1(R5)          BUMP R5                                00530000
         BCT   R4,LOOP2          DECREMENT R4 AND GOTO LOOP2            00540000
         LR    R1,R9                                                    00550002
*        L     R5,0(R1)                                                 00560006
*        USING MYD1,R5                                                  00570006
*                                                                       00580000
         CVD   R10,DEC1          CONVERT R10 TO PACKED                  00590000
         UNPK  LEN1,DEC1         UNPACK IT                              00600000
         OI    LEN1+3,X'F0'      REMOVE SIGN                            00610000
*PROGRAM VARIABLES/CONSTANTS                                            00620007
AROUND   DS    0H                                                       00660000
         L     R13,SAVE+4                                               00670000
         LM    14,12,12(13)                                             00680000
         LA    15,0                                                     00690000
         BR    14                                                       00700000
SAVE     DS    18F                                                      00710000
STR1     DS    CL255                                                    00730005
STR2     DS    CL255                                                    00740011
DEC1     DS    D                                                        00750000
         YREGS                                                          00760000
MYD1     DSECT                                                          00770000
HALFB    DS    0H                                                       00780000
LEN1     DS    CL4                                                      00790000
VAR1     DS    CL255                                                    00800008
         END                                                            00810000