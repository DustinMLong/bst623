********************************************************************************;
* CHAPTER 8 EXAMPLES                                                           *;
* Use data FILEF                                                               *;
********************************************************************************;
LIBNAME GLM01 "..\DATA";
footnote "-- CH08.SAS --";

***** EXAMPLE 8.1 - Calculating the SSCP Matrix *****;
title1  "Ex8.1/Output 8.1  Calculating the SSCP Matrix";
data ch08_01;
   set GLM01.FILEF;
   intercpt = 1;
   run;

proc corr data=ch08_01 sscp nosimple nocorr noprob;
   var intercpt height weight age;
   run;


***** EXAMPLE 8.2 - Calculating the Covariance Matrix  *****;
***** EXAMPLE 8.3 - Calculating the Correlation Matrix *****;
title1  "Ex8.2/Output 8.2-8.3 Covariance and Correlation Matrices";
proc corr data=GLM01.FILEF cov nosimple noprob vardef=n ;
   var height weight age;
   run;


***** EXAMPLE 8.5 - Model Corresponding to the Covariance Matrix *****;
** Obtain centered predictors and response **;
proc standard data=GLM01.FILEF (keep=subject height weight age fev1)
              out=ch08_02 (rename=(height=ht_c weight=wt_c age=age_c fev1=fev1_c))
              m=0;
   var fev1 height weight age;
   run;

title1  "Ex8.5/Output 8.3 Model Corresponding to Covariance Matrix";
proc reg data=ch08_02;
   COV: model fev1_c = ht_c wt_c age_c / noint;
   run;


***** EXAMPLE 8.6 - Model Corresponding to the Correlation Matrix *****;
** Obtain centered/scaled predictors and response **;
proc standard data=GLM01.FILEF (keep=subject height weight age fev1)
			  out=ch08_03 (rename=(height=ht_cs weight=wt_cs age=age_cs fev1=fev1_cs))
			  m=0 std=1 vardef=n;
   var fev1 height weight age;
   run;

title1  "Ex8.6/Output 8.4 Model Corresponding to Correlation Matrix";
proc reg data=ch08_03;
   CORR: model fev1_cs = ht_cs wt_cs age_cs / noint;
   run;


***** Example 8.7 - Alternate Method for Calculating Vectors of Parameter Estimates *****;
title1 "Ex8.7/Output 8.5  Using IML to Estimate Parameters Corresponding to C and R";
PROC IML;
   reset noprint;
   use GLM01.FILEF;
   ** Create the response matrix **;
   read all var "fev1" into y;
   ** Include the predictors in the predictor matrix **;
   read all var {height weight age} into Xp;
   ** Include a column for the intercept in predictors **;
   N = nrow(Xp);
   one = j(N,1,1);
   X = one || Xp;

   ** Sample Means for Predictors and Response **;
   Xp_bar = (Xp` * one)/N;
   ybar = (y` * one)/N;

   ** Covariance Matrix **;
   C = ((Xp`*Xp) / N) - (Xp_bar*Xp_bar`);

   ** Inverse sample standard deviations **;
   sdinv_x = diag(sqrt(1/vecdiag(C)));
   sdinv_y = 1 / (sqrt(((y`*y) / N) - (ybar*ybar`)));

   ** Correlation Matrix **;
   R = sdinv_x * C * sdinv_x;

   ***** Compute vector of covariances c(X,y) *****;
   cxy = ((Xp`*y))/N - (Xp_bar`*ybar)`;

   ***** Compute vector of correlations r(X,y) *****;
   rxy = sdinv_x * cxy * sdinv_y;

   reset print;
   ***** Calculate Beta according to formulas in Table 8.5.1 *****;
   print C;
   print R;
   print "Ex8.7/Output 8.5  Model Corresponding to Covariance Matrix";
   beta_c = inv(C) * cxy;
   print "Ex8.7/Output 8.5  Model Corresponding to Correlation Matrix";
   beta_r = inv(r) * rxy;

quit;
run;


***** Example 8.8 - Eigenanalysis of Correlation Matrix for X *****;
title1  "Ex8.8/Output 8.6 - Eigenanalysis of Correlation Matrix of X using PRINCOMP";
proc princomp data=ch08_01;
   var height weight age;
   run;


***** Example 8.9 - Eigenanalysis of Average SSCP, Scaled SSCP, C, and R *****;
title1 "Ex8.9: Average SSCP - COV NOINT option";
proc princomp data=ch08_01 noint cov vardef=n;
   var intercpt height weight age;
   run;

title1 "Ex8.9: Scaled SSCP - NOINT option";
proc princomp data=ch08_01 noint;
   var intercpt height weight age;
   run;

title1 "Ex8.9: Covariance Matrix - COV option";
proc princomp data=ch08_01 cov vardef=n;
   var height weight age;
   run;


***** Example 8.10 - Tolerance and VIF *****;
title1  "Ex8.10/Output 8.7 Tolerance and VIF";
proc reg data=GLM01.FILEF;
   model fev1 = height weight age / tol vif;
   quit;
   run;

title2 "Tolerance and VIF using multiple model statements";
proc glm data=GLM01.FILEF;
   HT: model height = weight age;
   run;
proc glm data=GLM01.FILEF;
   WT: model weight = height age;
   run;
proc glm data=GLM01.FILEF;
   AGE: model age = height weight;
   quit;
   run;


