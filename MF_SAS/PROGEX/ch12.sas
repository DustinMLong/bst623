********************************************************************************;
* CHAPTER 12 EXAMPLES                                                          *;
* Use data FILEJ                                                               *;
********************************************************************************;
LIBNAME GLM01 "..\DATA";
footnote "-- CH12.SAS --";

title1 "Ch12: Review of data";
proc freq data=GLM01.FILEJ;
	tables dosage;
	run;

proc sort data=GLM01.FILEJ out=ch12_01;
	by dosage;
	run;

***** EXAMPLES 12.1-12.4 *****;
* Indicator / effect variables needed to construct X matrices for various coding schemes *;
data ch12_02;
	set ch12_01;
	one = 1;
	* Indicator variables for each level of DOSAGE *;
	if dosage=0 then x_0 = 1;  else x_0=0;
	if dosage=3 then x_3 = 1;  else x_3=0;
	if dosage=6 then x_6 = 1;  else x_6=0;
	* Effect coding variables *;
	x_3eff=0; if dosage=0 then x_3eff=-1;  if dosage=3 then x_3eff=1;
	x_6eff=0; if dosage=0 then x_6eff=-1;  if dosage=6 then x_6eff=1;
	run;

***** EXAMPLE 12.1 - Reference Cell Coding *****;
proc print data=ch12_02;
	var one x_3 x_6;
	title1 "Ex12.1 X matrix for Reference Cell coding";
	run;

***** EXAMPLE 12.2 - Cell Mean Coding *****;
proc print data=ch12_02;
	var x_0 x_3 x_6;
	title1 "Ex12.2 X matrix for Cell Mean coding";
	run;

***** EXAMPLE 12.3 - Classical ANOVA Coding *****;
proc print data=ch12_02;
	var one x_0 x_3 x_6;
	title1 "Ex12.3 X matrix for Classical ANOVA coding";
	run;

***** EXAMPLE 12.4 - Effect Coding *****;
proc print data=ch12_02;
	var one x_3eff x_6eff;
	title1 "Ex12.4 X matrix for Effect coding";
	run;

title1 "Ch12: SAS default coding scheme";
proc glm data=ch12_02;
   class dosage;
   model lhour283 = dosage;
   means dosage;
   quit;
   run;


