*******************************************************************************;
* FILEB: Statistical Record of the Environment                                *;
*******************************************************************************;

TITLE1  "FILEB: Statistical Record of the Environment";
TITLE2 "A. J. Darnay, ed, Detroit:  Gale Research, 1992";
TITLE3 "Create permanent data file";

FILENAME IN01  "..\DATA\FILEB.DAT";
LIBNAME  OUT01 "..\DATA\";

DATA OUT01.FILEB;
LENGTH DEFAULT=4 STATE $15.;
ATTRIB STATE    LABEL="Governmental Unit"
                INFORMAT=$15.
       AREA     LABEL="Land area (sq mi)"
       POPULATN LABEL="Population (1,000's)"
       DIRECT   LABEL="Direct releases (lb)"
       START    LABEL="Date district law effective"
                INFORMAT=MMDDYY8. FORMAT=DDMMYY8.
       DISTNUM  LABEL="# Districts organized"
       FARMACRE LABEL="Approx farm acres (1,000's)"
       FARMNUM  LABEL="Approx # farms (1,000's)"
       RIVERS   LABEL="Rivers total waters (mi)"
       RIVERMON LABEL="Rivers monitored for toxics (mi)"
       RIVERTOX LABEL="Rivers elevated toxics (mi)"
       LAKES    LABEL="Lakes total waters (acres)"
       LAKEMON  LABEL="Lakes monitored for toxics (acres)"
       LAKETOX  LABEL="Lakes elevated toxics (acres)"  ;
INFILE IN01;
INPUT STATE AREA POPULATN DIRECT START DISTNUM
      FARMACRE FARMNUM RIVERS RIVERMON RIVERTOX LAKES LAKEMON LAKETOX;
RECORD=_N_;

PROC PRINT DATA=OUT01.FILEB;

PROC MEANS DATA=OUT01.FILEB N MEAN STD MIN MAX;
VAR _NUMERIC_;
RUN;