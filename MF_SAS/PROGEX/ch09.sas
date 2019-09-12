********************************************************************************;
* CHAPTER 9 EXAMPLES                                                           *;
* Use data FILEF                                                               *;
********************************************************************************;
LIBNAME GLM01 "..\DATA";
footnote "-- CH09.SAS --";

***** EXAMPLE 9.1 - Defining a Classical Lack-of-Fit Test *****;
** Confirm that there are replicates **;
proc freq data=GLM01.FILEF;
   tables height*weight / list;
   title1 "Ch9: Defining a Classical Lack of Fit test";
   title2 "Examine data for replicates";
   run;

**  Macro to perform eigenanalysis on scaled SSCP and R matrix **;
%macro e_analys(varstring);
   PROC IML;
   use filef;
   reset noprint;

   ** X matrix including intercept, for calculating scaled SSCP  **;
   reset noprint;
   read all var {&varstring} into X;
   N=nrow(X);
   one = j(n,1,1);
   xbar = (x`*one)/n;
   Xp = one || X;

   reset print;
   print "* scaled SSCP matrix *";
   sscp_scl = inv(sqrt(diag(Xp`*Xp)))*(Xp`*Xp)*inv(sqrt(diag(Xp`*Xp)));

   reset noprint;
   print "* eigenanalysis of scaled SSCP matrix *";
   call eigen(eval_scl,evec_scl,sscp_scl);

   reset print;
   print "* condition indices for scaled SSCP *";
   cond_ind = sqrt(max(eval_scl)/eval_scl);

   reset noprint;
   C = ((X`*X)/n) - xbar*xbar`;

   reset print;
   print "* correlation matrix R *";
   R = inv(sqrt(diag(C))) * C * inv(sqrt(diag(C)));

   print "* eigenanalysis of R *";
   call eigen (eval_r, evec_r, R);

   print "* condition indices for R *";
   cond_ind = sqrt(max(eval_r)/eval_r);

   quit;
   run;
%mend;


***** EXAMPLE 9.2 - Fitting a Natural Cubic Polynomial *****;
data ch09_01;
	set GLM01.FILEF;
	wt_2 = weight**2;
	wt_3 = weight**3;
	run;
proc reg data=ch09_01;
	title1 "Ex 9.2/Output 9.1 Fitting a Natural Cubic Polynomial";
	model fev1 = height weight wt_2 wt_3 / tol vif ss1 pcorr1 collin collinoint;
	run;


***** EXAMPLE 9.3 - Fitting Natural Cubic Polynomials with Centered Predictors *****;
** Obtain centered predictors **;
proc standard data=GLM01.FILEF
			  out=ch09_02 (rename=(height=ht_c weight=wt_c))
			  m=0;
	var height weight;
	run;

data ch09_03;
	set ch09_02;
	wt_c2=wt_c**2;
	wt_c3=wt_c**3;
	run;

proc reg data=ch09_03;
   model fev1 = ht_c wt_c wt_c2 wt_c3 / tol vif ss1 pcorr1 collin collinoint;
   title1 "Ex9.3/Output 9.2 - Fitting natural cubic polynomial with centered predictors";
   run;


***** EXAMPLE 9.4 - Fitting Orthogonal Polynomials *****;
** Create orthogonal polynomial for WEIGHT **;
PROC IML;
   use GLM01.FILEF;
   read all var "weight" into weight;
   read all var "subject" into subject;
   poly = orpol(weight,3);
   lqc = subject || poly[,2:4];
   create ch09_04 var {subject wt_orp1 wt_orp2 wt_orp3};
      append from lqc;
      close ch09_04;
   quit;
   run;

proc sort data=ch09_04;  by subject;  run;
proc sort data=ch09_02;  by subject;  run;

** Orth poly scores have mean 0, so use centered height **;
data ch09_05;
	merge ch09_02
		  ch09_04;
	by subject;
	run;
		  
proc reg data=ch09_05;
   model fev1 = ht_c wt_orp1 wt_orp2 wt_orp3 / tol vif ss1 pcorr1 collin collinoint;
   title1 "Ex9.4/Output 9.3 - Fitting Orthogonal Polynomials";
   quit;
   run;


