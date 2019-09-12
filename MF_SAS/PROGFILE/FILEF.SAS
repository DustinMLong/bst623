*******************************************************************************;
* FILEF: Longitudinal Study of Spirometry in Children                         *;
*******************************************************************************;

TITLE1 "FILEF: Longitudinal Study of Spirometry in Children";
TITLE2 "Strope and Helms, 1984";
TITLE3 "Create permanent data file";

FILENAME IN01  "..\DATA\FILEF.DAT";
LIBNAME  OUT01 "..\DATA\";

DATA OUT01.FILEF;
     LENGTH GENDER $6  RACE $5 ;
     INFILE IN01;
     INPUT HEIGHT WEIGHT
           PEF FEV1 FVC FEF25_75 VMAX75 VMAX50
           RACE $   GENDER $     AGE;
SUBJECT=_N_;
CONSTANT= 1;
WHITE   = (RACE="WHITE") ;
BLACK   = (RACE="BLACK") ;
MALE    = (GENDER="MALE") ;
FEMALE  = (GENDER="FEMALE") ;
WHITEMAL=WHITE*MALE;
WHITEFEM=WHITE*FEMALE;
BLACKMAL=BLACK*MALE;
BLACKFEM=BLACK*FEMALE;

LABEL HEIGHT  ="Standing Height (cm)"
      WEIGHT  ="Body Weight (kg)"
      PEF     ="Peak Expiratory Flow Rate (L/Sec)"
      FEV1    ="Forced Expiratory Volume At 1 Sec (L)"
      FVC     ="Forced Vital Capacity (L)"
      FEF25_75="Max Midexpiratory Flow Rate (L/Sec)"
      VMAX50  ="Flow Rate at 50% FVC (L/Sec)"
      VMAX75  ="Flow Rate at 75% FVC (L/Sec)"
      RACE    ="White Or Black"
      GENDER  ="Male Or Female"
      AGE     ="Age (Months)"
      SUBJECT ="Subject Identification"
      CONSTANT="Constant 1"
      WHITE   ="1 if White  0 if Black"
      BLACK   ="1 If Black  0 If White"
      MALE    ="1 If Male   0 If Female"
      FEMALE  ="1 If Female 0 If Male"
      WHITEMAL="1 If White Male   0 Otherwise"
      WHITEFEM="1 If White Female 0 Otherwise"
      BLACKMAL="1 If Black Male   0 Otherwise"
      BLACKFEM="1 If Black Female 0 Otherwise";

PROC PRINT DATA=OUT01.FILEF;

PROC SORT DATA=OUT01.FILEF;
BY WHITE FEMALE;

PROC PRINT DATA=OUT01.FILEF;

PROC MEANS DATA=OUT01.FILEF;
RUN;