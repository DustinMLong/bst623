*******************************************************************************;
* FILEP: data from Ein-Dor and Feldmesser                                     *;
*******************************************************************************;

TITLE1 "FILEP: data from Ein-Dor and Feldmesser";
TITLE2 "Create permanent data file";

FILENAME IN01  "..\DATA\FILEP1.DAT" ;
FILENAME IN02  "..\DATA\FILEP2.DAT" ;
LIBNAME  OUT01 "..\DATA\" ;

DATA OUT01.FILEP;
     LENGTH DEFAULT=4 MAKE $12  MODEL $18 ;
     INFILE IN01;
     INPUT  MAKE MODEL; 
     INFILE IN02 EXPANDTABS;
     INPUT  CYCLETIM MINMEM MAXMEM CACHE MINCHAN MAXCHAN
            PERFORM EFMODEL;
MACHINE=_N_;
LABEL MAKE    ="Manufacturer"
      MODEL   ="Model"
      CYCLETIM="Cycle time, ns"
      MINMEM  ="Minimum memory, kb"
      MAXMEM  ="Maximum memory, kb"
      CACHE   ="Cache size, kb"
      MINCHAN ="Minimum # channels"
      MAXCHAN ="Maximum # channels"
      PERFORM ="100*Performance CPU / 370/158-3"
      EFMODEL ="E-F Model predicted performance"
      MACHINE ="Observation" ;
DROP EFMODEL; 

PROC PRINT DATA=OUT01.FILEP NOOBS;

PROC MEANS DATA=OUT01.FILEP;
RUN;