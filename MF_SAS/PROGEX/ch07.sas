********************************************************************************;
* CHAPTER 7 EXAMPLES                                                           *;
* Use data FILEF                                                               *;
********************************************************************************;
LIBNAME GLM01 "..\DATA";
footnote "-- CH07.SAS --";

***** EXAMPLE 7.1  - Data Diagnostics *****;
title1  "Ex 7.1/Output 7.1  Level 1 Diagnostics";
proc print data=GLM01.FILEF (obs=50) l;
   var fev1 height weight age;
   run;

proc means data=GLM01.FILEF n nmiss min max;
   var fev1 height weight age;
   run;

title1 "Ex 7.1/Output 7.2  Level 2 Diagnostics";
proc univariate plot normal data=GLM01.FILEF;
   id subject;
   var fev1 height weight age;
   run;

title1 "Ex 7.1/Output 7.3  Level 3 Diagnostics";
proc corr data=GLM01.FILEF noprob;
   var fev1 height weight age;
   run;


***** EXAMPLE 7.2 - Evaluating Heterogeneity and Linearity with Residuals *****;
title1 "Ex 7.2/Output 7.4  R/P Plot";
title2 "Using PROC GLM and PROC PLOT";
proc glm data=GLM01.FILEF noprint;
   model fev1 = height weight age;
   output out=ch07_01 predicted=y_hat rstudent=r_i
          cookd=Cooks_D h=leverage;
   run;

proc plot data=ch07_01;
  plot r_i*y_hat / vref=0;
  run;

title2 "Using Only PROC REG";
proc reg data=GLM01.FILEF lineprinter;
   model fev1 = height weight age;
   paint rstudent. < -3.52 or rstudent. > 3.52 / symbol="*";
   plot rstudent.*predicted.;
   quit;
   run;


***** EXAMPLE 7.3 - Evaluating Gaussian Distribution and Extreme Residuals *****;
title1 "Ex 7.3/Output 7.5  Descriptives, Normality Plot, and Extreme Values";
proc univariate plot normal data=ch07_01;
   id subject;
   var r_i;
   run;

title2 "Comparison of Data for Subjects 1, 11 with Extreme Residuals";
proc print data=GLM01.FILEF;
   var subject fev1 height weight age;
   where subject in (1, 10, 9, 11, 4, 12, 28);
   run;


***** EXAMPLE 7.4 - Leverages *****;
title1 "Ex 7.4/Output 7.6  Leverages";

* GLM (or REG) from Ex 7.2 calculated leverages *;
proc univariate plot data=ch07_01;
   id subject;
   var leverage;
   run;

proc sort data=ch07_01;
   by descending leverage;
   run;

data ch07_02;
   set ch07_01;
   if _n_ le 5;
   q = 4;  N = 71;
   F = ((leverage - (1/N)/(q-1))) / ((1 - leverage)/(N-q));
   pval = 1 - probf(F,q-1,N-q);
   Bonf = 0.05/N;   ** Bonferroni correction, pval < Bonf **;
   label Bonf = "Sig if pval <";
   run;

proc print data=ch07_02 uniform label noobs;
   var subject height weight age leverage F pval Bonf;
   format  AGE 5.1  leverage 5.2  F 5.1 pval 8.6;
   run;


***** EXAMPLES 7.5, 7.6 *****;
title1;
PROC IML;
   reset noprint;
   use GLM01.FILEF;
   ** Create the response matrix **;
   read all var "fev1" into y;
   ** Include the predictors in the predictor matrix **;
   read all var {height weight age} into X;

   *****  EXAMPLE 7.5 - Mahalanobis Distance *****;
   ** Calculate Mahalanobis Distance using X excluding intercept **;
   print "Ex 7.5/Output 7.7  Mahalanobis Distance";
   N = nrow(X);
   one = j(N,1,1);
   x_bar = X` * one/N;

   C =(X`*X)/N - (x_bar*x_bar`);
   Sigmahat = C # N / (N-1);

   M = j(N,1,0);
   do i = 1 to N;
      M[i] = ((X[i,])` - x_bar)` * inv(Sigmahat) * ((X[i,])` - x_bar);
      end;
   print M;

   read all var "subject" into subject;
   create ch07_03 var {subject m};
   append;

   ***** EXAMPLE 7.6 - Equivalence of Leverages and Mahalanobis Distance *****;
   ** Calculate Leverage **;
   **  Add intercept to X matrix **;
   X = one || X;
   XpXinv= inv(X`*X);
   ** Calculate the H matrix **;
   H = X * XpXinv * X`;
   ** Calculate leverages **;
   h = vecdiag(H);

   print "Ex 7.6/Output 7.8  Equivalence of Leverages and Mahalanobis Distance";
   h_test = 1/N + 1/(N-1)*M;
   compare = h || h_test ;
   names = {"* h from H matrix *","* h calculated from M *"};
   print compare[colname=names];

   quit;
   run;

title1 "Ex 7.5/Output 7.7 Mahalanobis Distance";
proc univariate plot data=ch07_03;
   id subject;
   var m;
   run;


***** EXAMPLE 7.7 - Cook"s D Statistic *****;
title1 "Ex 7.7/Output 7.9  Cooks D Statistic";

data ch07_04;
   set ch07_01;
   CooksD_s = Cooks_D * (71-4);
   label CooksD_s = "D* = D(N-q)";
   run;

proc univariate plot normal data=ch07_04;
   id subject;
   var Cooks_D CooksD_s;
   run;


