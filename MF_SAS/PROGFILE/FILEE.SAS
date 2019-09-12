*******************************************************************************;
* FILEE: Rat Toluene data                                                     *;
*******************************************************************************;

TITLE1 "FILEE: Rat Toluene data" ;
TITLE2 "Benignus et al, 1981";
TITLE3 "Create permanent data file";

FILENAME IN01  "..\DATA\FILEE.DAT";
LIBNAME  OUT01 "..\DATA\";

DATA OUT01.FILEE;
     INFILE IN01;
INPUT DATE      YYMMDD6.    RAT              T_EXPOSE
      TIME_IN   TIME8.   +1 TIME_OUT  TIME8.
   +1 TIME_NCK  TIME8.   +1 TIME_BLD  TIME8.
   +1 TIME_BRN  TIME8.   +1 BLOOD_NO  $
      BRAIN_NO  $           WEIGHT
#2    BLOODTL1 BLOODTL2 BRAINTOL PPM_TOLU AGE;

*convert micrograms per ml to micrograms per gram;
BLOODTL1=BLOODTL1/1.057;
BLOODTL2=BLOODTL2/1.057;
BLOODTOL=MEAN(BLOODTL1,BLOODTL2);

LN_BLDTL=LOG(BLOODTOL);
LN_BRNTL=LOG(BRAINTOL);
LN_PPMTL=LOG(PPM_TOLU);

FORMAT DATE YYMMDD8.;
FORMAT T_EXPOSE LN_BLDTL LN_BRNTL LN_PPMTL 8.3;
FORMAT BRAINTOL BLOODTOL 8.3;
FORMAT TIME_IN TIME_OUT TIME_NCK TIME_BLD TIME_BRN TIME8.;

LABEL DATE    ="Date Exposed"
      RAT     ="Rat # On A Given Day"
      T_EXPOSE="Nominal Minutes Of Toluene Exposure"
      TIME_IN ="Time Toluene Exposure Began"
      TIME_OUT="Time Toluene Exposure Terminated"
      TIME_NCK="Time Of Neck Break"
      TIME_BLD="Time Blood Drawn"
      TIME_BRN="Time Brain Sample Obtained"
      BLOOD_NO="Code For Blood Sample"
      BRAIN_NO="Code For Brain Sample"
      WEIGHT  ="Rat Body Weight In Grams"
      BLOODTL1="Sample1 Microgms/gm Toluene In Blood"
      BLOODTL2="Sample2 Microgms/gm Toluene In Blood"
      BLOODTOL="Microgms/gm Toluene in Blood"
      BRAINTOL="Microgms/gm Toluene in Brain"
      AGE     ="Age of Rat in Days at Time of Exposure"
      PPM_TOLU="Nominal ppm Toluene In the Chamber"
      LN_BLDTL="Log microgms/gm Toluene in Blood"
      LN_BRNTL="Log microgms/gm Toluene in Brain"
      LN_PPMTL="Log Nominal ppm Toluene in the Air";

KEEP WEIGHT BLOODTOL LN_BLDTL BRAINTOL
     LN_BRNTL AGE T_EXPOSE PPM_TOLU LN_PPMTL;

PROC SORT DATA=OUT01.FILEE;
BY PPM_TOLU;

PROC PRINT DATA=OUT01.FILEE(DROP=T_EXPOSE);
VAR BLOODTOL BRAINTOL PPM_TOLU  WEIGHT AGE
    LN_BLDTL LN_BRNTL LN_PPMTL  ;

PROC PRINT DATA=OUT01.FILEE;

PROC MEANS DATA=OUT01.FILEE MEAN STD MIN MAX;
VAR _NUMERIC_;
RUN;

*PROC FREQ DATA=OUT01.FILEE;
*TABLES _CHARACTER_ ;
*RUN;