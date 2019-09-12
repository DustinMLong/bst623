********************************************************************************;
* CHAPTER 2 EXAMPLES                                                           *;
* Use data FILEF                                                               *;
********************************************************************************;
LIBNAME GLM01 "..\DATA";
footnote "-- CH02.SAS --";

title1;
***** EXAMPLE 2.3, EXAMPLE 2.6 *****;
PROC IML;
   reset noprint;
   use GLM01.FILEF;
   ** Create the response matrix **;
   read all var "fev1" into y;
   ** Include the predictors in the predictor matrix **;
   read all var {height weight age} into X;
   ** Create and include a column for the intercept **;
   N = nrow(X);
   one = j(N,1,1);
   X = one || X;

   ***** EXAMPLE 2.3 - Parameter Estimates for the GLM *****;
   reset print;
   print "Ex2.3/Output 2.1 Parameter Estimates for FILEF Data using PROC IML";
   bhat = inv(X`*X)*X`*y;
   yhat = X*bhat;
   ehat = y - yhat;
   q = ncol(X);
   df = N-q;
   sse = y`*y - bhat`*X`*y;
   mse = sse / df;

   ***** Example 2.6 - Computing a GLH Test *****;
   reset noprint;
   C = {0 1 -1 0, 0 1 0 -1};
   M = C * inv(X`*X) * C`;
   thetahat = C * bhat;
   reset print;
   print "Ex2.6/Output 2.3 GLH Test using PROC IML";
   ssh = thetahat` * inv(M) * thetahat;
   f_obs = (ssh / nrow(thetahat))/mse;
   p = 1 - probf(f_obs,2,67);

   quit;
   run;


***** EXAMPLE 2.3 - Parameter Estimates for the GLM using PROC REG *****;
***** EXAMPLE 2.6 - Computing a GLH Test using PROC REG            *****;
title1  "Ex2.3/Output 2.2 Parameter Estimates for FILEF Data using PROC REG";
title2 "Ex2.6/Output 2.4 GLH Testing using PROC REG";
proc reg data=GLM01.FILEF;
   model fev1 = height weight age / p;
   test height-weight=0, height-age=0;
   quit;
   run;


