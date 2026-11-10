#if !defined(_CXP00007_H)
#define _CXP00007_H
/* +-----------------------------------------------------------------------+
   |                                                                       |
   |                  TRW Consumer Credit Services System                  |
   |                      Copyright (c) 1993 TRW Inc.                      |
   |                                                                       |
   | System  Name --> None                                                 |
   | Process Name --> None                                                 |
   | File Name -----> CXP00007                                             |
   |                                                                       |
   | Description:                                                          |
   |     Error Post & Abort Services Interface functions                   |
   |                                                                       |
   |                                                                       |
   + Revision History                                                      +
   | 07/26/96  Nick Yamamuro Added UPDATE_ABEND_LOAD_MODULE_MISMATCH       |
   | 04/29/96  Terry Botros  Added UPDATE_ABEND_DB_ERROR_xx                |
   | 05/02/95  Terry Botros  Added UPDATE_ABEND_DATA_ERROR                 |
   | 11/04/94  Terry Botros  Initial Implementation                        |
   +-----------------------------------------------------------------------+ */


#if !defined(_CXP00000_H)
#include "cxp00000.h"
#endif

#if !defined(_CXQERPUB_H)
#include "cxqerpub.h"
#endif

#if !defined(_CXUMUABD_H)
#include "cxumuabd.h"
#endif


/* -------------------------------------------------
   | Abend Codes
   ------------------------------------------------- */
#define UPDATE_ABEND_GENERIC           100
#define UPDATE_ABEND_PROGRAM_ERROR     200

#define UPDATE_ABEND_DATABASE_ERROR    300
#define UPDATE_ABEND_DB_ERROR_CALL_PROG  300
#define UPDATE_ABEND_DB_ERROR_CALL_DBA   310
#define UPDATE_ABEND_DB_ERROR_RESTART    320

#define UPDATE_ABEND_DATA_ERROR        400
#define UPDATE_ABEND_LOAD_MODULE_MISMATCH 500


/* -------------------------------------------------
   | Macro definitions
   ------------------------------------------------- */


/* -------------------------------------------------
   | Typedefs
   ------------------------------------------------- */


/* -------------------------------------------------
   | Function Prototypes
   ------------------------------------------------- */

void CXPErrorPostAndAbort(
      RC        AbendCode,
      ERROR_POST_INFO * pErrPost,
      INT4      DumpOption );



#endif    /* End of CXP00007.H */