/* REXX - a sample program written by Larry England */
/* Trace ?A  */
Say "This LOOPING.rexx.";
Say "Today' date blah is: " Date() " and it is " Time();

/* Parse the arguments */
parse arg max
  say "max is '"max"'"
  if (max = "") then
    max = 12

  say "max is big :" max

Say " "

/* Loop */
do c=1 to max
    if ((c // 2) = 0 )then
       say c "is an even number and your userid is " userid()
    else
       say c "is an odd number"
end