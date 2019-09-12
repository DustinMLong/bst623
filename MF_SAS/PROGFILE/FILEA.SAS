*******************************************************************************;
* FILEA: FEV Measurements                                                     *;
*******************************************************************************;

TITLE1 "FILEA: FEV Measurements";
TITLE2 "Bethel et al, 1985, Amer Rev Respir Dis";
TITLE3 "Create permanent file";

FILENAME IN01  "..\DATA\FILEA.DAT";
LIBNAME  OUT01 "..\DATA\";

DATA OUT01.FILEA;
     INFILE IN01;
     INPUT SUBJECT AGE HEIGHT WEIGHT FEV1;
LABEL SUBJECT="SUBJECT ID"
      AGE    ="Age (years)"
      HEIGHT ="Height (cm)"
      WEIGHT ="Body Weight (kg)"
      FEV1   ="Forced expir vol at 1 sec (L)" ;

PROC PRINT DATA=OUT01.FILEA;

PROC MEANS DATA=OUT01.FILEA N MEAN STD MIN MAX;
VAR _NUMERIC_;
RUN;