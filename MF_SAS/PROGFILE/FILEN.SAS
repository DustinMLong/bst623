*******************************************************************************;
* FILEN: EPA pulmonary data                                                   *;
*******************************************************************************;

TITLE1 "FILEN: EPA pulmonary data";
TITLE2 "Create permanent data file";

FILENAME IN01  "..\DATA\FILEN.DAT" ;
LIBNAME  OUT01 "..\DATA\" ;

DATA OUT01.FILEN;
     LENGTH DEFAULT=4 ;
     INFILE IN01;
     INPUT SUBJECT YEAR COHORT DATE DAYS TIMSESS 
           HEIGHT WEIGHT AGE AREA 
           TEMP BARM HUM
           AVTREL AVTRSP AVFVC;
LABEL SUBJECT ="Subject id"
      YEAR    ="Year of study"
      COHORT  ="Ozone Dosage Level Group"
      DATE    ="Date Of Study, Julian Date"
      DAYS    ="# Days after 12-31-79"
      TIMESS  ="Time of Session"
      HEIGHT  ="Height (cm)"
      WEIGHT  ="Weight (Kg)"
      AGE     ="Age (years)"
      AREA    ="Body Surface Area (M**2)"
      TEMP    ="Air Temperature (deg C)" 
      BAROM   ="Barometric Pressure (mmHg)"
      HUMID   ="Relative Humidity %"
      AVTREL  ="Average Treadmill Elevation (deg)"
      AVTRSP  ="Average Speed of Treadmill (mph)"
      AVFVC   ="Average Forced Vital Capacity (mL)"; 

PROC PRINT DATA=OUT01.FILEN NOOBS;

PROC MEANS DATA=OUT01.FILEN;
VAR _NUMERIC_;
RUN;