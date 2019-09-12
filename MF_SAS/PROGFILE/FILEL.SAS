*******************************************************************************;
* FILEL: Rat Benzo(a)pyrene data                                              *;
*******************************************************************************;

TITLE1 "FILEL: Rat Benzo(a)pyrene data";
TITLE2 "Create permanent data file";

FILENAME IN01  "..\DATA\FILEL.DAT";
LIBNAME  OUT01 "..\DATA\";

DATA OUT01.FILEL;
LENGTH DEFAULT=4;
INFILE IN01;
 INPUT EXPOSURE SAMPTIME BAPDAM
                PUPSLFT  BAPLFT
                PUPSRT   BAPRT
                PUPSTOT  BAPTOT
                         METABDAM
                         METABLFT METABRT METABTOT;
DAM=_N_;
LABEL DAM     ="Rat litter dam"
      EXPOSURE="pyrene aerosol exposure, mg m**-3"
      SAMPTIME="Sample time collection, Hr"
      BAPDAM  ="Benzo[a]pyrene blood of dam mug g**-1"
      PUPSLFT ="# pups in left uterine horn"
      BAPLFT  ="Benzo[a]pyrene blood left pups mug g**-1"
      PUPSRT  ="# pups in right uterine horn"
      BAPRT   ="Benzo[a]pyrene blood rght pups mug g**-1"
      PUPSTOT ="# pups in both horns"
      BAPTOT  ="Benzo[a]pyrene blood all pups mug g**-1"
      METABDAM="metabolites in dam, mug g**-1"
      METABLFT="metabolites in left pups, mug g**-1"
      METABRT ="metabolites in right pups, mug g**-1"
      METABTOT="metabolites in all pups, mug g**-1";

PROC PRINT DATA=OUT01.FILEL;

PROC MEANS DATA=OUT01.FILEL N MEAN STD MIN MAX;
VAR _NUMERIC_;
RUN;