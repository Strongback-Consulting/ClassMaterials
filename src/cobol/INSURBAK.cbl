       IDENTIFICATION DIVISION.
      ******************************************************************
      **** THIS PROGRAM CREATES A REPORT TOTALING INSURANCE CLAIMS
      **** ENTERED OVER THE PAST WEEK
      **** IT USES INTRINSIC FUNCTIONS TO GET & FORMAT THE CURRENT DATE
      **** AND USES THE STRING FUNCTION TO INSERT "/" INTO DATE FIELDS
      **** THIS MULTI-LINE REPORT IS TYPICAL OF BACK-OFFICE COBOL
      ******************************************************************
      * INSURCOB                                                       *
      * Compile/Link this program for Debug and - using batch JCL:     *
      *  Using the batch JCL supplied by Strongback:                   *
      *    1. Run the program to Normal EOJ                            *
      *    2. Verify the outputs (CLAIMRPT & SYSOUT)                   *
      *    3. Add the //CEEOPTS TEST card to Debug the program         *
      *       Note: There are 10 Debug techniques buried in the code   *
      *    4. Add the   ENVAR(*"EQA_STARTUP_KEY=CC") for code coverage *
      *                                                                *
      ******************************************************************
      ** TO DO **
      *        Code Coverage - including -except and -include
      *                      - and Filter  - add Filter/73-80 in code
      ******************************************************************
       PROGRAM-ID.      INSURCOB.
       AUTHOR.          IBM.
      ******************************************************************
      * Launch Debug for the labs in this module
      *   Submit INSURRUN.jcl  Click OK & Confirm the Perspective Switch
      *   *** NOTE *** YOU WILL REMAIN IN THE DEBUG PERSPECTIVE
      *       THROUGHOUT ALL OF THE DEBUG & CODE COVERAGE LABS
      ******************************************************************
      * #0 Understand INSURCOB's execution flow (Static Code Analysis)
      *    Set your mouse focus in the program code and select;
      *        Show In   >  Program Control Flow
      *    - How does control end up in 999-ERROR-RTN?
      *        In Program Control Flow:
      *           - Zoom out (use the magnifying glass)
      *           - Right-click over 999-ERROR-RTN
      *           - Select Show Program Control Flow to Here
      ******************************************************************
      * #1 Initialize the program and debug session
      *    Step(F5) several times using the Step icon on the toolbar
      *      Note that at the beginning of your debug session, Step(F5):
      *          -Loads your Load Module into a z/OS address spaces
      *          -Resolves addresses
      *          -Initializes your Debugging session allowing you to
      *              set breakpoints and variable monitors, etc.
      *    Terminate (Ctrl+F2) the Debug session
      *
      *    Access other IDz Views from within Debug
      *     From the Debug Perspective, click on the Remote Systems view
      *     From JES:
      *          -Refresh My Jobs (F5)
      *          -Find and open the latest Debug Job
      *          -Find, open and review the spool file: GO:RUN:CLAIMRPT
      *
      ******************************************************************

       ENVIRONMENT DIVISION.
       INPUT-OUTPUT SECTION.
       FILE-CONTROL.
           SELECT CLAIMFILE
             ASSIGN TO UT-S-CLAIM
               ORGANIZATION IS SEQUENTIAL
               FILE STATUS IS CLAIMFILE-ST.
           SELECT PRINTFILE
             ASSIGN TO CLAIMRPT
               ORGANIZATION IS SEQUENTIAL
               FILE STATUS IS PRINTFILE-ST.

       DATA DIVISION.
       FILE SECTION.
       FD  CLAIMFILE
           RECORD CONTAINS 80 CHARACTERS.
       01 CLAIM-RECORD                  PIC X(80).

       FD  PRINTFILE
           RECORD CONTAINS 132 CHARACTERS.
       01 PRINT-LINE                    PIC X(132).

       WORKING-STORAGE SECTION.
       77 WS-STORAGE-IND                PIC X(60)
                                                       VALUE
               'WORKING STORAGE BEGINS HERE'.

       77 ALLOWED-AMT                       PIC S9(7)V99
                                                VALUE 9999999.99.
       77 DEDUCTIBLE-PERC                   PIC V999
                                                VALUE .002.

       77 WS-CALLED-PROGRAM                 PIC X(8) VALUE SPACES.

       01  CLAIM-RECORD-WS.
           05  INSURED-DETAILS.
               10  INSURED-POLICY-NO        PIC 9(7).
               10  INSURED-LAST-NAME        PIC X(15).
               10  INSURED-FIRST-NAME       PIC X(10).
           05  POLICY-DETAILS.
               10  POLICY-TYPE              PIC 9(1).
                  88 EMPLOYER VALUE 1.
                  88 MEDICARE VALUE 2.
                  88 AFFORDABLE-CARE VALUE 3.
               10  POLICY-BENEFIT-PERIOD.
                  15 POLICY-YEAR            PIC 9(4).
                  15 POLICY-MONTH           PIC 9(2).
                  15 POLICY-DAY             PIC 9(2).
               10  POLICY-BENEFIT-DATE-X
                       REDEFINES POLICY-BENEFIT-PERIOD PIC X(8).
               10 POLICY-AMOUNT             PIC 9(7).
               10 POLICY-DEDUCTIBLE-PAID    PIC 9(4).
               10 POLICY-COINSURANCE        PIC V99.
           05  CLAIM-DETAILS.
               10 CLAIM-AMOUNT              PIC 9(7)V99.
               10 CLAIM-AMOUNT-PAID         PIC 9(7)V99.
           05  FILLER                       PIC X(08).

       01 PROGRAM-SWITCHES.
           05 REINSURANCE                   PIC XX         VALUE SPACES.
           05 INSURED-SUB                   PIC 999        VALUE 1.
           05 CLAIMFILE-EOF                 PIC X(1)       VALUE 'N'.
               88 NO-MORE-CLAIMS                       VALUE 'Y'.
           05 CLAIMFILE-ST                  PIC X(2).
               88 CLAIMFILE-OK                         VALUE '00'.
           05 PRINTFILE-ST                  PIC X(2).
               88 PRINTFILE-OK                         VALUE '00'.
           05 BENEFIT-PERIOD                PIC X(1).
               88 BENEFIT-PERIOD-OK                    VALUE 'Y'.
           05 POLICY-DEDUCTIBLE-MET-WS      PIC X(1).
               88 DEDUCTIBLE-MET                       VALUE 'Y'.
           05 FIRST-TIME-WS                 PIC X(1).
               88 FIRST-TIME                           VALUE 'Y'.
           05 PAY-THE-CLAIM-WS              PIC X(1).
               88 PAY-THE-CLAIM                        VALUE 'Y'.

       01 COUNTERS-AND-ACCUMULATORS-WS.
           05 DUMP-LOC-WS                   PIC X(8) VALUE 'COUNTERS'.
           05 DEDUCTIBLE-WS                 PIC S9(5)V99 COMP-3.
           05 CLAIM-PAID-WS                 PIC S9(7)V99 COMP.
           05 CALL-FEEDBACK-WS              PIC X(2) VALUE SPACES.

       01 DATE-FIELDS-WS.
           05 CURR-DATE-OUT                 PIC X(10).
           05 CURR-DATE-WS                  PIC S9(8).
           05 CURR-DATE-WS-X REDEFINES CURR-DATE-WS.
               10 WS-YEAR                   PIC X(4).
               10 WS-MONTH                  PIC X(2).
               10 WS-DAY                    PIC X(2).

       01 REPORT-FIELDS.
           05 LINE-COUNT                    PIC S9(2)       VALUE +6.
           05 PAGE-COUNT                    PIC S9(2)       VALUE ZEROS.
           05 LINES-PER-PAGE                PIC S9(2)       VALUE +5.

       01 TOT-BILL-INFORMATION.
           05 TOT-POLICY-AMOUNT             PIC S9(9)V99.
           05 TOT-DEDUCTIBLE-PAID           PIC S9(9)V99.
           05 TOT-CLAIM-AMOUNT-PAID         PIC S9(9)V99.
           05 TOT-CLAIM-AMOUNT              PIC S9(9)V99.
      **
      ** Report Lines start here
      **
       01 HEADING-LINE-ONE.
           05 HDG-DATE                  PIC XXXX/XX/XX.
           05 FILLER                    PIC X(46)      VALUE SPACES.
           05 FILLER                    PIC X(25)
                  VALUE 'Group Claims Daily Totals'.
           05 FILLER                    PIC X(10)      VALUE SPACES.
           05 HDG-DAY                   PIC X(9).
           05 FILLER                    PIC X(3)       VALUE ' '.
           05 FILLER                    PIC X(31)      VALUE SPACES.
           05 FILLER                    PIC X(5)       VALUE 'Page '.
           05 HDG-PAGE-NUMBER           PIC Z9         VALUE ZERO.
           05 FILLER                    PIC X(3)       VALUE SPACES.

       01 HEADING-LINE-TWO.
           05 FILLER                    PIC X(24)      VALUE 'POLICY'.
           05 FILLER                    PIC X(11)      VALUE 'POLICY'.
           05 FILLER                    PIC X(15)      VALUE 'FIRST'.
           05 FILLER                    PIC X(13)      VALUE 'LAST'.
           05 FILLER                    PIC X(14)      VALUE 'RENEW'.
           05 FILLER                    PIC X(8)       VALUE 'COPAY'.
           05 FILLER                    PIC X(9)       VALUE 'COPAY'.
           05 FILLER                    PIC X(14)      VALUE 'DEDUC'.
           05 FILLER                    PIC X(14)      VALUE 'CLAIM'.
           05 FILLER                    PIC X(14)      VALUE 'CLAIM'.

       01 HEADING-LINE-THREE.
           05 FILLER                    PIC X(24)      VALUE 'TYPE'.
           05 FILLER                    PIC X(11)      VALUE 'NUMBER'.
           05 FILLER                    PIC X(15)      VALUE 'NAME'.
           05 FILLER                    PIC X(13)      VALUE 'NAME'.
           05 FILLER                    PIC X(15)      VALUE 'DATE'.
           05 FILLER                    PIC X(6)       VALUE 'MET'.
           05 FILLER                    PIC X(10)      VALUE 'PERCENT'.
           05 FILLER                    PIC X(14)      VALUE 'AMOUNT'.
           05 FILLER                    PIC X(14)      VALUE 'AMOUNT'.
           05 FILLER                    PIC X(14)      VALUE 'PAID'.

       01 HEADING-LINE-FOUR.
           05 FILLER                    PIC X(23)      VALUE ALL '-'.
           05 FILLER                    PIC X(01)      VALUE SPACE.
           05 FILLER                    PIC X(10)      VALUE ALL '-'.
           05 FILLER                    PIC X(01)      VALUE SPACE.
           05 FILLER                    PIC X(14)      VALUE ALL '-'.
           05 FILLER                    PIC X(01)      VALUE SPACE.
           05 FILLER                    PIC X(12)      VALUE ALL '-'.
           05 FILLER                    PIC X(01)      VALUE SPACE.
           05 FILLER                    PIC X(13)      VALUE ALL '-'.
           05 FILLER                    PIC X(01)      VALUE SPACE.
           05 FILLER                    PIC X(5)       VALUE ALL '-'.
           05 FILLER                    PIC X(01)      VALUE SPACE.
           05 FILLER                    PIC X(7)       VALUE ALL '-'.
           05 FILLER                    PIC X(01)      VALUE SPACE.
           05 FILLER                    PIC X(09)      VALUE ALL '-'.
           05 FILLER                    PIC X(01)      VALUE SPACE.
           05 FILLER                    PIC X(15)      VALUE ALL '-'.
           05 FILLER                    PIC X(01)      VALUE SPACE.
           05 FILLER                    PIC X(13)      VALUE ALL '-'.

       01 DETAIL-LINE.
           05 DET-POLICY-TYPE           PIC X(20)      VALUE SPACES.
           05 FILLER                    PIC X(4)       VALUE SPACES.
           05 DET-POLICY-NO             PIC 9B999B99.
           05 FILLER                    PIC X(3)       VALUE SPACES.
           05 DET-NAME.
               10 DET-FIRST-NAME        PIC X(15).
               10 DET-LAST-NAME         PIC X(10).
           05 FILLER                    PIC X(3)       VALUE SPACES.
           05 DET-RENEW-DATE            PIC XXXX/XX/XX.
           05 FILLER                    PIC X(6)       VALUE SPACES.
           05 DET-DEDUCTIBLE-MET        PIC X.
           05 FILLER                    PIC X(5)       VALUE SPACES.
           05 DET-DEDUCTIBLE-PERC       PIC .999.
           05 FILLER                    PIC X(5)       VALUE SPACES.
           05 DET-COINSURANCE           PIC $$$9.
           05 FILLER                    PIC X(6)       VALUE SPACES.
           05 DET-CLAIM-AMOUNT          PIC $$,$$$,$$9.99.
           05 FILLER                    PIC X(3)       VALUE SPACES.
           05 DET-CLAIM-PAID            PIC $$,$$9.99.
           05 FILLER                    PIC X(5)       VALUE SPACES.

       01 TOTAL-DASH-LINE.
           05 FILLER                    PIC X(91)      VALUE SPACE.
           05 FILLER                    PIC X(09)      VALUE ALL '-'.
           05 FILLER                    PIC X(01)      VALUE SPACE.
           05 FILLER                    PIC X(15)      VALUE ALL '-'.
           05 FILLER                    PIC X(01)      VALUE SPACE.
           05 FILLER                    PIC X(13)      VALUE ALL '-'.
       01 TOTAL-LINE-OUT.
           05 FILLER                    PIC X(92)      VALUE SPACES.
           05 TOT-DEDUCTIBLE-OUT        PIC $$$,$$9.99.
           05 FILLER                    PIC X          VALUE SPACES.
           05 TOT-CLAIM-AMOUNT-OUT      PIC $$$,$$$,$$9.99.
           05 FILLER                    PIC XX          VALUE SPACES.
           05 TOT-CLAIM-AMOUNT-PAID-OUT PIC $$$,$$$,$$9.99.
           05 FILLER                    PIC X(5)       VALUE SPACES.

       01 FILLER                        PIC X(12)
                         VALUE 'WS ENDS HERE'.
       01 DATE-VARS.
           05 CURRENT-YEAR      PIC X(4).
           05 CURRENT-MON       PIC X(2).
           05 CURRENT-DAY       PIC X(2).
           05 CURRENT-HOUR      PIC X(2).
           05 CURRENT-MIN       PIC X(2).
           05 CURRENT-SEC       PIC X(2).
           05 CURRENT-MSEC      PIC X(2).
           05 LOCAL-TIME.
             10 TIME-DIF     PIC X(1).
             10 TIME-DIF-H   PIC X(2).
             10 TIME-DIF-M   PIC X(2).
       01 CURRENT-WEEK-DAY   PIC 9(1).
       01 WEEKDAYS-TABLE.
           05                PIC X(9) VALUE "Monday".
           05                PIC X(9) VALUE "Tuesday".
           05                PIC X(9) VALUE "Wednesday".
           05                PIC X(9) VALUE "Thursday".
           05                PIC X(9) VALUE "Friday".
           05                PIC X(9) VALUE "Saturday".
           05                PIC X(9) VALUE "Sunday".
       01 WEEKDAYS-RDF REDEFINES WEEKDAYS-TABLE.
           05 DT-OF-WK            OCCURS 7 TIMES PIC X(9).
      *
       PROCEDURE DIVISION.
      ******************************************************************
      * #2 View DISPLAY statements using Debug Engine Commands
      *    Open the Debug Console view and issue the commands:
      *         SET INTERCEPT ON
      *         SET AUTOMONITOR ON LOG
      *    Step several times into the PROCEDURE DIVISION CODE
      *          - Press F5 - or use the Step Into icon on the toolbar
      *     Note the contents of the Debug Console:
      *       - Automonitored line #s and variable values
      *       - The DISPLAY statement: DT-OF-WK ( CURRENT-WEEK-DAY ) =
      *    Terminate (Ctrl+F2) the Debug session
      ******************************************************************
           MOVE FUNCTION CURRENT-DATE TO DATE-VARS.
           MOVE DATE-VARS TO CURR-DATE-OUT, CURR-DATE-WS
           ACCEPT CURRENT-WEEK-DAY FROM DAY-OF-WEEK.
           DISPLAY "Date: Year " CURRENT-YEAR  " Month " CURRENT-MON
               " Day " CURRENT-DAY "(" DT-OF-WK(CURRENT-WEEK-DAY) ")".
      *
           PERFORM 100-HOUSEKEEPING.
      ******************************************************************
      * #3 Breakpoints
      *    Set (unconditional) Line Breakpoints on these statement:
      *        - CALL statement
      *        - READ statement
      *    Add a Watch Break Point on:  INSURED-POLICY-NO
      *      Note use Ctrl+F to find the CALL, READ & INSURED-POLICY-NO
      *    F8 (Resume) to the Break Points
      *    Terminate (Ctrl+F2) the Debug session
      *
      *    Launch another Debug session. From the Breakpoints view note
      *           that the existing Breakpoints are still in place
      *
      *    Make the Watch Break Point conditional
      *        Right-click and Edit the Watch Break Point
      *        Click Next> and add this condition:
      *              INSURED-POLICY-NO = 3333333
      *    Disable (uncheck) all of the Line Break Points
      *    Resume (F8) to the Conditional Watch Break Point
      *    Terminate (Ctrl+F2) the Debug session
      *
      *    Add an Entry Break Point. Begin your debug session in LOANCOB
      *       - Launch another Debug session
      *       - Before clicking F5, from the Breakpoints view
      *           Right-click and add an Entry... Break point
      *           Check: Defer breakpoint until executable is loaded
      *           The Load module and Object program are:  LOANCOB
      *           The paragraph is:  000-MAIN
      *             Note that from Remote Systems you could open
      *                the source for LOANCOB to find paragraph names
      *       - Click Resume(F8) - you will start debugging in LOANCOB
      *       -  Step a few times then press F7 to return to: INSURCOB
      *                 (the calling program)
      *       -  Resume(F8) - note that you'll stop in LOANCOB
      *       -  Disable the Entry Break Point
      *       -  Resume(F8) to normal EOJ
      *
      *    Export/Import Breakpoints
      *       - Launch another Debug session
      *       - Before clicking F5, from the Breakpoints View
      *           Right-click and select: Export Breakpoints
      *       - Choose a location on your PC and name the file
      *       - Right-Click again in the Breakpoints View and
      *               select: Remove All
      *       - Terminate your Debug session
      *
      *       - Launch another Debug session
      *       - Before clicking F5, from the Breakpoints View
      *           Right-click and select: Import Breakpoints
      *       - Find the location of (Browse to your) saved
      *           Breakpoints file
      *       - Click Finish - note that your Breakpoints were imported
      *       - Test the imported Breakpoints by Resuming to them
      *           in the Debugger. Then Terminate your Debug session
      *
      *  #OPTIONAL BREAKPOINT LAB EXERCISES - Note, test each exercise:
      *     1. Make the Entry Break Point conditional
      *          You can use:  INSURED-POLICY-NO = 3333333
      *     2. Delete (Remove) the Line Breakpoint on the CALL statement
      *     3. Add another Line Breakpoint on the CALL statement
      *     4. Make the Line Breakpoint conditional as follows
      *            INSURED-POLICY-NO = 3333333 AND POLICY-MONTH = 12
      *     5. Disable all of the Breakpoints
      *     6. Press F7 to run to normal EOJ
      *
      ******************************************************************
           PERFORM 200-PROCESS-CLAIM UNTIL NO-MORE-CLAIMS.
           PERFORM 700-WRITE-CLAIM-TOTALS.
           PERFORM 900-WRAP-UP.
           GOBACK.

       100-HOUSEKEEPING.
      ******************************************************************
      *
      * #4 Monitor variables, tables and using Animated Step
      *    Note that before you do this lab, ensure that the
      *        Monitors View is opened: Window Show View > Monitors
      *
      *    Create a Monitored Expression for WEEKDAYS-TABLE
      *    From the Monitors View, experiment with: Change Index Range
      *        - Expand WEEKDAYS-TABLE to see all of the entries
      *        - Right-click on WEEKDAYS-TABLE and: Change Index Range
      *    Monitor these additional variables:
      *         - TOT-BILL-INFORMATION
      *         - COUNTERS-AND-ACCUMULATORS-WS
      *         - CLAIM-RECORD-WS
      *           ** Note use Find to locate the above variables
      *         - Expand all of the monitored variables
      *   Use Animated Step Into to execute the program and watch the
      *       variables in the Monitors View
      *   You'll notice that the Monitors View is not large enough to
      *       contain all of the variable values:
      *         - Undock and enlarge the Monitors View
      *
      *   Experiment with Show Type Names and  Change representation
      *       - Right-click over a variable in the Monitors View
      *           and select:  Show Type Names
      *           - Note the variable declarations
      *       - Show Type Names again (note that it acts as a toggle)
      *
      *       - Right-click over DEDUCTIBLE-WS and select:
      *               Change representation > Hexadecimal
      *             - Note the variable value appears in EBCDIC
      *       - Right-click over DEDUCTIBLE-WS again and
      *               Change representation back to Decimal
      *       - Repeat these steps for:
      *               - CLAIM-PAID-WS
      *               - DUMP-LOC-WS
      *        Return CLAIM-PAID-WS & DEDUCTIBLE-WS to Decimal
      *
      *   Change monitored variable values during Debug
      *       - Right-click over WS-YEAR and select: Change Value
      *           - Make WS-YEAR:  2023
      *              ** Note that you do not need to enter single quotes
      *      Change the following variable values
      *      - From WEEKDAYS-TABLE make Friday -> FRIDAY
      *
      ****OPTIONAL MONITORED VARIABLES LAB EXERCISES****
      *   Modify variables values in Hex
      *     1. Launch Debug and press F5 several time.  (why?)
      *     2. Browse thru WORKING-STORAGE and find a PIC X  field
      *     3. Monitor the field
      *     4. From the Monitors view:
      *          - Show Type Names
      *          - Right-click on your PIC X field and select
      *               Change Representation  => Hexadecimal
      *          - Modify the value in Hex
      *          - Save your new variable value
      *          - Change the Representation => Character
      *          - Verify your work
      *
      *      5. Repeat Step 4 for a PIC 9 (DISPLAY) variable
      *
      *   Utilize other options on the Monitors View toolbar
      *     1. Launch Debug and press F5 several time.  (why?)
      *     2. Add a new Monitored Expression
      *        - Click the Green Plus sign on the toolbar
      *        - Enter the name of a variable and press OK
      *     3. Remove a Monitored Expression
      *        - Select one of the variablesin the list
      *        - Click the single X
      *     3. Sort the lislt of Monitored Expressions
      *        - From the Monitors view click the a/z icon several times
      *     4. From the Monitors view click the Show Type Names icon
      *     5. From the Monitors view, expand a group field
      *        - Click Copy View to Clipboard
      *        - Open Notepad and paste (Ctrl+V) into the file
      *
      *   Terminate (Ctrl+F2) the Debug session
      *
      ******************************************************************
           INITIALIZE TOT-BILL-INFORMATION,
                      COUNTERS-AND-ACCUMULATORS-WS,
                      DATE-FIELDS-WS.
           MOVE FUNCTION CURRENT-DATE TO HDG-DATE.
           PERFORM 300-OPEN-FILES.
           PERFORM 400-READ-CLAIMS.

       200-PROCESS-CLAIM.
           IF CLAIM-AMOUNT < ALLOWED-AMT
               PERFORM 300-COMPUTE-CLAIM
               IF PAY-THE-CLAIM
                   PERFORM 340-DETAIL-LINE
                   PERFORM 360-COMPUTE-INSURANCE-TOTAL
                   IF LINE-COUNT > LINES-PER-PAGE
                       PERFORM 400-WRITE-HEADING-LINES
                   END-IF
                   PERFORM 500-WRITE-DETAIL-LINE
                   PERFORM 600-INCREMENT-TOTALS
               END-IF
           END-IF
           PERFORM 400-READ-CLAIMS.

       300-OPEN-FILES.
           OPEN INPUT CLAIMFILE
           IF NOT CLAIMFILE-OK
              DISPLAY 'CLAIM FILE PROBLEM'
              GO TO 999-ERROR-RTN.

           OPEN OUTPUT PRINTFILE
           IF NOT PRINTFILE-OK
              DISPLAY 'PRINT REPORT PROBLEM'
              GO TO 999-ERROR-RTN.

       300-COMPUTE-CLAIM.

      ******************************************************************
      * #5 Additional ways to control program flow during Debug
      *    Also covered: F5 (Step Into) versus F6 (Step Over)
      *
      *    Differences between F5, F6 and F7
      *      - Make sure that the unconditional Line Break Point is
      *             set and enabled on the CALL statement
      *      - Resume (F8) to the CALL statement
      *      - Press F5 (Step into) - what happened?
      *             - Press F5 a few more times in the subroutine
      *      - Press F7 to Return to the calling program
      *      - Resume (again) to the CALL statement
      *      - Press F6 (Step over)
      *             Note that F6 runs all of the code in the subroutine
      *               and would only stop at a Break Point or ABEND
      *      - Terminate (Ctrl+F2) the Debug session
      *
      *    Launch a Debug session and use Run to & Jump to Location
      *      - Scroll down into the code and with your mouse on the
      *        CALL statement, right-click and select Run to Location
      *      - Press F6
      *      - Using your mouse Run to Location on the CALL statement
      *           Note that this ran/executed every line of code between
      *             the current instruction and your mouse pointer
      *      - Position your mouse on the PERFORM 300... statement
      *      - Right click and select Jump to Location
      *           Note that this technique allows you to skip over
      *             code that you don't want to execute during Debug
      *      - Terminate (Ctrl+F2) the Debug session
      *
      ******************************************************************
           MOVE 'LOANCOB' TO WS-CALLED-PROGRAM.
           CALL WS-CALLED-PROGRAM  USING CLAIM-RECORD-WS.

           PERFORM 300-COMPUTE-DEDUCTIBLE
           IF DEDUCTIBLE-MET
              COMPUTE CLAIM-PAID-WS ROUNDED = CLAIM-AMOUNT
                - (POLICY-COINSURANCE) *(CLAIM-AMOUNT)
           ELSE
              COMPUTE CLAIM-PAID-WS ROUNDED = CLAIM-AMOUNT
                - DEDUCTIBLE-WS - (POLICY-COINSURANCE) *(CLAIM-AMOUNT)
           END-IF

           SUBTRACT CLAIM-PAID-WS FROM POLICY-AMOUNT
           END-SUBTRACT

           IF POLICY-AMOUNT > ZERO
              MOVE 'Y' TO PAY-THE-CLAIM-WS
           ELSE
              MOVE 'N' TO PAY-THE-CLAIM-WS
           END-IF.
      *

       300-COMPUTE-DEDUCTIBLE.
      ******************************************************************
      *
      * #6 Utilize Show In (Static Analysis) for Data Flow analytics
      *    Launch another Debug Session
      *    Step Into (F5) a few times to initalize Debug
      *    Find and set your mouse focus in the variable: DEDUCTIBLE-WS
      *    From the Context Menu, select: Show In   >  Data Flow
      *        - What file contains data for DEDUCTIBLE-WS?
      *        - What literal is the initial value
      *        - Navigate within the Data Flow view (tool) for a minute
      *            Note the value of this tool for data analysis:
      *                 - Field Expansion
      *                 - Impact Analysis
      *                 - ABEND root cause analysis
      *                 - Invalid data output trace
      *        - From the Data Flow diagram find CLAIM-PAID-WS
      *        - Right-click on CLAIM-PAID-WS and select Show Data Flow
      *                Show Data Flow for this node
      *                What are the 3 variables that modify the contents
      *                     of CLAIM-PAID-WS?
      *        - Repeat this technique with different variables
      *
      *    Terminate (Ctrl+F2) the Debug session
      *
      ******************************************************************
           COMPUTE DEDUCTIBLE-WS ROUNDED =
              POLICY-AMOUNT * DEDUCTIBLE-PERC
      *
           IF POLICY-DEDUCTIBLE-PAID >= DEDUCTIBLE-WS
              MOVE "Y" TO POLICY-DEDUCTIBLE-MET-WS
           ELSE
              MOVE "N" TO POLICY-DEDUCTIBLE-MET-WS
           END-IF.
      *
       340-DETAIL-LINE.
      *     GO TO 400-READ-CLAIMS.
      *
       360-COMPUTE-INSURANCE-TOTAL.
      *    COMMENT 1
      *     GO TO 340-DETAIL-LINE.

       400-READ-CLAIMS.
           READ CLAIMFILE INTO CLAIM-RECORD-WS                          V2R1
           AT END
              MOVE "Y" TO CLAIMFILE-EOF                                 V2R2
           END-READ.
           IF CLAIMFILE-OK OR NO-MORE-CLAIMS
           NEXT SENTENCE
           ELSE
              DISPLAY 'CLAIM FILE PROBLEM'
              GO TO 999-ERROR-RTN.

       400-WRITE-HEADING-LINES.
           IF NOT FIRST-TIME                                            V2R2
               MOVE SPACES      TO PRINT-LINE
               WRITE PRINT-LINE
               WRITE PRINT-LINE
               WRITE PRINT-LINE
               WRITE PRINT-LINE
               WRITE PRINT-LINE
           END-IF.
           MOVE +1          TO LINE-COUNT, HDG-PAGE-NUMBER.
           MOVE 'N'         TO FIRST-TIME-WS.
           ADD  +1          TO PAGE-COUNT.
           MOVE PAGE-COUNT  TO HDG-PAGE-NUMBER.
           WRITE PRINT-LINE FROM HEADING-LINE-ONE.
           MOVE SPACES      TO PRINT-LINE.
           WRITE PRINT-LINE.
           WRITE PRINT-LINE FROM HEADING-LINE-TWO.
           WRITE PRINT-LINE FROM HEADING-LINE-THREE.
           WRITE PRINT-LINE FROM HEADING-LINE-FOUR.
      *
       500-WRITE-DETAIL-LINE.
           MOVE INSURED-POLICY-NO TO DET-POLICY-NO.

           EVALUATE POLICY-TYPE
           WHEN 1
                MOVE 'EMPLOYER-PRIVATE'
                   TO DET-POLICY-TYPE
           WHEN 2
                MOVE 'STANDARD MEDICARE'
                   TO DET-POLICY-TYPE
           WHEN 3
                MOVE 'AFFORDABLE CARE ACT'
                   TO DET-POLICY-TYPE
           WHEN OTHER
                MOVE 'UNKNOWN' TO DET-POLICY-TYPE
           END-EVALUATE.

           INSPECT DET-POLICY-NO REPLACING ALL ' ' BY '-'.
           MOVE 1                        TO INSURED-SUB.
           MOVE SPACES                   TO DET-NAME.
           MOVE INSURED-LAST-NAME        TO DET-LAST-NAME.
           MOVE INSURED-FIRST-NAME       TO DET-FIRST-NAME.
           MOVE POLICY-BENEFIT-DATE-X    TO DET-RENEW-DATE.
           MOVE POLICY-DEDUCTIBLE-MET-WS TO DET-DEDUCTIBLE-MET.
           MOVE DEDUCTIBLE-PERC          TO DET-DEDUCTIBLE-PERC.
           MOVE DEDUCTIBLE-WS            TO DET-COINSURANCE.
           MOVE CLAIM-AMOUNT-PAID        TO DET-CLAIM-PAID.
           MOVE CLAIM-AMOUNT             TO DET-CLAIM-AMOUNT.

           WRITE PRINT-LINE FROM DETAIL-LINE
              AFTER ADVANCING 2 LINES
           ADD 1 TO LINE-COUNT.
      *
       600-INCREMENT-TOTALS.
           ADD POLICY-AMOUNT TO TOT-POLICY-AMOUNT
           SIZE ERROR
              DISPLAY 'SIZE ERROR ON TOTAL DAYS INSURED'
           END-ADD.
           ADD POLICY-DEDUCTIBLE-PAID TO TOT-DEDUCTIBLE-PAID
           SIZE ERROR
              DISPLAY 'SIZE ERROR ON TOTAL CLAIM'
           END-ADD.
           ADD CLAIM-AMOUNT TO TOT-CLAIM-AMOUNT
           SIZE ERROR
              DISPLAY 'SIZE ERROR ON TOTAL CLAIM'
           END-ADD.
           ADD CLAIM-AMOUNT-PAID TO TOT-CLAIM-AMOUNT-PAID
           SIZE ERROR
              DISPLAY 'SIZE ERROR ON TOTAL CLAIM PAID'
           END-ADD.
      *
       700-WRITE-CLAIM-TOTALS.
           WRITE PRINT-LINE FROM TOTAL-DASH-LINE
              AFTER ADVANCING 2 LINES.
           MOVE TOT-CLAIM-AMOUNT      TO TOT-CLAIM-AMOUNT-OUT
           MOVE TOT-DEDUCTIBLE-PAID   TO TOT-DEDUCTIBLE-OUT
           MOVE TOT-CLAIM-AMOUNT-PAID TO TOT-CLAIM-AMOUNT-PAID-OUT
           WRITE PRINT-LINE FROM TOTAL-LINE-OUT.
      *
       900-WRAP-UP.
           CLOSE CLAIMFILE, PRINTFILE.
      *
      ******************************************************************
      * #7 Record and Playback - to an ABEND Situation
      *    Add a record containing all zeros to the //CLAIMS instream
      *    //CLAIMS  DD *
      *    0000000000000000000000000000000000000000000000000000000000000
      *    ...
      *    Note that this should cause a Divide by Zero exception (0C9)
      *
      * Launch another Debug Session
      * Open the Debug View menu (small white downward triangle) and
      *      select:  Show Playback Toolbar
      * Click the Start Playback Recording icon. Ensure the box is green
      * Disable all of the Breakpoints - and Resume (F9)
      *    - When the ABEND (0C9) occurs click the Examin
      *           - Select the Examine option
      *           - Click OK to get past the Abend information
      *           - From the Debug View toolbar:
      *               - Click the Move Back arrow - several times
      *               - And trace the program flow backward
      *               - Click the Move Forward arrow to trace forward
      *           - Hover over variable values
      *               ** Note that the values are frozen as of the ABEND
      *    - If you wanted to follow all of the variable values up to
      *           the ABEND situation, combine Animated Step Into
      *
      *    Terminate (Ctrl+F2) the Debug session
      *
      ******************************************************************
       999-ERROR-RTN.
           MOVE -999 TO RETURN-CODE.
           GOBACK.