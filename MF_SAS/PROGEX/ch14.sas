********************************************************************************;
* CHAPTER 14 EXAMPLES                                                          *;
* Use data FILEJ                                                               *;
********************************************************************************;
LIBNAME GLM01 "..\DATA";
footnote "-- CH14.SAS --";

title1 "Ch14: Review data values for MALE and DOSAGE variables";
proc freq data=GLM01.FILEJ;
	tables male*dosage / list missing;
	run;

****************************;
***** CELL MEAN CODING *****;
****************************;
** Indicator variables needed to construct X matrices for cell mean coding schemes **;
data ch14_01;
	set GLM01.FILEJ;
	* Set up indicators for each level of MALE and DOSAGE. *;
	* For questions about this syntax, discuss with the instructor. *;
	x_m0=(male and (dosage=0));
	x_m3=(male and (dosage=3));
	x_m6=(male and (dosage=6));
	x_f0=((not male) and (dosage=0));
	x_f3=((not male) and (dosage=3));
	x_f6=((not male) and (dosage=6));
	run;

proc sort nodupkey data=ch14_01 out=ch14_02;
	by dosage descending male;
	run;

title1 "Ch14: Essence matrix for Cell Mean coding scheme";
proc print data=ch14_02;
	var x_m0 x_f0 x_m3 x_f3 x_m6 x_f6;
	run;


***** EXAMPLE 14.1 - Estimation and Testing with Cell Mean Coding *****;
title1 "Ex14.1/Output 14.1 Estimation and Testing with Cell Mean Coding";
title2 "Estimation of Overall and Marginal Means and Tests of Effects and Interaction";
proc glm data=ch14_01;
	model lhour283=x_m0 x_f0 x_m3 x_f3 x_m6 x_f6 / noint solution;
	** Estimation of Overall Mean **;
	estimate "Grand Mean"      x_m0 1 x_f0 1 x_m3 1 x_f3 1 x_m6 1 x_f6 1 / divisor=6;

	** Estimation of Marginal Means **;
	estimate "Marg Mean: Male"   x_m0 1 x_f0 0 x_m3 1 x_f3 0 x_m6 1 x_f6 0 / divisor=3;
	estimate "Marg Mean: Female" x_m0 0 x_f0 1 x_m3 0 x_f3 1 x_m6 0 x_f6 1 / divisor=3;

	estimate "Marg Mean: Dose 0" x_m0 1 x_f0 1 x_m3 0 x_f3 0 x_m6 0 x_f6 0 / divisor=2;
	estimate "Marg Mean: Dose 3" x_m0 0 x_f0 0 x_m3 1 x_f3 1 x_m6 0 x_f6 0 / divisor=2;
	estimate "Marg Mean: Dose 6" x_m0 0 x_f0 0 x_m3 0 x_f3 0 x_m6 1 x_f6 1 / divisor=2;

	** Tests of Main Effecs and Interation **;
	contrast "Main Effect Gender" 
		x_m0  1 x_f0 -1 x_m3  1 x_f3 -1 x_m6  1 x_f6 -1;
	contrast "Main Effect Dose"   
		x_m0  1 x_f0  1 x_m3 -1 x_f3 -1 x_m6  0 x_f6  0,
		x_m0  1 x_f0  1 x_m3  0 x_f3  0 x_m6 -1 x_f6 -1;
	contrast "Interaction Gender x Dose"
		x_m0  1 x_f0 -1 x_m3 -1 x_f3  1 x_m6  0 x_f6  0,
		x_m0  1 x_f0 -1 x_m3  0 x_f3  0 x_m6 -1 x_f6  1;
	quit;
	run;


***** EXAMPLE 14.4 - Testing Strategy and Implementation Using Cell Mean Coding Scheme *****;
title1 "Ex14.4/Output 14.4 Simple Main Effects (SME) and Step-Down Tests";
title2 "Cell Mean Coding";
proc glm data=ch14_01;
	model lhour283=x_m0 x_f0 x_m3 x_f3 x_m6 x_f6 / noint solution;
	contrast "SME Gender at Dose 0"
		x_m0  1 x_f0 -1 x_m3  0 x_f3  0 x_m6  0 x_f6  0;
	contrast "SME Gender at Dose 3"
		x_m0  0 x_f0  0 x_m3  1 x_f3 -1 x_m6  0 x_f6  0;
	contrast "SME Gender at Dose 6"
		x_m0  0 x_f0  0 x_m3  0 x_f3  0 x_m6  1 x_f6 -1;

	contrast "SME Dose at Males"
		x_m0  1 x_f0  0 x_m3 -1 x_f3  0 x_m6  0 x_f6  0,
		x_m0  1 x_f0  0 x_m3  0 x_f3  0 x_m6 -1 x_f6  0;
	contrast "SME Dose at Females"
		x_m0  0 x_f0  1 x_m3  0 x_f3 -1 x_m6  0 x_f6  0,
		x_m0  0 x_f0  1 x_m3  0 x_f3  0 x_m6  0 x_f6 -1;

	contrast "Step-down of Main Effect: Dose 0 vs 3"   
		x_m0  1 x_f0  1 x_m3 -1 x_f3 -1 x_m6  0 x_f6  0;
	contrast "Step-down of Main Effect: Dose 0 vs 6"
		x_m0  1 x_f0  1 x_m3  0 x_f3  0 x_m6 -1 x_f6 -1;
	contrast "Step-down of Main Effect: Dose 3 vs 6"
		x_m0  0 x_f0  0 x_m3  1 x_f3  1 x_m6 -1 x_f6 -1;

	contrast "Step-Down of SME at Male: Dose 0 vs 3"
		x_m0  1 x_f0  0 x_m3 -1 x_f3  0 x_m6  0 x_f6  0;
	contrast "Step-Down of SME at Male: Dose 0 vs 6"
		x_m0  1 x_f0  0 x_m3  0 x_f3  0 x_m6 -1 x_f6  0;
	contrast "Step-Down of SME at Male: Dose 3 vs 6"
		x_m0  0 x_f0  0 x_m3  1 x_f3  0 x_m6 -1 x_f6  0;

	contrast "Step-Down of SME at Female: Dose 0 vs 3"
		x_m0  0 x_f0  1 x_m3  0 x_f3 -1 x_m6  0 x_f6  0;
	contrast "Step-Down of SME at Female: Dose 0 vs 6"
		x_m0  0 x_f0  1 x_m3  0 x_f3  0 x_m6  0 x_f6 -1;
	contrast "Step-Down of SME at Female: Dose 3 vs 6"
		x_m0  0 x_f0  0 x_m3  0 x_f3  1 x_m6  0 x_f6 -1;
	quit;
	run;


*********************************;
***** REFERENCE CELL CODING *****;
*********************************;
** Indicator variables needed to construct X matrices for reference cell coding schemes **;
data ch14_03;
	set GLM01.FILEJ;
	one=1;
	a_f=(not male);
	b_3=(dosage=3);
	b_6=(dosage=6);
	g_f3=a_f * b_3;
	g_f6=a_f * b_6;
	run;

proc sort nodupkey data=ch14_03 out=ch14_04;
	by dosage descending male;
	run;

title1 "Ch14: Essence matrix for Reference Cell coding scheme";
proc print data=ch14_04;
	var one a_f b_3 b_6 g_f3 g_f6;
	run;


***** EXAMPLE 14.2 - Estimation and Testing with Reference Cell Coding *****;
title1 "Ex14.2/Output 14.2 Estimation and Testing with Reference Cell Coding";
title2 "Estimation of Overall and Marginal Means and Tests of Effects and Interaction";
proc glm data=ch14_03;
	model lhour283 = one a_f b_3 b_6 g_f3 g_f6 / noint solution;
	** Estimation of Overall Mean **;
	estimate "Grand Mean"      one 6 a_f 3 b_3 2 b_6 2 g_f3 1 g_f6 1 / divisor=6;

	** Estimation of Marginal Means **;
	estimate "Marg Mean: Male"   one 3 a_f 0 b_3 1 b_6 1 g_f3 0 g_f6 0 / divisor=3;
	estimate "Marg Mean: Female" one 3 a_f 3 b_3 1 b_6 1 g_f3 1 g_f6 1 / divisor=3;

	estimate "Marg Mean: Dose 0" one 2 a_f 1 b_3 0 b_6 0 g_f3 0 g_f6 0 / divisor=2;
	estimate "Marg Mean: Dose 3" one 2 a_f 1 b_3 2 b_6 0 g_f3 1 g_f6 0 / divisor=2;
	estimate "Marg Mean: Dose 6" one 2 a_f 1 b_3 0 b_6 2 g_f3 0 g_f6 1 / divisor=2;

	** Tests of Main Effecs and Interation **;
	contrast "Main Effect Gender" 
		one 0 a_f 3 b_3 0 b_6 0 g_f3 1 g_f6 1;
	contrast "Main Effect Dose"   
		one 0 a_f 0 b_3 2 b_6 0 g_f3 1 g_f6 0,
		one 0 a_f 0 b_3 0 b_6 2 g_f3 0 g_f6 1;
	contrast "Interaction Gender x Dose"
		one 0 a_f 0 b_3 0 b_6 0 g_f3 1 g_f6 0,
		one 0 a_f 0 b_3 0 b_6 0 g_f3 0 g_f6 1;
	quit;
	run;


***** EXAMPLE 14.5 - Testing Strategy and Implementation Using Reference Cell Coding Scheme *****;
title1 "Ex14.5 Simple Main Effects (SME) and Step-Down Tests, Reference Cell Coding";
proc glm data=ch14_03;
	model lhour283 = one a_f b_3 b_6 g_f3 g_f6 / noint solution;
	contrast "SME Gender at Dose 0"
		one 0 a_f 1 b_3 0 b_6 0 g_f3 0 g_f6 0;
	contrast "SME Gender at Dose 3"
		one 0 a_f 1 b_3 0 b_6 0 g_f3 1 g_f6 0;
	contrast "SME Gender at Dose 6"
		one 0 a_f 1 b_3 0 b_6 0 g_f3 0 g_f6 1;

	contrast "SME Dose at Males"
		one 0 a_f 0 b_3 1 b_6 0 g_f3 0 g_f6 0,
		one 0 a_f 0 b_3 0 b_6 1 g_f3 0 g_f6 0;
	contrast "SME Dose at Females"
		one 0 a_f 0 b_3 1 b_6 0 g_f3 1 g_f6 0,
		one 0 a_f 0 b_3 0 b_6 1 g_f3 0 g_f6 1;
	contrast "Step-down of Main Effect: Dose 0 vs 3"   
		one 0 a_f 0 b_3 2 b_6  0 g_f3 1 g_f6  0;
	contrast "Step-down of Main Effect: Dose 0 vs 6"
		one 0 a_f 0 b_3 0 b_6  2 g_f3 0 g_f6  1;
	contrast "Step-down of Main Effect: Dose 3 vs 6"
		one 0 a_f 0 b_3 2 b_6 -2 g_f3 1 g_f6 -1;

	contrast "Step-Down of SME at Male: Dose 0 vs 3"
		one 0 a_f 0 b_3 1 b_6 0 g_f3 0 g_f6 0;
	contrast "Step-Down of SME at Male: Dose 0 vs 6"
		one 0 a_f 0 b_3 0 b_6 1 g_f3 0 g_f6 0;
	contrast "Step-Down of SME at Male: Dose 3 vs 6"
		one 0 a_f 0 b_3 1 b_6 -1 g_f3 0 g_f6 0;

	contrast "Step-Down of SME at Female: Dose 0 vs 3"
		one 0 a_f 0 b_3 1 b_6 0 g_f3 1 g_f6 0;
	contrast "Step-Down of SME at Female: Dose 0 vs 6"
		one 0 a_f 0 b_3 0 b_6 1 g_f3 0 g_f6 1;
	contrast "Step-Down of SME at Female: Dose 3 vs 6"
		one 0 a_f 0 b_3 1 b_6 -1 g_f3 1 g_f6 -1;
	quit;
	run;

title1 "Ch14: Reference Cell Coding: Reduced Model, No Interaction";
proc glm data=ch14_03;
	model lhour283 = one a_f b_3 b_6 / noint solution;
	contrast "Main Effect Gender" 
		one 0 a_f 3 b_3 0 b_6 0 ;
	contrast "Main Effect Dose"   
		one 0 a_f 0 b_3 2 b_6 0, 
		one 0 a_f 0 b_3 0 b_6 2;
	quit;
	run;


*************************;
***** EFFECT CODING *****;
*************************;
** Indicator variables needed to construct X matrices for effect coding schemes **;
data ch14_05;
	set GLM01.FILEJ;
	one=1;
	if (not male) then z_f=1;   else z_f=-1;
	if (dosage=0) then n_3=-1;  else n_3=(dosage=3);
	if (dosage=0) then n_6=-1;  else n_6=(dosage=6);
	t_f3=z_f*n_3;
	t_f6=z_f*n_6;
	run;

proc sort nodupkey data=ch14_05 out=ch14_06;
	by dosage descending male;
	run;

proc print data=ch14_06;
	var one z_f n_3 n_6 t_f3 t_f6;
	title2 "Essence matrix for Effect coding scheme";
	run;


***** EXAMPLE 14.3 - Estimation and Testing with Reference Cell Coding *****;
title1 "Ex14.3/Output 14.3 Estimation and Testing with Effect Coding";
title2 "Estimation of Overall and Marginal Means and Tests of Effects and Interaction";
proc glm data=ch14_05;
	model lhour283 = one z_f n_3 n_6 t_f3 t_f6 / noint solution;
	** Estimation of Overall Mean **;
	estimate "Overall Mean"      one 6 z_f  0 n_3 0 n_6 0 t_f3  0 t_f6  0 / divisor=6;

	** Estimation of Marginal Means **;
	estimate "Marg Mean: Male"   one 3 z_f -3 n_3 0 n_6 0 t_f3  0 t_f6  0 / divisor=3;
	estimate "Marg Mean: Female" one 3 z_f  3 n_3 0 n_6 0 t_f3  0 t_f6  0 / divisor=3;

	estimate "Marg Mean: Dose 0" one 2 z_f 0 n_3 -2 n_6 -2 t_f3 0 t_f6 0 / divisor=2;
	estimate "Marg Mean: Dose 3" one 2 z_f 0 n_3  2 n_6  0 t_f3 0 t_f6 0 / divisor=2;
	estimate "Marg Mean: Dose 6" one 2 z_f 0 n_3  0 n_6  2 t_f3 0 t_f6 0 / divisor=2;

	** Tests of Main Effecs and Interation **;
	contrast "Main Effect Gender" 
		one 0 z_f 6 n_3 0 n_6 0 t_f3 0 t_f6 0;
	contrast "Main Effect Dose"   
		one 0 z_f 0 n_3 4 n_6 2 t_f3 0 t_f6 0,
		one 0 z_f 0 n_3 2 n_6 4 t_f3 0 t_f6 0;
	contrast "Main Effect Dose (alternate)"
		one 0 z_f 0 n_3 1 n_6 0 t_f3 0 t_f6 0,
		one 0 z_f 0 n_3 0 n_6 1 t_f3 0 t_f6 0;

	contrast "Interaction Gender x Dose"
		one 0 z_f 0 n_3 0 n_6 0 t_f3 4 t_f6 2,
		one 0 z_f 0 n_3 0 n_6 0 t_f3 2 t_f6 4;
	title2 "Effect Coding: Estimation of overall and marginal means";
	title3 "and Tests of Effects and Interaction";
	quit;
	run;


***** EXAMPLE 14.5 - Testing Strategy and Implementation Using Effect Coding Scheme *****;
title1 "Ex14.5 Simple Main Effects (SME) and Step-Down Tests";
title2 "Effect Coding";
proc glm data=ch14_05;
	model lhour283=one z_f n_3 n_6 t_f3 t_f6 / noint solution;
	contrast "SME Gender at Dose 0"
		one 0 z_f -2 n_3 0 n_6 0 t_f3  2 t_f6  2;
	contrast "SME Gender at Dose 3"
		one 0 z_f -2 n_3 0 n_6 0 t_f3 -2 t_f6  0;
	contrast "SME Gender at Dose 6"
		one 0 z_f -2 n_3 0 n_6 0 t_f3  0 t_f6 -2;

	contrast "SME Dose at Males"
		one 0 z_f 0 n_3 -2 n_6 -1 t_f3 2 t_f6 1,
		one 0 z_f 0 n_3 -1 n_6 -2 t_f3 1 t_f6 2;
	contrast "SME Dose at Females"
		one 0 z_f 0 n_3 -2 n_6 -1 t_f3 -2 t_f6 -1,
		one 0 z_f 0 n_3 -1 n_6 -2 t_f3 -1 t_f6 -2;

	contrast "Step-down of Main Effect: Dose 0 vs 3" 
		one 0 z_f 0 n_3 4 n_6 2 t_f3 0 t_f6 0; 
	contrast "Step-down of Main Effect: Dose 0 vs 6"
		one 0 z_f 0 n_3 2 n_6 4 t_f3 0 t_f6 0;
	contrast "Step-down of Main Effect: Dose 3 vs 6"
		one 0 z_f 0 n_3 2 n_6 -2 t_f3 0 t_f6 0;

	contrast "Step-Down of SME at Male: Dose 0 vs 3"
		one 0 z_f 0 n_3 -2 n_6 -1 t_f3 2 t_f6 1;
	contrast "Step-Down of SME at Male: Dose 0 vs 6"
		one 0 z_f 0 n_3 -1 n_6 -2 t_f3 1 t_f6 2;
	contrast "Step-Down of SME at Male: Dose 3 vs 6"
		one 0 z_f 0 n_3  1 n_6 -1 t_f3 -1 t_f6 1;

	contrast "Step-Down of SME at Female: Dose 0 vs 3"
		one 0 z_f 0 n_3 -2 n_6 -1 t_f3 -2 t_f6 -1;
	contrast "Step-Down of SME at Female: Dose 0 vs 6"
		one 0 z_f 0 n_3 -1 n_6 -2 t_f3 -1 t_f6 -2;
	contrast "Step-Down of SME at Female: Dose 3 vs 6"
		one 0 z_f 0 n_3  1 n_6 -1 t_f3  1 t_f6 -1;
	quit;
	run;
proc glm;
quit;
run;


