*******************************************************************************;
* FILEQ: Car Test Data from Road and Track, October, 1988                     *;
*******************************************************************************;

TITLE1 "FILEQ: Car Test Data from Road and Track, October, 1988";
TITLE2 "Create permanent data file";

FILENAME IN01  "..\DATA\FILEQ.DAT" ;
LIBNAME  OUT01 "..\DATA\" ;

DATA OUT01.FILEQ;
     LENGTH  DEFAULT=4  MAKE $10.  MODEL $10.  BRAKERAT $1.;
     INFILE IN01;
INPUT @1 MAKE $10. @12 MODEL $10.
      BASEPRIC PRICE ZEROTO60 QUARTERT TOPSPEED BRAKE80
      BRAKERAT $1.
      SLALOM SKIDPAD NOISE MPG;
LABEL MAKE    ="Manufacturer"
      MODEL   ="Model of car"
      BASEPRIC="Base price ($)"
      PRICE   ="Price as tested ($)"
      ZEROTO60="Time from 0 to 60 mph (sec)"
      QUARTERT="Time for standing start 1/4 mi (sec)"
      TOPSPEED="Top speed (mph)"
      BRAKE80 ="Distance to brake from 80mph (feet)"
      BRAKERAT="Brake rating, Fair, Good, Excellnt"
      SLALOM  ="Speek through slaom course"
      SKIDPAD ="Skidpad cornering ability (G)"
      NOISE   ="Interior noise at 70 mph,(dBA)"
      MPG     ="Miles per gallon, fuel efficiency";

PROC PRINT DATA=OUT01.FILEQ UNIFORM;

PROC MEANS DATA=OUT01.FILEQ;
VAR _NUMERIC_;
RUN;