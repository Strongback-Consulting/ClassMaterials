 /* This REXX exec will define a vsam ksds cluster        */
 /*    If successful,        it returns with RC = 0       */
 /*    If unsuccessful,      it returns with RC = 8       */
 /*                                                       */
 /* The filename is passed in 2 parts: Prefix and Suffix  */
 /*                                                       */
 /*   TRACE i;    */
parse upper arg FilePrefix " " FileSuffix;
OutFileName = FilePrefix"."FileSuffix;
OutDataName = FilePrefix"."FileSuffix".DATA";
OutIndexName = FilePrefix"."FileSuffix".INDEX";
      TRACE all;
"DELETE '"OutFileName"'";
"DEFINE CLUSTER (NAME('"OutFileName"') " ,
  "CISZ(4096) RECSZ(300 512) KEYS(7 0) ) " ,
  "DATA (NAME('"OutDataName"') CYLINDERS(1 1) ) " ,
  "INDEX (NAME('"OutIndexName"') TRACKS(1 1) ) "
if RC = 0 then do;
    exit 0;
end;
exit 8;