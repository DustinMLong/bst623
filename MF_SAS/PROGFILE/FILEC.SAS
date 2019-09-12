*******************************************************************************;
* FILEC: Urinary Levels of Interleukin-6 and Disease Activity                 *;
*        in Patients with IgA Nephropathy                                     *;
*******************************************************************************;

TITLE1 "FILEC: Urinary Levels of Interleukin-6 and Disease Activity in Patients with IgA Nephropathy";
TITLE2 "Tomino et al., Am J Nephrol, 1991, 11, 459-464";
TITLE3 "Create permanent data file";

FILENAME IN01  "..\DATA\FILEC.DAT";
LIBNAME  OUT01 "..\DATA\";

DATA OUT01.FILEC;
LENGTH STAGE $8 GENDER $6 RCBHPF $5 CAST $1;
     INFILE IN01;
     INPUT STAGEID STAGE AGE GENDER  
           SERUMIL6 URINIL6 PROTEINU
           RCBHPF CAST BUN SCR UA SIGA SC3;
SUBJECT=_N_;
LABEL STAGEID ="Person in Stage"
      STAGE   ="IgA Nephropathy"
      AGE     ="Age in years"
      SERUMIL6="Serum IL-6 pg/ml"
      URINIL6 ="Urine IL-6 pg/mg*Cr"
      PROTEINU="Urin prtein mg/g*Cr"
      RCBHPF  ="red bld cells/HPF"
      CAST    ="Urinary cast"
      BUN     ="BUN mg/dl"
      SCR     ="s-Cr mg/dl"
      UA      ="UA mg/dl"
      SIGA    ="s-IgA mg/dl"
      SC3     ="s-C3 mg/dl";

PROC PRINT DATA=OUT01.FILEC;

PROC MEANS DATA=OUT01.FILEC MEAN STD MIN MAX;
VAR _NUMERIC_;

PROC FREQ DATA=OUT01.FILEC;
TABLES _CHARACTER_ ;
RUN;