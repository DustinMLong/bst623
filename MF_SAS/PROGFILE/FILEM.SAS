*******************************************************************************;
* FILEM: Toluene audiogram data                                               *;
*******************************************************************************;

TITLE1 "FILEM: Toluene audiogram data";
TITLE2 "Create permanent data file";

FILENAME IN01  "..\DATA\FILEM.DAT";
LIBNAME  OUT01 "..\DATA\";

DATA OUT01.FILEM;
LENGTH DEFAULT=4;
INFILE IN01;
INPUT SUBJECT PPM_TOLU PREDBA1-PREDBA4 POSTDBA1-POSTDBA4 ;
      AVEPOST=MEAN(OF POSTDBA1-POSTDBA4);
      AVEPRE =MEAN(OF PREDBA1-PREDBA4);
      PPM50  = (PPM_TOLU=50);
      PPM400 = (PPM_TOLU=400);
LABEL SUBJECT ="Subject #"
      PPM_TOLU="Toluene ppm in chamber air"
      PREDBA1 ="Preexpos hrng thrhd 100-316Hz (Db)"
      PREDBA2 ="Preexpos hrng thrhd 316-1000Hz (Db)"
      PREDBA3 ="Preexpos hrng thrhd 1000-3162Hz (Db)"
      PREDBA4 ="Preexpos hrng thrhd 3162-1000Hz (Db)"
      POSTDBA1="Postexpos hrng thrhd 100-316Hz (Db)"
      POSTDBA2="Postexpos hrng thrhd 316-1000Hz (Db)"
      POSTDBA3="Postexpos hrng thrhd 1000-3162Hz (Db)"
      POSTDBA4="Postexpos hrng thrhd 3162-1000Hz (Db)"
      AVEPRE  ="pre hrng thrshld 100-1000 Hz (Db)"
      AVEPOST ="post hrng thrshld 100-1000 Hz (Db)";

PROC PRINT DATA=OUT01.FILEM;

PROC MEANS DATA=OUT01.FILEM N MEAN STD MIN MAX;
VAR _NUMERIC_;
RUN;