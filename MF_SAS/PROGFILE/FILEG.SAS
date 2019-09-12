*******************************************************************************;
* FILEG: Plant Data from Elizabeth Schreiber                                  *;
*******************************************************************************;

TITLE1 "FILEG: Plant Data from Elizabeth Schreiber";
TITLE2 "Create permanent data file";

*Finger temperatures under various treatments...plant therapy;
*Initial session data baseline values only;

FILENAME IN01  "..\DATA\FILEG.DAT";
LIBNAME  OUT01 "..\DATA\";

DATA OUT01.FILEG;
     INFILE IN01;
     INPUT SUBJECT TIME INSIDET OUTSIDET INSIDEH
           OUTSIDEH SINCNOON TEMPER0;
LABEL SUBJECT  = "Subject"
      TIME     = "Time Of study, HHMM"
      INSIDET  = "Inside temperature, deg F"
      OUTSIDET = "Outside temperature, deg F"
      INSIDEH  = "Inside humidity %"
      OUTSIDEH = "Outside humidity %"
      SINCNOON = "Decimal hours -12 "
      TEMPER0  = "Initial finger temp, deg F" ;

PROC PRINT DATA=OUT01.FILEG;

PROC MEANS DATA=OUT01.FILEG;
VAR _NUMERIC_;
RUN;