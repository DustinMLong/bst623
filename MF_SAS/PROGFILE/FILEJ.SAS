*******************************************************************************;
* FILEJ: Triethel tin rat activity data                                       *;
*******************************************************************************;

TITLE1 "FILEJ: Triethel tin rat activity data";
TITLE2 "Create permanent data file";

FILENAME IN01  "..\DATA\FILEJ.DAT";
LIBNAME  OUT01 "..\DATA\";

DATA OUT01.FILEJ;
LENGTH DEFAULT=4;
INFILE IN01;
INPUT RAT CAGE DOSAGE MALE  HOUR21 HOUR57 HOUR124 HOUR283;
      LHOUR21 =LOG10(HOUR21);
      LHOUR57 =LOG10(HOUR57);
      LHOUR124=LOG10(HOUR124);
      LHOUR283=LOG10(HOUR283);
LABEL RAT     ="Rat #"
      CAGE    ="Home cage # of rat"
      DOSAGE  ="mg/kg triethyl tin dosage"
      MALE    ="1 if male, 0 if female"
      HOUR21  ="1 hour activity count at age 21 days"
      HOUR57  ="1 hour activity count at age 57 days"
      HOUR124 ="1 hour activity count at age 124 days"
      HOUR283 ="1 hour activity count at age 283 days"
      LHOUR21 ="log10, 1 hr actvty cnt, age 21 days"
      LHOUR57 ="log10, 1 hr actvty cnt, age 57 days"
      LHOUR124="log10, 1 hr actvty cnt, age 124 days"
      LHOUR283="log10, 1 hr actvty cnt, age 283 days";

PROC PRINT DATA=OUT01.FILEJ;

PROC MEANS DATA=OUT01.FILEJ N MEAN STD MIN MAX;
VAR _NUMERIC_;
RUN;