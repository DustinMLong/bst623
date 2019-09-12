********************************************************************************;
* CHAPTER 16 EXAMPLES                                                          *;
* Use data FILEE                                                               *;
********************************************************************************;
LIBNAME GLM01 "..\DATA";
footnote "-- CH16.SAS --";

title1 "Ch16: Review of data values";
proc freq data=GLM01.FILEE;
	tables ln_ppmtl / list missing;
	run;

proc means data=GLM01.FILEE;
	var ln_bldtl;
	run;


****************************;
***** CELL MEAN CODING *****;
****************************;
** Indicator variables needed to construct X matrices for cell mean coding schemes **;
data ch16_01;
	set GLM01.FILEE;
	if      ppm_tolu=50   then group="a";
	else if ppm_tolu=100  then group="b";
	else if ppm_tolu=500  then group="c";
	else if ppm_tolu=1000 then group="d";
	one=1;
	one_a=(group="a");
	one_b=(group="b");
	one_c=(group="c");
	one_d=(group="d");
	xa  =(group="a")*ln_bldtl;
	xb  =(group="b")*ln_bldtl;
	xc  =(group="c")*ln_bldtl;
	xd  =(group="d")*ln_bldtl;
	run;

***** EXAMPLE 16.1 - Cell Mean Model and Estimates of Means                        *****;
***** EXAMPLE 16.2 - Adjusted ANOVA Testing with Cell Mean Coding                  *****;
***** EXAMPLE 16.3 - GLM Testing with Cell Mean Coding                             *****;
***** EXAMPLE 16.7 - Comparison of Full Model to ANOVA Model with Cell Mean Coding *****;
title1 "Ex16.1,16.3,16.7/Output 16.1 Cell Mean Coding: Model 1 Full Model";
title2 "Ex16.2/Output 16.2 Adjusted ANOVA Testing";
proc glm data=ch16_01;
	model ln_brntl = one_a one_b one_c one_d xa xb xc xd / noint solution;
	** Estimates of Adjusted Cell Means **;
	estimate "Adj Cell Mean: Group A"
		one_a 1 one_b 0 one_c 0 one_d 0 xa 1.21 xb    0 xc    0 xd    0;
	estimate "Adj Cell Mean: Group B"
		one_a 0 one_b 1 one_c 0 one_d 0 xa    0 xb 1.21 xc    0 xd    0;
	estimate "Adj Cell Mean: Group C"
		one_a 0 one_b 0 one_c 1 one_d 0 xa    0 xb    0 xc 1.21 xd    0;
	estimate "Adj Cell Mean: Group D"
		one_a 0 one_b 0 one_c 0 one_d 1 xa    0 xb    0 xc    0 xd 1.21;

	** Estimates of Average Adjusted Cell Means, Slope and Intercept **;
	estimate "Mean of Adj Cell Means"
		one_a 1 one_b 1 one_c 1 one_d 1 xa 1.21 xb 1.21 xc 1.21 xd 1.21 / divisor=4;
	estimate "Mean Intercept"
		one_a 1 one_b 1 one_c 1 one_d 1 xa 0 xb 0 xc 0 xd 0 / divisor=4;
	estimate "Mean Slope"
		one_a 0 one_b 0 one_c 0 one_d 0 xa 1 xb 1 xc 1 xd 1 / divisor=4;

	** Adjusted ANOVA Testing **;
	contrast "Equal Adj Cell Means"
		one_a 1 one_b -1 one_c  0 one_d  0 xa 1.21 xb -1.21 xc     0 xd     0,
		one_a 1 one_b  0 one_c -1 one_d  0 xa 1.21 xb     0 xc -1.21 xd     0,
		one_a 1 one_b  0 one_c  0 one_d -1 xa 1.21 xb     0 xc     0 xd -1.21;
	contrast "Pair-wise Adj Cell Means A v B"
		one_a 1 one_b -1 one_c  0 one_d  0 xa 1.21 xb -1.21 xc     0 xd     0;
	contrast "Pair-wise Adj Cell Means A v C"
		one_a 1 one_b  0 one_c -1 one_d  0 xa 1.21 xb     0 xc -1.21 xd     0;
	contrast "Pair-wise Adj Cell Means A v D"
		one_a 1 one_b  0 one_c  0 one_d -1 xa 1.21 xb     0 xc     0 xd -1.21;
	contrast "Pair-wise Adj Cell Means B v C"
		one_a 0 one_b  1 one_c -1 one_d  0 xa    0 xb  1.21 xc -1.21 xd     0;
	contrast "Pair-wise Adj Cell Means B v D"
		one_a 0 one_b  1 one_c  0 one_d -1 xa    0 xb  1.21 xc     0 xd -1.21;
	contrast "Pair-wise Adj Cell Means C v D"
		one_a 0 one_b  0 one_c  1 one_d -1 xa    0 xb     0 xc  1.21 xd -1.21;

	** GLM Testing Strategy **;
	contrast "Test of Coincidence"
		one_a 1 one_b -1 one_c  0 one_d  0 xa 0 xb 0 xc 0 xd 0,
		one_a 1 one_b  0 one_c -1 one_d  0 xa 0 xb 0 xc 0 xd 0,
		one_a 1 one_b  0 one_c  0 one_d -1 xa 0 xb 0 xc 0 xd 0,
		one_a 0 one_b  0 one_c  0 one_d  0 xa 1 xb -1 xc  0 xd  0,
		one_a 0 one_b  0 one_c  0 one_d  0 xa 1 xb  0 xc -1 xd  0,
		one_a 0 one_b  0 one_c  0 one_d  0 xa 1 xb  0 xc  0 xd -1;
	contrast "Step-down: Equal Intercepts"	
		one_a 1 one_b -1 one_c  0 one_d  0 xa 0 xb 0 xc 0 xd 0,
		one_a 1 one_b  0 one_c -1 one_d  0 xa 0 xb 0 xc 0 xd 0,
		one_a 1 one_b  0 one_c  0 one_d -1 xa 0 xb 0 xc 0 xd 0;
	contrast "Step-down: Equal Slopes (Full vs. ANCOVA)"
		one_a 0 one_b  0 one_c  0 one_d  0 xa 1 xb -1 xc  0 xd  0,
		one_a 0 one_b  0 one_c  0 one_d  0 xa 1 xb  0 xc -1 xd  0,
		one_a 0 one_b  0 one_c  0 one_d  0 xa 1 xb  0 xc  0 xd -1;
	contrast "Pair-wise Intercepts A v B"
		one_a 1 one_b -1 one_c  0 one_d  0 xa 0 xb 0 xc 0 xd 0;
	contrast "Pair-wise Intercepts A v C"
		one_a 1 one_b  0 one_c -1 one_d  0 xa 0 xb 0 xc 0 xd 0;
	contrast "Pair-wise Intercepts A v D"
		one_a 1 one_b  0 one_c  0 one_d -1 xa 0 xb 0 xc 0 xd 0;
	contrast "Pair-wise Intercepts B v C"
		one_a 0 one_b  1 one_c -1 one_d  0 xa 0 xb 0 xc 0 xd 0;
	contrast "Pair-wise Intercepts B v D"
		one_a 0 one_b  1 one_c  0 one_d -1 xa 0 xb 0 xc 0 xd 0;
	contrast "Pair-wise Intercepts C v D"
		one_a 0 one_b  0 one_c  1 one_d -1 xa 0 xb 0 xc 0 xd 0;

	** Test of Full Model vs ANOVA Model **;
	contrast "All Slopes = 0 (Full vs ANOVA)"
		one_a 0 one_b  0 one_c  0 one_d  0 xa 1 xb 0 xc 0 xd 0,
		one_a 0 one_b  0 one_c  0 one_d  0 xa 0 xb 1 xc 0 xd 0,
		one_a 0 one_b  0 one_c  0 one_d  0 xa 0 xb 0 xc 1 xd 0,
		one_a 0 one_b  0 one_c  0 one_d  0 xa 0 xb 0 xc 0 xd 1;
	run;

***** EXAMPLE 16.4 Model Series with Cell Mean Coding                 *****;
***** EXAMPLE 16.5 Backwards Groupwise Testing with Cell Mean Coding  *****;
***** EXAMPLE 16.6 ANCOVA Contrasts of Interest with Cell Mean Coding *****;
title1 "Ex16.4-16.6/Output 16.2 Cell Mean Coding: Model 2 ANCOVA";
proc glm data=ch16_01;
	model ln_brntl = one_a one_b one_c one_d ln_bldtl / noint solution; 
	** Test of Equal Intercepts **;
	contrast "Equal Intercepts (ANCOVA vs. Regression)"	
		one_a 1 one_b -1 one_c  0 one_d  0 ln_bldtl 0,
		one_a 1 one_b  0 one_c -1 one_d  0 ln_bldtl 0,
		one_a 1 one_b  0 one_c  0 one_d -1 ln_bldtl 0;

	** Estimates of Adjusted Cell Means **;
	estimate "Adj Cell Mean: Group A"
		one_a 1 one_b 0 one_c 0 one_d 0 ln_bldtl 1.21;
	estimate "Adj Cell Mean: Group B"
		one_a 0 one_b 1 one_c 0 one_d 0 ln_bldtl 1.21;
	estimate "Adj Cell Mean: Group C"
		one_a 0 one_b 0 one_c 1 one_d 0 ln_bldtl 1.21;
	estimate "Adj Cell Mean: Group D"
		one_a 0 one_b 0 one_c 0 one_d 1 ln_bldtl 1.21;
	run;

title1 "Ex16.4 Cell Mean Coding: Model 3 Regression";
proc glm data=ch16_01;
	model ln_brntl = one ln_bldtl / noint solution;
	run;

title1 "Ex16.4 Cell Mean Coding: Model 4 ANOVA";
proc glm data=ch16_01;
	model ln_brntl = one_a one_b one_c one_d / noint solution;
	run;

title1 "Ex16.4 Cell Mean Coding: Model 5 Intercept-Only";
proc glm data=ch16_01;
	model ln_brntl = one / noint solution;
	run;


*********************************;
***** REFERENCE CELL CODING *****;
*********************************;
** Indicator variables needed to construct X matrices for reference cell coding schemes **;
data ch16_02;
	set GLM01.FILEE;
	if      ppm_tolu=50   then group="a";
	else if ppm_tolu=100  then group="b";
	else if ppm_tolu=500  then group="c";
	else if ppm_tolu=1000 then group="d";
	one=1;
	one_b=(group="b");
	one_c=(group="c");
	one_d=(group="d");
	xb  =(group="b")*ln_bldtl;
	xc  =(group="c")*ln_bldtl;
	xd  =(group="d")*ln_bldtl;
	run;

***** EXAMPLE 16.8 - Model Series with Reference Cell Coding                             *****;
***** EXAMPLE 16.9 - Reference Cell Model and Estimates of Means                         *****;
***** EXAMPLE 16.10 - Adjusted ANOVA Testing with Reference Cell Coding                  *****;
***** EXAMPLE 16.11 - GLM Testing with Reference Cell Coding                             *****;
***** EXAMPLE 16.14 - Comparison of Full Model to ANOVA Model with Reference Cell Coding *****;
title1 "Ex16.8-16.11,16.14/Output 16.3 Reference Cell Coding: Model 1 Full Model";
proc glm data=ch16_02;
	model ln_brntl = one one_b one_c one_d ln_bldtl xb xc xd / noint solution;
	** Estimates of Adjusted Cell Means **;
	estimate "Adj Cell Mean: Group A"
		one 1 one_b 0 one_c 0 one_d 0 ln_bldtl 1.21 xb    0 xc    0 xd    0;
	estimate "Adj Cell Mean: Group B"
		one 1 one_b 1 one_c 0 one_d 0 ln_bldtl 1.21 xb 1.21 xc    0 xd    0;
	estimate "Adj Cell Mean: Group C"
		one 1 one_b 0 one_c 1 one_d 0 ln_bldtl 1.21 xb    0 xc 1.21 xd    0;
	estimate "Adj Cell Mean: Group D"
		one 1 one_b 0 one_c 0 one_d 1 ln_bldtl 1.21 xb    0 xc    0 xd 1.21;
	estimate "Mean of Adj Cell Means"
		one 4 one_b 1 one_c 1 one_d 1 ln_bldtl 4.84 xb 1.21 xc 1.21 xd 1.21 / divisor=4;

	** Estimates of Average Adjusted Cell Means, Slope and Intercept **;
	estimate "Mean Intercept"
		one 4 one_b 1 one_c 1 one_d 1 ln_bldtl 0 xb 0 xc 0 xd 0 / divisor=4;
	estimate "Mean Slope"
		one 0 one_b 0 one_c 0 one_d 0 ln_bldtl 4 xb 1 xc 1 xd 1 / divisor=4;

	** Adjusted ANOVA Testing **;
	contrast "Equal Adj Cell Means"
		one 0 one_b 1 one_c 0 one_d 0 ln_bldtl 0 xb 1.21 xc    0 xd    0,
		one 0 one_b 0 one_c 1 one_d 0 ln_bldtl 0 xb    0 xc 1.21 xd    0,
		one 0 one_b 0 one_c 0 one_d 1 ln_bldtl 0 xb    0 xc    0 xd 1.21;
	contrast "Pair-wise Adj Cell Means A v B"
		one 0 one_b 1 one_c 0 one_d 0 ln_bldtl 0 xb 1.21 xc    0 xd    0;
	contrast "Pair-wise Adj Cell Means A v C"
		one 0 one_b 0 one_c 1 one_d 0 ln_bldtl 0 xb    0 xc 1.21 xd    0;
	contrast "Pair-wise Adj Cell Means A v D"
		one 0 one_b 0 one_c 0 one_d 1 ln_bldtl 0 xb    0 xc    0 xd 1.21;
	contrast "Pair-wise Adj Cell Means B v C"
		one 0 one_b 1 one_c -1 one_d  0 ln_bldtl 0 xb 1.21 xc -1.21 xd     0;
	contrast "Pair-wise Adj Cell Means B v D"
		one 0 one_b 1 one_c  0 one_d -1 ln_bldtl 0 xb 1.21 xc     0 xd -1.21;
	contrast "Pair-wise Adj Cell Means C v D"
		one 0 one_b 0 one_c  1 one_d -1 ln_bldtl 0 xb    0 xc  1.21 xd -1.21;

	** GLM Testing Strategy **;
	contrast "Test of Coincidence"
		one 0 one_b 1 one_c 0 one_d 0 ln_bldtl 0 xb 0 xc 0 xd 0,
		one 0 one_b 0 one_c 1 one_d 0 ln_bldtl 0 xb 0 xc 0 xd 0,
		one 0 one_b 0 one_c 0 one_d 1 ln_bldtl 0 xb 0 xc 0 xd 0,
		one 0 one_b 0 one_c 0 one_d 0 ln_bldtl 0 xb 1 xc 0 xd 0,
		one 0 one_b 0 one_c 0 one_d 0 ln_bldtl 0 xb 0 xc 1 xd 0,
		one 0 one_b 0 one_c 0 one_d 0 ln_bldtl 0 xb 0 xc 0 xd 1;
	contrast "Step-down: Equal Intercept"	
		one 0 one_b 1 one_c 0 one_d 0 ln_bldtl 0 xb 0 xc 0 xd 0,
		one 0 one_b 0 one_c 1 one_d 0 ln_bldtl 0 xb 0 xc 0 xd 0,
		one 0 one_b 0 one_c 0 one_d 1 ln_bldtl 0 xb 0 xc 0 xd 0;
	contrast "Step-down: Equal Slopes (Full vs. ANCOVA)"
		one 0 one_b 0 one_c 0 one_d 0 ln_bldtl 0 xb 1 xc 0 xd 0,
		one 0 one_b 0 one_c 0 one_d 0 ln_bldtl 0 xb 0 xc 1 xd 0,
		one 0 one_b 0 one_c 0 one_d 0 ln_bldtl 0 xb 0 xc 0 xd 1;
	contrast "Pair-wise Intercepts A v B"
		one 0 one_b 1 one_c 0 one_d 0 ln_bldtl 0 xb 0 xc 0 xd 0;
	contrast "Pair-wise Intercepts A v C"
		one 0 one_b 0 one_c 1 one_d 0 ln_bldtl 0 xb 0 xc 0 xd 0;
	contrast "Pair-wise Intercepts A v D"
		one 0 one_b 0 one_c 0 one_d 1 ln_bldtl 0 xb 0 xc 0 xd 0;
	contrast "Pair-wise Intercepts B v C"
		one 0 one_b 1 one_c -1 one_d  0 ln_bldtl 0 xb 0 xc 0 xd 0;
	contrast "Pair-wise Intercepts B v D"
		one 0 one_b 1 one_c  0 one_d -1 ln_bldtl 0 xb 0 xc 0 xd 0;
	contrast "Pair-wise Intercepts C v D"
		one 0 one_b 0 one_c  1 one_d -1 ln_bldtl 0 xb 0 xc 0 xd 0;

	** Test of Full Model vs ANOVA Model **;
	contrast "All Slopes = 0 (Full vs ANOVA)"
		one 0 one_b 0 one_c 0 one_d 0 ln_bldtl 1 xb 0 xc 0 xd 0,
		one 0 one_b 0 one_c 0 one_d 0 ln_bldtl 1 xb 1 xc 0 xd 0,
		one 0 one_b 0 one_c 0 one_d 0 ln_bldtl 1 xb 0 xc 1 xd 0,
		one 0 one_b 0 one_c 0 one_d 0 ln_bldtl 1 xb 0 xc 0 xd 1;
	run;

***** EXAMPLE 16.12 - Backwards Groupwise Testing with Reference Cell Coding  *****;
***** EXAMPLE 16.13 - ANCOVA Contrasts of Interest with Reference Cell Coding *****;
title1 "Ex16.8/Output 16.4 Reference Cell Coding: Model 2 ANCOVA";
proc glm data=ch16_02;
	model ln_brntl = one one_b one_c one_d ln_bldtl / noint solution;
	** Test of Equal Intercepts **;
	contrast "Equal Intercept (ANCOVA vs. Regression)"	
		one 0 one_b 1 one_c 0 one_d 0 ln_bldtl 0 ,
		one 0 one_b 0 one_c 1 one_d 0 ln_bldtl 0 ,
		one 0 one_b 0 one_c 0 one_d 1 ln_bldtl 0 ;

	** Estimates of Adjusted Cell Means **;
	estimate "Adj Cell Mean: Group A"
		one 1 one_b 0 one_c 0 one_d 0 ln_bldtl 1.21;
	estimate "Adj Cell Mean: Group B"
		one 1 one_b 1 one_c 0 one_d 0 ln_bldtl 1.21;
	estimate "Adj Cell Mean: Group C"
		one 1 one_b 0 one_c 1 one_d 0 ln_bldtl 1.21;
	estimate "Adj Cell Mean: Group D"
		one 1 one_b 0 one_c 0 one_d 1 ln_bldtl 1.21;
run;

title1 "Ex16.14 Reference Cell Coding: Model 4 ANOVA";
proc glm data=ch16_02;
	model ln_brntl = one one_b one_c one_d  / noint solution;
	run;
	


*************************;
***** EFFECT CODING *****;
*************************;
** Indicator variables needed to construct X matrices for effect coding schemes **;
data ch16_03;
	set GLM01.FILEE;
	if      ppm_tolu=50   then group="a";
	else if ppm_tolu=100  then group="b";
	else if ppm_tolu=500  then group="c";
	else if ppm_tolu=1000 then group="d";
	one=1;
	if group="a" then one_be=-1;  else one_be=(group="b");
	if group="a" then one_ce=-1;  else one_ce=(group="c");
	if group="a" then one_de=-1;  else one_de=(group="d");
	if group="a" then xbe=(-ln_bldtl);  else xbe  =(group="b")*ln_bldtl;
	if group="a" then xce=(-ln_bldtl);  else xce  =(group="c")*ln_bldtl;
	if group="a" then xde=(-ln_bldtl);  else xde  =(group="d")*ln_bldtl;
	run;

***** EXAMPLE 16.15 - Model Series with Effect Coding *****;
***** EXAMPLE 16.16 - Effect Coding Model and Estimates of Means *****;
***** EXAMPLE 16.17 - Adjusted ANOVA Testing with Effect Coding *****;
***** EXAMPLE 16.18 - GLM Testing with Effect Coding *****;
***** EXAMPLE 16.21 - Comparison of Full Model to ANOVA Model with Effect Coding *****;
title1 "Ex16.15-16.18,16.21/Output 16.5 Effect Coding: Model 1 Full Model";
proc glm data=ch16_03;
	model ln_brntl = one one_be one_ce one_de ln_bldtl xbe xce xde / noint solution;
	** Estimates of Adjusted Cell Means **;
	estimate "Adj Cell Mean: Group A"
		one 1 one_be -1 one_ce -1 one_de -1 ln_bldtl 1.21 xbe -1.21 xce -1.21 xde -1.21;
	estimate "Adj Cell Mean: Group B"
		one 1 one_be  1 one_ce  0 one_de  0 ln_bldtl 1.21 xbe  1.21 xce     0 xde     0;
	estimate "Adj Cell Mean: Group C"
		one 1 one_be  0 one_ce  1 one_de  0 ln_bldtl 1.21 xbe     0 xce  1.21 xde     0;
	estimate "Adj Cell Mean: Group D"
		one 1 one_be  0 one_ce  0 one_de  1 ln_bldtl 1.21 xbe     0 xce     0 xde  1.21;

	** Estimates of Average Adjusted Cell Means, Slope and Intercept **;
	estimate "Mean of Adj Cell Means"
		one 1 one_be 0 one_ce 0 one_de 0 ln_bldtl 1.21 xbe 0 xce 0 xde 0;
	estimate "Mean Intercept"
		one 1 one_be 0 one_ce 0 one_de 0 ln_bldtl 0 xbe 0 xce 0 xde 0;
	estimate "Mean Slope"
		one 0 one_be 0 one_ce 0 one_de 0 ln_bldtl 1 xbe 0 xce 0 xde 0;

	** Adjusted ANOVA Testing **;
	contrast "Equal Adj Cell Means"
		one 0 one_be 2 one_ce 1 one_de 1 ln_bldtl 0 xbe 2.42 xce 1.21 xde 1.21,
		one 0 one_be 1 one_ce 2 one_de 1 ln_bldtl 0 xbe 1.21 xce 2.42 xde 1.21,
		one 0 one_be 1 one_ce 1 one_de 2 ln_bldtl 0 xbe 1.21 xce 1.21 xde 2.42;
	contrast "Pair-wise Adj Cell Means A v B"
		one 0 one_be 2 one_ce 1 one_de 1 ln_bldtl 0 xbe 2.42 xce 1.21 xde 1.21;
	contrast "Pair-wise Adj Cell Means A v C"
		one 0 one_be 1 one_ce 2 one_de 1 ln_bldtl 0 xbe 1.21 xce 2.42 xde 1.21;
	contrast "Pair-wise Adj Cell Means A v D"
		one 0 one_be 1 one_ce 1 one_de 2 ln_bldtl 0 xbe 1.21 xce 1.21 xde 2.42;
	contrast "Pair-wise Adj Cell Means B v C"
		one 0 one_be 1 one_ce -1 one_de  0 ln_bldtl 0 xbe 1.21 xce -1.21 xde     0;
	contrast "Pair-wise Adj Cell Means B v D"
		one 0 one_be 1 one_ce  0 one_de -1 ln_bldtl 0 xbe 1.21 xce     0 xde -1.21;
	contrast "Pair-wise Adj Cell Means C v D"
		one 0 one_be 0 one_ce  1 one_de -1 ln_bldtl 0 xbe    0 xce  1.21 xde -1.21;

	** GLM Testing Strategy **;
	contrast "Test of Coincidence"
		one 0 one_be 2 one_ce 1 one_de 1 ln_bldtl 0 xbe 0 xce 0 xde 0,
		one 0 one_be 1 one_ce 2 one_de 1 ln_bldtl 0 xbe 0 xce 0 xde 0,
		one 0 one_be 1 one_ce 1 one_de 2 ln_bldtl 0 xbe 0 xce 0 xde 0,
		one 0 one_be 0 one_ce 0 one_de 0 ln_bldtl 0 xbe 2 xce 1 xde 1,
		one 0 one_be 0 one_ce 0 one_de 0 ln_bldtl 0 xbe 1 xce 2 xde 1,
		one 0 one_be 0 one_ce 0 one_de 0 ln_bldtl 0 xbe 1 xce 1 xde 2;
	contrast "Step-down: Equal Intercept"	
		one 0 one_be 2 one_ce 1 one_de 1 ln_bldtl 0 xbe 0 xce 0 xde 0,
		one 0 one_be 1 one_ce 2 one_de 1 ln_bldtl 0 xbe 0 xce 0 xde 0,
		one 0 one_be 1 one_ce 1 one_de 2 ln_bldtl 0 xbe 0 xce 0 xde 0;
	contrast "Step-down: Equal Slopes (Full vs. ANCOVA)"
		one 0 one_be 0 one_ce 0 one_de 0 ln_bldtl 0 xbe 2 xce 1 xde 1,
		one 0 one_be 0 one_ce 0 one_de 0 ln_bldtl 0 xbe 1 xce 2 xde 1,
		one 0 one_be 0 one_ce 0 one_de 0 ln_bldtl 0 xbe 1 xce 1 xde 2;
	contrast "Pair-wise Intercepts A v B"
		one 0 one_be 2 one_ce 1 one_de 1 ln_bldtl 0 xbe 0 xce 0 xde 0;
	contrast "Pair-wise Intercepts A v C"
		one 0 one_be 1 one_ce 2 one_de 1 ln_bldtl 0 xbe 0 xce 0 xde 0;
	contrast "Pair-wise Intercepts A v D"
		one 0 one_be 1 one_ce 1 one_de 2 ln_bldtl 0 xbe 0 xce 0 xde 0;
	contrast "Pair-wise Intercepts B v C"
		one 0 one_be 1 one_ce -1 one_de  0 ln_bldtl 0 xbe 0 xce 0 xde 0;
	contrast "Pair-wise Intercepts B v D"
		one 0 one_be 1 one_ce  0 one_de -1 ln_bldtl 0 xbe 0 xce 0 xde 0;
	contrast "Pair-wise Intercepts C v D"
		one 0 one_be 0 one_ce  1 one_de -1 ln_bldtl 0 xbe 0 xce 0 xde 0;

	** Test of Full Model vs ANOVA Model **;
	contrast "All Slopes = 0 (Full vs ANOVA)"
		one 0 one_be 0 one_ce 0 one_de 0 ln_bldtl 1 xbe -1 xce -1 xde -1,
		one 0 one_be 0 one_ce 0 one_de 0 ln_bldtl 1 xbe  1 xce  0 xde  0,
		one 0 one_be 0 one_ce 0 one_de 0 ln_bldtl 1 xbe  0 xce  1 xde  0,
		one 0 one_be 0 one_ce 0 one_de 0 ln_bldtl 1 xbe  0 xce  0 xde  1;
	run;

***** EXAMPLE 16.19 - Backwards Groupwise Testing with Effect Coding  *****;	
***** EXAMPLE 16.20 - ANCOVA Contrasts of Interest with Effect Coding *****;
title1 "Ex16.15/Output 16.6 Effect Coding: Model 2 ANCOVA";
proc glm data=ch16_03;
	model ln_brntl = one one_be one_ce one_de ln_bldtl / noint solution;
	** Test of Equal Intercepts **;
	contrast "Equal Intercept (ANCOVA vs. Regression)"	
		one 0 one_be 2 one_ce 1 one_de 1 ln_bldtl 0,
		one 0 one_be 1 one_ce 2 one_de 1 ln_bldtl 0,
		one 0 one_be 1 one_ce 1 one_de 2 ln_bldtl 0;	

	** Estimates of Adjusted Cell Means **;
	estimate "Adj Cell Mean: Group A"
		one 1 one_be -1 one_ce -1 one_de -1 ln_bldtl 1.21;
	estimate "Adj Cell Mean: Group B"
		one 1 one_be  1 one_ce  0 one_de  0 ln_bldtl 1.21;
	estimate "Adj Cell Mean: Group C"
		one 1 one_be  0 one_ce  1 one_de  0 ln_bldtl 1.21;
	estimate "Adj Cell Mean: Group D"
		one 1 one_be  0 one_ce  0 one_de  1 ln_bldtl 1.21;
	run;

title1 "Ex16.21 Effect Coding: Model 4 ANOVA";
proc glm data=ch16_03;
	model ln_brntl = one one_be one_ce one_de / noint solution;
	title2 "Model 4: ANOVA";
	run;


proc glm;
quit;
run;


