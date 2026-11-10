 /* This REXX exec will determine if a file exists        */
 /*    If the file is found, it returns with RC = 0       */
 /*    If NOT found,         it returns with RC = 8       */
 /*                                                       */
 /* The filename is passed in 2 parts: Prefix and Suffix  */
 /*                                                       */
TRACE ALL;
parse upper arg FilePrefix " " FileSuffix;
OutFileName = "'"FilePrefix"."FileSuffix"'";
"ALLOC FI(LABFILE) DA("OutFileName") SHR";
if RC = 0 then do;
    "FREE FILE(LABFILE)";
    exit 0;
end;
exit 4;