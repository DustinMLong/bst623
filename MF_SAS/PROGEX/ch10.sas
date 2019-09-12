********************************************************************************;
* CHAPTER 10 EXAMPLES                                                          *;
* Use data FILEE                                                               *;
********************************************************************************;
LIBNAME GLM01 "..\DATA";
footnote "-- CH10.SAS --";

***** EXAMPLE 10.1 - Transformation of the Response *****;
data ch10_01;
   set GLM01.FILEE;
   ppm_tol2 = ppm_tolu**2;
   ppm_tol3 = ppm_tolu**3;
   br_ln    = log(braintol);
   br_sqrt  = 1/sqrt(braintol);
   br_recip = 1/braintol;
   br_3_2   = 1/(sqrt(braintol**3));
   label ppm_tol2 = "Squared ppm Toluene in Chamber"
         ppm_tol3 = "Cubed ppm Toluene in Chamber"
         br_ln    = "Natural Log(Brain Toluene)"
         br_sqrt  = "1/(Square Root(Brain Toluene))"
         br_recip = "1/(Brain Toluene)"
         br_3_2   = "1/((Brain Toluene)**(3/2))";
   run;

**  Fit initial full model, examine R/P plot **;
title1 "Ex10.1/Output 10.1-10.2  Full Model and R/P Plot, Untransformed Data";
proc reg data=ch10_01 lineprinter;
   model braintol = ppm_tolu ppm_tol2 ppm_tol3;
   plot rstudent.*predicted.;
   output out=ch10_02 predicted=yhat rstudent=r_i;
   run;

** Fit models involving transformations of response  **;
** Examine R/P plots, test of normality of residuals **;
title1 "Ex10.1/Output 10.3-10.10  Full Model and R/P Plot, Transformed Data";
proc reg data=ch10_01 lineprinter;
   model br_ln br_sqrt br_recip br_3_2 = ppm_tolu ppm_tol2 ppm_tol3;
   plot rstudent.*predicted.;
   output out=ch10_03
          rstudent= ri_ln ri_sqrt ri_recip ri_3_2;
   quit;
   run;



