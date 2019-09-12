*******************************************************************************;
* FILEO: Zaps and Duds Data                                                   *;
*******************************************************************************;

TITLE1 "FILEO: Zaps and Duds Data";
TITLE2 "Create permanent data file";

FILENAME IN01  "..\DATA\FILEO.DAT" ;
LIBNAME  OUT01 "..\DATA\" ;

DATA OUT01.FILEO;
     LENGTH DEFAULT=4 ;
     INFILE IN01;
     INPUT SUBJECT SATM SATV
           TIME1-TIME4
           INFPAT1-INFPAT4 REDPAT1-REDPAT4
           VALHYP1-VALHYP4 INVHYP1-INVHYP4
           TRIALS1-TRIALS4
           MALE;
LABEL SUBJECT ="Subject Id #"
      SATM    ="SAT Mathematics score /10"
      SATV    ="SAT Verbal score /10"
      TIME1   ="Minutes to Solution, Problem 1"
      INFPAT1 ="# Informative Patterns, Problem 1"
      REDPAT1 ="# Redundant Patterns, Problem 1"
      VALHYP1 ="# Valid Hypotheses, Problem 1"
      INVHYP1 ="# Invalid Hypotheses, Problem 1"
      TRIALS1 ="Total # Trials, Problem 1"
      TIME2   ="Minutes to Solution, Problem 2"
      INFPAT2 ="# Informative Patterns, Problem 2"
      REDPAT2 ="# Redundant Patterns, Problem 2"
      VALHYP2 ="# Valid Hypotheses, Problem 2"
      INVHYP2 ="# Invalid Hypotheses, Problem 2"
      TRIALS2 ="Total # Trials, Problem 2"
      TIME3   ="Minutes to Solution, Problem 3"
      INFPAT3 ="# Informative Patterns, Problem 3"
      REDPAT3 ="# Redundant Patterns, Problem 3"
      VALHYP3 ="# Valid Hypotheses, Problem 3"
      INVHYP3 ="# Invalid Hypotheses, Problem 3"
      TRIALS3 ="Total # Trials, Problem 3"
      TIME4   ="Minutes to Solution, Problem 4"
      INFPAT4 ="# Informative Patterns, Problem 4"
      REDPAT4 ="# Redundant Patterns, Problem 4"
      VALHYP4 ="# Valid Hypotheses, Problem 4"
      INVHYP4 ="# Invalid Hypotheses, Problem 4"
      TRIALS4 ="Total # Trials, Problem 4"
      MALE    ="1 => Male, 0 => Female";

PROC PRINT DATA=OUT01.FILEO UNIFORM;

PROC MEANS DATA=OUT01.FILEO;
VAR _NUMERIC_;
RUN;
