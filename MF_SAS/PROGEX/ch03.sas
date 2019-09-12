********************************************************************************;
* CHAPTER 3 EXAMPLES                                                           *;
* Use data FILEF                                                               *;
********************************************************************************;
LIBNAME GLM01 "..\DATA";
footnote "-- CH03.SAS --";

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

   ** Calculate GLM parameter estimates **;
   q = ncol(X);
   XpXinv= inv(X`*X);
   betahat = XpXinv * X` * y;
   yhat = X * betahat;
   ehat = y - yhat;
   sse = ehat` * ehat;
   mse = sse / (N-q);

   ***** EXAMPLE 3.2 - Estimated Cov. Matrix of Beta-ha *****;
   print "Ex3.2/Output 3.1 Estimated Cov. Matrix of Beta-hat";
   reset print;
   covbhat= XpXinv # mse ;

   ***** EXAMPLE 3.3 - Estimated Cov. Matrix of Theta-hat *****;
   ** Example 3.3 **;
   reset noprint;
   C = {0 1 -1 0, 0 1 0 -1};
   reset print;
   print "Ex3.3/Output 3.2 Estimated Cov. Matrix of Theta-hat";
   covthat = mse * C * inv(X`*X) * C`;

   ***** EXAMPLE 3.4 - Estimated Cov. Matrix of y-hat *****;
   reset noprint;
   ** Calculate the H matrix **;
   H = X * XpXinv * X`;
   covyhat = mse # H;
   covyhat5 = covyhat[1:5,1:5];
   print "Ex3.4/Output 3.3 Estimated Cov. Matrix of y-hat";
   print covyhat5 ;

   ***** EXAMPLE 3.5 - Estimated Cov. Matrix of e-hat *****;
   covehat = mse # (I(N) - H);
   covehat5 = covehat[1:5,1:5];
   print "Ex3.5/Output 3.4 Estimated Cov. Matrix of e-hat";
   print covehat5;

   ***** EXAMPLE 3.6 - Calculating Standardized Residuals *****;
   ** Example 3.6 **;
   title1 "Ex3.6/Output 3.5 Calculating Standardized Residuals using PROC IML";
   reset noprint;
   h_i = vecdiag(H);
   reset print;
   r_i = ehat / (sqrt(mse#(1-h_i)));

   ***** EXAMPLE 3.7 - Calculating Studentized Residuals *****;
   reset noprint;
   r_i2 = r_i # r_i;
   reset print;
   print "Ex3.7/Output 3.7 Calculating Studentized Residuals";
   r_mi = r_i # sqrt((N-q-1)/(N-q-r_i2));
quit;
run;


***** EXAMPLE 3.6 - Calculating Standardized Residuals using PROC REG *****;
***** EXAMPLE 3.7 - Calculating Studentized Residuals using PROC REG  *****;
title1 "Ex3.6/Output 3.6 Obtaining Residuals from PROC REG";
proc reg data=GLM01.FILEF;
   model fev1 = height weight age / r;
   output out=ch03_01 residual=r_i rstudent=r_mi;
   quit;
   run;

title1 "Ex3.7 Obtaining Studentized Residuals from PROC REG";
proc print data=ch03_01;
   var subject r_i r_mi;
   run;


