********************************************************************************;
* CHAPTER 4 EXAMPLES                                                           *;
* Use data FILEF                                                               *;
********************************************************************************;
LIBNAME GLM01 "..\DATA";
footnote "-- CH04.SAS --";

title1;
PROC IML;
   reset noprint;
   use GLM01.FILEF;
   ** Create the response matrix **;
   read all var "fev1" into y;
   ** Include the predictors in the predictor matrix **;
   read all var {height weight age} into X;
   ** Include a column for the intercept in predictors **;
   N = nrow(X);
   one = j(N,1,1);
   X = one || X;

   ** Calculate the parameter estimates **;
   q = ncol(X);
   XpXinv= inv(X`*X);
   H = X * inv(X`*X) * X`;
   betahat = XpXinv * X` * y;
   yhat = X * betahat;
   ehat = y - yhat;
   sse = ehat` * ehat;
   mse = sse / (N-q);

   ***** EXAMPLE 4.1 - Calculating Uncorrected Sums of Squares *****;
   reset print;
   print "Ex4.1/Output 4.1 Calculating Uncorrected Sums of Squares";
   uss_t = y`*y;
   uss_m = y`*H *y;
   sse_u = uss_t - uss_m;

   **** EXAMPLE 4.3 - Calculating Corrected Sums of Squares *****;
   print "Ex4.3/Output 4.3 Calculating Corrected Sums of Squares";
   css_t = y`*(I(N) - (one*one`)/N)*y;
   css_m = y`*(H - (one*one`)/N)*y;
   sse_c = css_t - css_m;

   ***** EXAMPLE 4.7 - Overall ANOVA Table *****;
   ** Mean Squares **;
   ssi = (y`*one*one`*y)/N;
   msi = ssi / 1;            ** MS for SSI **;
   msu_t = uss_t / N;        ** MS for USS(total) **;
   msc_t = css_t / (N-1);    ** MS for USS(model) **;
   msu_m = uss_m / q;        ** MS for CSS(total) **;
   msc_m = css_m / (q-1);    ** MS for CSS(model) **;

   ** F-values for overall ANOVA table **;
   fobs_i = msi/mse;
   fobs_u = msu_m/mse;
   fobs_c = msc_m/mse;

   ** p-values for overall ANOVA table **;
   p_int = 1 - probf(fobs_i,1,67);
   p_unc = 1 - probf(fobs_u,4,67);
   p_cor = 1 - probf(fobs_c,3,67);

quit;
run;


***** EXAMPLE 4.1 - Calculating Uncorrected Sums of Squares using PROC GLM *****;
title1  "Ex4.1/Output 4.2 Full Model using PROC GLM and the INT option";
title2 "(PROC REG does not have an INT option)";
proc glm data=GLM01.FILEF;
   model fev1 = height weight age / int;
   run;


***** EXAMPLE 4.3 - Calculating Corrected Sums of Squares *****;
title1 "Ex4.3/Output 4.4 Full Model using PROC GLM without the INT option";
proc glm data=GLM01.FILEF;
   model fev1 = height weight age ;
   run;

title1 "Ex4.3 Full Model using PROC REG without the INT option";
proc reg data=GLM01.FILEF;
   model fev1 = height weight age ;
   run;


***** EXAMPLE 4.4 - The Effect of Location Shifts on Sums of Squares *****;
data ch04_01;
   set GLM01.FILEF;
   fev1_str = fev1 + 0.8;
   age_str  = age + 48;
   run;

title1 "Ex4.4/Output 4.5 Location Shift for Response FEV1";
proc glm data=ch04_01;
   model fev1_str = height weight age / int;
   run;
   run;

title1 "Ex4.4/Output 4.6 Location Shift for Predictor AGE";
proc glm data=ch04_01;
   model fev1 = height weight age_str / int;
   run;


***** EXAMPLE 4.5 - Intercept-only Model   *****;
***** EXAMPLE 4.8 - Corrected Overall Test *****;
title1 "Ex4.5, 4.8 ANOVA Table for Intercept-Only Model";
proc glm data=GLM01.FILEF;
   model fev1 = ;
   run;


***** EXAMPLE 4.6 - Null Model               *****;
***** EXAMPLE 4.9 - Uncorrected Overall Test *****;
title1 "Ex4.6, 4.9 ANOVA Table for the Null Model";
proc reg data=GLM01.FILEF;
   model fev1 = / noint;
   run;

title1 "Ex4.9 P-value for Uncorrected Overall Test";
data ch04_02;
   p_value = 1 - probf(14.0108,4,67);
   run;
proc print data=ch04_02;
   run;