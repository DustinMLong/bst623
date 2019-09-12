*******************************************************************************;
* FILEH: Rat developmental data                                               *;
*******************************************************************************;

TITLE1 "FILEH: Rat developmental data";
TITLE2 "Create permanent data file";

FILENAME IN01  "..\DATA\FILEH.DAT";
LIBNAME  OUT01 "..\DATA\";

DATA OUT01.FILEH;
LENGTH DEFAULT=4;
INFILE IN01;
INPUT DOSE DISTANCM DISTANCF;
LITTER=_N_;
LABEL LITTER   = "Rat litter #"
      DOSE     = "Mg/Kg Drug Dose"
      DISTANCM= "Anogenital Distance for males(mm)"
      DISTANCF= "Anogenital Distance for females(mm)";

PROC PRINT DATA=OUT01.FILEH;

PROC MEANS DATA=OUT01.FILEH N MEAN STD MIN MAX;
VAR _NUMERIC_;
RUN;