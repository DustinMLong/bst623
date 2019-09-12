********************************************************************************;
* CHAPTER 15 EXAMPLES                                                          *;
* Use data FILEJ                                                               *;
********************************************************************************;
LIBNAME GLM01 "..\DATA";
footnote "-- CH14.SAS --";

title1 "Ch15: Review data values for MALE and DOSAGE variables";
proc freq data=GLM01.FILEJ;
	tables male*dosage / list missing;
	run;


***** EXAMPLE 15.1 - Fixed Block Analysis Using Reference Cell Coding *****;
** Indicator variables needed to construct X matrices for reference cell coding schemes **;
data ch15_01;
	set GLM01.FILEJ;
	one=1;
	a_f=(not male);
	b_3=(dosage=3);
	b_6=(dosage=6);
	run;

proc sort nodupkey data=ch15_01 out=ch15_02;
	by dosage descending male;
	run;

title1 "Ch15: Essence matrix for Reference Cell coding scheme";
proc print data=ch15_02;
	var one a_f b_3 b_6;
	run;


title1 "Ex15.1/Output 15.1 Fixed Block Analysis Using Reference Cell Coding";
proc glm data=ch15_01;
	model lhour283 = one a_f b_3 b_6 / noint solution;
	** Estimate of Overall Mean **;
	estimate "Grand Mean"      one 6 a_f 3 b_3 2 b_6 2 / divisor=6;

	** Estimates of Marginal Means **;
	estimate "Marg Mean: Male"   one 3 a_f 0 b_3 1 b_6 1 / divisor=3;
	estimate "Marg Mean: Female" one 3 a_f 3 b_3 1 b_6 1 / divisor=3;

	estimate "Marg Mean: Dose 0" one 2 a_f 1 b_3 0 b_6 0 / divisor=2;
	estimate "Marg Mean: Dose 3" one 2 a_f 1 b_3 2 b_6 0 / divisor=2;
	estimate "Marg Mean: Dose 6" one 2 a_f 1 b_3 0 b_6 2 / divisor=2;

	** Tests of Main Effects **;
	contrast "Main Effect Gender" 
		one 0 a_f 1 b_3 0 b_6 0;
	contrast "Main Effect Dose"   
		one 0 a_f 0 b_3 1 b_6 0,
		one 0 a_f 0 b_3 0 b_6 1;

	** Step-down Tests for Main Effects **;
	contrast "Step-down of Main Effect: Dose 0 vs 3"   
		one 0 a_f 0 b_3 1 b_6  0;
	contrast "Step-down of Main Effect: Dose 0 vs 6"
		one 0 a_f 0 b_3 0 b_6  1;
	contrast "Step-down of Main Effect: Dose 3 vs 6"
		one 0 a_f 0 b_3 1 b_6 -1;
	quit;
	run;


***** EXAMPLE 15.2 - Fixed Block Analysis Using Effect Coding *****;
** Indicator variables needed to construct X matrices for effect coding schemes **;
data ch15_03;
	set GLM01.FILEJ;
	one=1;
	if (not male) then z_f=1;   else z_f=-1;
	if (dosage=0) then n_3=-1;  else n_3=(dosage=3);
	if (dosage=0) then n_6=-1;  else n_6=(dosage=6);
	run;

proc sort nodupkey data=ch15_03 out=ch15_04;
	by dosage descending male;
	run;

title1 "Ch15: Essence matrix for Effect coding scheme";
proc print data=ch15_04;
	var one z_f n_3 n_6;
	run;

title1 "Ex15.2/Output 15.2 Fixed Block Analysis Using Effect Coding";
proc glm data=ch15_03;
	model lhour283 = one z_f n_3 n_6 / noint solution;
	** Estimate of Overall Mean **;
	estimate "Overall Mean"      one 6 z_f  0 n_3 0 n_6 0 / divisor=6;

	** Estimate of Marginal Means **;
	estimate "Marg Mean: Male"   one 3 z_f -3 n_3 0 n_6 0 / divisor=3;
	estimate "Marg Mean: Female" one 3 z_f  3 n_3 0 n_6 0 / divisor=3;

	estimate "Marg Mean: Dose 0" one 2 z_f 0 n_3 -2 n_6 -2 / divisor=2;
	estimate "Marg Mean: Dose 3" one 2 z_f 0 n_3  2 n_6  0 / divisor=2;
	estimate "Marg Mean: Dose 6" one 2 z_f 0 n_3  0 n_6  2 / divisor=2;

	** Tests of Main Effects **;
	contrast "Main Effect Gender" 
		one 0 z_f 1 n_3 0 n_6 0;
	contrast "Main Effect Dose"   
		one 0 z_f 0 n_3 2 n_6 1,
		one 0 z_f 0 n_3 1 n_6 2;

	** Step-down Tests for Main Effects **;
	contrast "Step-down of Main Effect: Dose 0 vs 3" 
		one 0 z_f 0 n_3 2 n_6 1; 
	contrast "Step-down of Main Effect: Dose 0 vs 6"
		one 0 z_f 0 n_3 1 n_6 2;
	contrast "Step-down of Main Effect: Dose 3 vs 6"
		one 0 z_f 0 n_3 1 n_6 -1;
	quit;
	run;
proc glm;
quit;
run;


