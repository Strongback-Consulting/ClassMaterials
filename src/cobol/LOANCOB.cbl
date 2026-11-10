      ******************************************************************
      * LOANCOB                                                        *
      * A simple subprogram that calculates payment amount for a loan  *
      *                                                                *
      * Compile/Link this program for Debug and - using batch JCL:     *
      *    1. Run the program to Normal EOJ                            *
      *    2. Verify the output: (SYSOUT)         T                    *
      *    3. Add the //CEEOPTS TEST card to Debug the program         *
      *    4. Add the   ENVAR(*"EQA_STARTUP_KEY=CC") for code coverage *
      *                                                                *
      ******************************************************************
       IDENTIFICATION DIVISION.
       PROGRAM-ID. LOANCOB.
       ENVIRONMENT DIVISION.
       DATA DIVISION.
       WORKING-STORAGE SECTION.
       01 FIELDS.
          05 INPUT-1                    PIC X(26).
          05 PAYMENT                    PIC S9(9)V99 USAGE COMP.
          05 PAYMENT-OUT                PIC $$$,$$9.99 USAGE DISPLAY.
          05 LOAN-AMOUNT                PIC S9(7)V99 USAGE COMP.
          05 LOAN-AMOUNT-IN             PIC X(16).
          05 INTEREST-IN                PIC X(5).
          05 INTEREST                   PIC S9(3)V99 USAGE COMP.
          05 NO-OF-PERIODS-IN           PIC X(3).
          05 NO-OF-PERIODS              PIC 99 USAGE COMP.
          05 OUTPUT-LINE                PIC X(79).
          05 INTEREST-NUM               PIC .99 USAGE DISPLAY.
          05 LOAN-NUM                   PIC 999.99 USAGE DISPLAY.
       LINKAGE SECTION.
       01 CLAIM-RECORD-LS.
          05 INSURED-DETAILS.
             10 INSURED-POLICY-NO       PIC 9(7).
             10 INSURED-LAST-NAME       PIC X(15).
             10 INSURED-FIRST-NAME      PIC X(10).
          05 POLICY-DETAILS.
             10 POLICY-TYPE             PIC 9(1).
                88 EMPLOYER                            VALUE 1.
                88 MEDICARE                            VALUE 2.
                88 AFFORDABLE-CARE                     VALUE 3.
             10 POLICY-BENEFIT-PERIOD.
                15 POLICY-YEAR          PIC 9(4).
                15 POLICY-MONTH         PIC 9(2).
                15 POLICY-DAY           PIC 9(2).
             10 POLICY-BENEFIT-DATE-X
                   REDEFINES POLICY-BENEFIT-PERIOD
                                        PIC X(8).
             10 POLICY-AMOUNT           PIC 9(7).
             10 POLICY-DEDUCTIBLE-PAID  PIC 9(4).
             10 POLICY-COINSURANCE      PIC V99.
          05 CLAIM-DETAILS.
             10 CLAIM-AMOUNT            PIC 9(9).
             10 CLAIM-AMOUNT-PAID       PIC 9(7)V99.
          05 FILLER                     PIC X(08).
      *
       PROCEDURE DIVISION USING CLAIM-RECORD-LS.
      *
       000-MAIN.
      *
           MOVE "30000 .09 24 " TO INPUT-1.
           UNSTRING INPUT-1 DELIMITED BY ALL " "
              INTO LOAN-AMOUNT-IN INTEREST-IN NO-OF-PERIODS-IN.
      *
       100-COMPUTE.
      * Convert to numeric values
           COMPUTE LOAN-AMOUNT = FUNCTION NUMVAL(LOAN-AMOUNT-IN).
           COMPUTE LOAN-AMOUNT =
              LOAN-AMOUNT /(POLICY-MONTH + 4).
           COMPUTE INTEREST = FUNCTION NUMVAL(INTEREST-IN).
           COMPUTE INTEREST = INTEREST *(POLICY-MONTH / 11).
           COMPUTE NO-OF-PERIODS = FUNCTION NUMVAL(NO-OF-PERIODS-IN)
           COMPUTE NO-OF-PERIODS = NO-OF-PERIODS / POLICY-MONTH.
      * Calculate annuity amount required
           COMPUTE PAYMENT = LOAN-AMOUNT *
              FUNCTION ANNUITY((INTEREST / 12) NO-OF-PERIODS).
      *
       200-DISPLAY.
      *
           MOVE SPACES TO OUTPUT-LINE
           MOVE PAYMENT TO PAYMENT-OUT.
           COMPUTE LOAN-AMOUNT = LOAN-AMOUNT * .111.
           MOVE LOAN-AMOUNT TO LOAN-NUM.
           COMPUTE INTEREST = INTEREST * 123,
           MOVE INTEREST TO INTEREST-NUM.
           STRING "COBLOAN:_Repayment_amount_for_a_" NO-OF-PERIODS-IN
              "_month_loan_of_" LOAN-NUM
              "_at_" INTEREST-NUM "_interest_is:_"
              DELIMITED BY SPACES
              INTO OUTPUT-LINE.
           INSPECT OUTPUT-LINE REPLACING ALL "_" BY SPACES.
           DISPLAY OUTPUT-LINE PAYMENT-OUT.
           COMPUTE POLICY-MONTH = POLICY-MONTH * 22.
      *
           GOBACK.