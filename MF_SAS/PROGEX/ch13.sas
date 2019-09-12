********************************************************************************;
* CHAPTER 13 EXAMPLES                                                          *;
* Use data FILEJ                                                               *;
********************************************************************************;
LIBNAME GLM01 "..\DATA";
footnote "-- CH13.SAS --";

** Review data values **;
proc freq data=GLM01.FILEJ;
	tables dosage;
	title1 "Ch13: Review data values for DOSAGE variable";
	run;

proc sort data=GLM01.FILEJ out=ch13_01;
	by dosage;
	run;

** Indicator / effect variables needed to construct X matrices for various coding schemes **;
data ch13_02;
	set ch13_01;
	one = 1;
	* Indicator variables for each level of DOSAGE *;
	x_0 = (dosage=0);
	x_3 = (dosage=3);
	x_6 = (dosage=6);
	* Effect coding variables *;
	if (dosage=0) then n_3=-1;  else n_3=(dosage=3);
	if (dosage=0) then n_6=-1;  else n_6=(dosage=6);

	if (dosage=0) then x_3eff = -1; else x_3eff=(dosage=3);
	if (dosage=0) then x_6eff = -1; else x_6eff=(dosage=6);
	run;

* Prints of design matrices for each coding scheme *;

proc print data=ch13_02;
	var one x_3 x_6;
	title1 "Ch13: X matrix for Reference Cell coding";
	run;

proc print data=ch13_02;
	var x_0 x_3 x_6;
	title1 "Ch13: X matrix for Cell Mean coding";
	run;

proc print data=ch13_02;
	var one x_0 x_3 x_6;
	title1 "Ch13: X matrix for Classical ANOVA coding";
	run;

proc print data=ch13_02;
	var one x_3eff x_6eff;
	title1 "Ch13: X matrix for Effect coding";
	run;


***** EXAMPLE 13.1 - Overall Test Using Reference Cell Coding                   *****;
***** EXAMPLE 13.4 - Cell Mean Estimates using Reference Cell Coding            *****;
***** EXAMPLE 13.5 - Differences Between Cell Means using Reference Cell Coding *****;
* Corrected test, with appropriate ANOVA table.                                        *;
* Solution option gives parameter estimates, which are a reference cell coding scheme, *;
* but are a BOTTOM RIGHT ref cell, rather than TOP LEFT as discussed in text.          *;
title1 "Ex13.1/Output 13.1 Reference Cell Coding using ANOVA Source Table";
title2 "F-test is Corrected Overall Test";
proc glm data=ch13_02;
   class dosage;
   model lhour283 = dosage / solution; * Corrected - source is 2 df test on dosage *;
   run;

* Corrected test, with appropriate ANOVA table and parameter estimates. *;
title1 "Ex13.1/Output 13.2 Reference Cell Coding Fitting the Design Matrix";
title2 "gives ref cell coding, 0 cell as reference";
proc glm data=ch13_02;
   model lhour283 = x_3 x_6;  * Corrected - source has 2 1-df tests, on each indicator *;
   run;

* Same as previous.  Demonstrating that results are same. *;
* Only difference is in the syntax used on the contrast statemnt. *;
title1 "Ex13.1/Output 13.2 Reference Cell Coding Fitting the Design Matrix";
title2 "F-test is uncorrected - to obtain appropriate overall test, use contrast statement";
proc glm data=ch13_02;
   model lhour283 = one x_3 x_6 / noint; * uncorrected *;
   ** Overall Test - Note a comma separates the rows *;
   contrast "Usual Overall Test"
	   	    one 0 x_3 1 x_6 0,
		    one 0 x_3 0 x_6 1;
   ** Cell Mean Estimates **;
   contrast "MuA" one 1 x_3 0 x_6 0;
   contrast "MuB" one 1 x_3 1 x_6 0;
   contrast "MuC" one 1 x_3 0 x_6 1;
   ** Differences Between Cell Means **;
   contrast "MuA-MuB" one 0 x_3 1 x_6  0;
   contrast "MuA-MuC" one 0 x_3 0 x_6  1;
   contrast "MuB-MuC" one 0 x_3 1 x_6 -1;
   run;


***** EXAMPLE 13.2 - Overall Test Using Effect Coding                   *****;
***** EXAMPLE 13.4 - Cell Mean Estimates using Effect Coding            *****;
***** EXAMPLE 13.5 - Differences Between Cell Means using Effect Coding *****;
* Corrected test *;
title1 "Ex13.2/Output 13.3 Effect Coding using ANOVA Source Table";
title2 "F-test is Corrected Overall Test";
proc glm data=ch13_02;
   model lhour283 = x_3eff x_6eff;
   run;

* Uncorrected test, use contrast to get test.*;
title1 "Ex13.2/Output 13.4 Effect Coding Fitting the Design Matrix";
title2 "F-test is uncorrected - to obtain appropriate overall test, use contrast statement";
proc glm data=ch13_02;
   model lhour283 = one x_3eff x_6eff / noint;
   ** Overall Test - Note a comma separates the rows *;
   contrast "Usual Overall Test"
	   	    one 0  x_3eff  1  x_6eff  0,
		    one 0  x_3eff  0  x_6eff  1;
   ** Cell Mean Estimates **;
   contrast "MuA" one 1  x_3eff -1  x_6eff -1;
   contrast "MuB" one 1  x_3eff  1  x_6eff  0;
   contrast "MuC" one 1  x_3eff  0  x_6eff  1;
   ** Differences Between Cell Means **;
   contrast "MuA-MuB" one 0  x_3eff  2  x_6eff  1;
   contrast "MuA-MuC" one 0  x_3eff  1  x_6eff  2;
   contrast "MuB-MuC" one 0  x_3eff  1  x_6eff -1;
   run;


***** EXAMPLE 13.3 - Overall Test Using Cell Mean Coding                   *****;
***** EXAMPLE 13.4 - Cell Mean Estimates using Cell Mean Coding            *****;
***** EXAMPLE 13.5 - Differences Between Cell Means using Cell Mean Coding *****;
* Following is a TRICK to get estimates for cell mean coding, with uncorrected statements *;
title1 "Ch13: Cell Mean Coding, obtaining estimates with uncorrected statements";
proc glm data=ch13_02;
   class dosage;
   model lhour283 = dosage / noint solution;  ** This will do cell mean coding, uncorrected tests **;
   title2 "This method will give correct estimates.  Need contrast to get Usual Overall Test.";
   run;

* Code dummy variables, use NOINT option to get cell mean coding.  Uncorrected test. *;
title1 "Ex13.4/Output 13.5 Cell Mean Coding Fitting the Design Matrix";
title2 "F-test is uncorrected - to obtain appropriate overall test, use contrast statement";
proc glm data=ch13_02;
   model lhour283 = x_0 x_3 x_6 / noint;
   ** Overall Test - Note a comma separates the rows *;
   contrast "Usual Overall Test"
 		    x_0 1  x_3 -1  x_6  0,
	        x_0 1  x_3  0  x_6 -1;
   ** Cell Mean Estimates **;
   contrast "MuA" x_0 1  x_3  0  x_6  0;
   contrast "MuB" x_0 0  x_3  1  x_6  0;
   contrast "MuC" x_0 0  x_3  0  x_6  1;
   ** Differences Between Cell Means **;
   contrast "MuA-MuB" x_0 1  x_3 -1  x_6  0;
   contrast "MuA-MuC" x_0 1  x_3  0  x_6 -1;
   contrast "MuB-MuC" x_0 0  x_3  1  x_6 -1;
   run;


***** CLASSICAL ANOVA CODING *****;
* Corrected test *;
title1 "Ch13: Classical ANOVA Coding using ANOVA Source Table";
title2 "F-test is Corrected Overall Test";
proc glm data=ch13_02;
   model lhour283 = x_0 x_3 x_6;
   run;

* Uncorrected test, use contrast to get test.*;
title1 "Ch13: Classical ANOVA Coding Fitting the Design Matrix";
title2 "F-test is uncorrected - to obtain appropriate overall test, use contrast statement";
proc glm data=ch13_02;
   model lhour283 = one x_0 x_3 x_6 / noint;
   ** Overall Test - Note a comma separates the rows *;
   contrast "Usual Overall Test"
	        one 0  x_0 1  x_3 -1  x_6  0,
	        one 0  x_0 1  x_3  0  x_6 -1;
   ** Cell Mean Estimates **;
   contrast "MuA" one 1 x_0 1 x_3 0 x_6 0;
   contrast "MuB" one 1 x_0 0 x_3 1 x_6 0;
   contrast "MuC" one 1 x_0 0 x_3 0 x_6 1;
   ** Differences Between Cell Means **;
   contrast "MuA-MuB" one 0  x_0 1  x_3 -1  x_6  0;
   contrast "MuA-MuC" one 0  x_0 1  x_3  0  x_6 -1;
   contrast "MuB-MuC" one 0  x_0 0  x_3  1  x_6 -1;
   run;


***** EXAMPLE 13.6 - Multiple Comparisons Testing *****;
title1 "Ex13.6 Multiple Comparisons Adjustments";
proc glm data=ch13_02;
   class dosage;
   model lhour283=dosage;
   lsmeans dosage / pdiff adjust=bon;
   lsmeans dosage / pdiff adjust=sidak;
   run;

proc glm;
quit;
run;


