*******************************************************************************;
* FILEI: Dog alkaline phosphatase data                                        *;
*******************************************************************************;

TITLE1 "FILEI: Dog alkaline phosphatase data";
TITLE2 "Create permanent data file";

FILENAME IN01  "..\DATA\FILEI.DAT";
LIBNAME  OUT01 "..\DATA\";

DATA OUT01.FILEI;
LENGTH DEFAULT=4  GENDER $1;
INFILE IN01;
INPUT DOG DOSE GENDER $ ALKPHS0 ALKPHS12;
LABEL DOG      = "Dog Id"
      DOSE     = "Mg/Kg Drug Dose"
      GENDER   = "Male/Female"
      ALKPHS0  = "Pre-Treatment Alk-Phos"
      ALKPHS12 = "12 Week Alk-Phos" ;

PROC PRINT DATA=OUT01.FILEI;

PROC MEANS DATA=OUT01.FILEI N MEAN STD MIN MAX;
VAR _NUMERIC_;

PROC FREQ DATA=OUT01.FILEI;
TABLES _CHARACTER_ ;
RUN;