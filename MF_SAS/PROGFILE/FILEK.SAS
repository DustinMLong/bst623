*******************************************************************************;
* FILEK: Rat pyrene data                                                      *;
*******************************************************************************;

TITLE1 "FILEK: Rat pyrene data";
TITLE2 "Create permanent data file";

FILENAME IN01  "..\DATA\FILEK.DAT";
LIBNAME  OUT01 "..\DATA\";

DATA OUT01.FILEK;
LENGTH DEFAULT=4;
INFILE IN01;
INPUT EXPOSURE SAMPTIME PYRENDAM
               PUPSLFT  PYRENLFT
               PUPSRT   PYRENRT
               PUPSTOT  PYRENTOT
                        METABDAM METABLFT METABRT METABTOT;
DAM=_N_;
LABEL DAM     ="Rat litter dam"
      EXPOSURE="pyrene aerosol exposure, mg m**-3"
      SAMPTIME="Sample time collection, Hr"
      PYRENDAM="pyrene in blood of dam, mug g**-1"
      PUPSLFT  ="# pups in left uterine horn"
      PYRENLFT="pyrene in blood of left pups, mug g**-1"
      PUPSRT  ="# pups in right uterine horn"
      PYRENRT ="pyrene in blood of right pups, mug g**-1"
      PUPSTOT ="# pups in both horns"
      PYRENTOT="pyrene in blood of all pups, mug g**-1"
      METABDAM="metabolites in dam, mug g**-1"
      METABLFT="metabolites in left pups, mug g**-1"
      METABRT ="metabolites in right pups, mug g**-1"
      METABTOT="metabolites in all pups, mug g**-1";

PROC PRINT DATA=OUT01.FILEK;

PROC MEANS DATA=OUT01.FILEK N MEAN STD MIN MAX;
VAR _NUMERIC_;
RUN;