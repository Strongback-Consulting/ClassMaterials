//CRTQSAM  JOB CLASS=A,MSGCLASS=A,NOTIFY=&SYSUID,MSGLEVEL=(1,1)
//*--------------------------------------------------------------------
//* CRTQSAM - Create the class QSAM test data set
//*
//* Copyright (c) 2026 Strongback Consulting
//* SPDX-License-Identifier: MIT
//* Released under the MIT License; see LICENSE at the root of the
//* ClassMaterials repository.
//*--------------------------------------------------------------------
//*
//* Builds &SYSUID..DATA.QSAM, a fixed-block sequential (QSAM) file of
//* 80-byte name-and-address records, from the instream data below.
//* The job can be rerun at any time: step DELOLD removes the data set
//* if it is already there, so a rerun starts clean instead of failing
//* on a duplicate name. Both steps should end with return code 0.
//*
//* Record layout (columns):
//*   1-6   record id          33-56  street
//*   8-22  last name          57-71  city
//*   23-32 first name         72-73  state    75-79  zip code
//*
//*--------------------------------------------------------------------
//* Step 1 - Delete any earlier copy. DISP=(MOD,DELETE) allocates the
//*          data set if it does not exist yet, then deletes it either
//*          way, so the step ends with RC 0 on a first run or rerun.
//*--------------------------------------------------------------------
//DELOLD   EXEC PGM=IEFBR14
//QSAMOUT  DD  DSN=&SYSUID..DATA.QSAM,
//             DISP=(MOD,DELETE,DELETE),
//             UNIT=SYSALLDA,SPACE=(TRK,(1,1))
//*
//*--------------------------------------------------------------------
//* Step 2 - Copy the instream records into a new, catalogued data set.
//*          IEBGENER with SYSIN DUMMY is a straight record-for-record
//*          copy from SYSUT1 to SYSUT2. BLKSIZE=0 lets the system pick
//*          the best block size for the device.
//*--------------------------------------------------------------------
//LOADQSAM EXEC PGM=IEBGENER
//SYSPRINT DD  SYSOUT=*
//SYSIN    DD  DUMMY
//SYSUT2   DD  DSN=&SYSUID..DATA.QSAM,
//             DISP=(NEW,CATLG,DELETE),
//             UNIT=SYSALLDA,SPACE=(TRK,(5,5),RLSE),
//             DCB=(RECFM=FB,LRECL=80,BLKSIZE=0,DSORG=PS)
//SYSUT1   DD  *
000100 Abernathy      Grace     14 Willow Bend Road     Asheville      NC 28801
000200 Brennan        Malcolm   207 Quarry Hill Lane    Burlington     VT 05401
000300 Castellano     Rosa      3318 Cypress Point Way  Corpus Christi TX 78401
000400 Dunmore        Theo      9 Lantern Court         Duluth         MN 55802
000500 Ekwueme        Chidi     482 Elm Ridge Drive     Eugene         OR 97401
000600 Fairbanks      Nora      1150 Foundry Street     Fort Wayne     IN 46802
000700 Galloway       Iris      76 Granite Terrace      Grand Rapids   MI 49503
000800 Hollis         Marcus    2045 Harbor View Road   Hartford       CT 06103
000900 Ingram         Delia     318 Ironwood Avenue     Idaho Falls    ID 83402
001000 Jaramillo      Luis      55 Juniper Hollow       Juneau         AK 99801
001100 Kowalczyk      Anya      1902 Kestrel Lane       Knoxville      TN 37902
001200 Lindqvist      Erik      640 Lighthouse Road     Lincoln        NE 68508
001300 Mercado        Sofia     27 Meadowlark Circle    Madison        WI 53703
001400 Nakamura       Ken       8810 Northgate Blvd.    Norfolk        VA 23510
001500 Ostrander      Bea       412 Orchard Row         Omaha          NE 68102
001600 Pellegrino     Dana      73 Pinecrest Drive      Portland       ME 04101
001700 Quintero       Mateo     1500 Quail Run          Quincy         MA 02169
001800 Rasmussen      Ingrid    260 Riverbend Parkway   Reno           NV 89501
001900 Szabo          Petra     39 Sycamore Street      Spokane        WA 99201
002000 Thibodeaux     Jules     1777 Tidewater Road     Tulsa          OK 74103
002100 Underhill      Rowan     604 Upland Avenue       Utica          NY 13501
002200 Varga          Lena      88 Vista Del Mar        Ventura        CA 93001
002300 Wilson         Harriet   2311 Westbrook Drive    Wichita        KS 67202
002400 Xiong          Mai       145 Xenia Avenue        Xenia          OH 45385
002500 Yamamoto       Rei       930 Yellowstone Trail   Yakima         WA 98901
002600 Zielinski      Adam      26 Zephyr Lane          Zanesville     OH 43701
/*
