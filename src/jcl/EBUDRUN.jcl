//EBUDRUN  JOB CLASS=A,MSGCLASS=A,NOTIFY=&SYSUID,MSGLEVEL=(1,1)
//*--------------------------------------------------------------------
//* EBUDRUN - Run EBUD00 for the debugger and coverage labs
//*
//* Copyright (c) 2026 Strongback Consulting
//* SPDX-License-Identifier: MIT
//* Released under the MIT License; see LICENSE at the root of the
//* ClassMaterials repository.
//*--------------------------------------------------------------------
//*
//* EBUD00 takes a date as its PARM, in the form CCYYMMDD. It calls
//* EBUD01, which calls EBUD02 and EBUD03, so all four load modules
//* must be in &SYSUID..CLASS.LOAD, compiled with TEST for the
//* debugger and coverage labs - EBUDCMP.jcl builds all four.
//*
//* Debugging: with a batch debug profile active whose program mask
//* matches EBUD*, the debugger attaches when this step starts. The
//* JCL itself does not change.
//*
//* Coverage: to reach EBUD00's error branch, change the PARM to
//* anything that is not an eight-digit date, e.g. PARM='TODAY'.
//* A good run ends with RC 0; a rejected PARM ends with RC 8.
//*--------------------------------------------------------------------
//RUN      EXEC PGM=EBUD00,PARM='19900315'
//STEPLIB  DD  DISP=SHR,DSN=&SYSUID..CLASS.LOAD
//SYSOUT   DD  SYSOUT=*
//CEEDUMP  DD  SYSOUT=*
