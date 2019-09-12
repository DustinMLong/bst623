********************************************************************************;
* CHAPTER 6 EXAMPLES                                                           *;
* Use data FILEF                                                               *;
********************************************************************************;
LIBNAME GLM01 "..\DATA";
footnote "-- CH06.SAS --";


***** EXAMPLE 6.1 - Corrected R^2 *****;
title1 "Ex6.1/Output 6.1  Full Model";
proc glm data=GLM01.FILEF;
   model fev1 = height weight age;
   run;


***** EXAMPLE 6.2 - Uncorrected R^2 *****;
title1 "Ex6.2/Output 6.2  Full Model, Using INT Option";
proc glm data=GLM01.FILEF;
   model fev1 = height weight age / int ;
   run;

title1 "Ex6.2/Output 6.3  Uncorrected R-square";
data ch06_01;
   set GLM01.FILEF;
   INTERCPT = 1;
   run;

proc glm data=ch06_01;
   model fev1 = intercpt height weight age / noint;
   run;


***** EXAMPLE 6.3 - Sample Correlation Coefficients *****;
title1 "Ex6.3/Ouptut 6.4  Sample Correlation Coefficents";
proc corr data=GLM01.FILEF nosimple noprob;
   var fev1 height weight age;
   run;


***** EXAMPLE 6.4 - Full Partial Correlation using PROC CORR *****;
title1 "Ex6.4/Output 6.5  Full Partial Correlation Using the PARTIAL Statement in PROC CORR";
proc corr data=GLM01.FILEF nosimple /*noprob*/;
   var fev1 height;
   partial age;
   run;


***** EXAMPLE 6.5 - Full Partial Correlation using PROC REG *****;
title1 "Ex 6.5/Output 6.6  Full Partial Correlation Using the PCORR1 or PCORR2 Option in REG";
proc reg data=GLM01.FILEF;
   model fev1 = age height / pcorr1 pcorr2 ;
   run;


***** EXAMPLE 6.6 - Full Partial Correlation using PROC GLM and the MANOVA Statement *****;
title1 "Ex 6.6/Output 6.7  Full Partial Correlation Using the MANOVA Statement in GLM";
   proc glm data=GLM01.FILEF;
   model fev1 height = age;
   manova / printe;
   run;


***** EXAMPLE 6.7 - Full Partial Correlation Obtained from Correlating Residuals *****;
title1 "Ex 6.7/Output 6.8  Full Partial Correlation Obtained from Correlating Residuals";
proc glm data=GLM01.FILEF noprint;
   model fev1 = age;
   output out=ch06_02 r=e_fev1;
   run;
proc glm data=GLM01.FILEF noprint;
   model height = age;
   output out=ch06_03 r=e_ht;
   run;
proc sort data=ch06_02;  by subject;  run;
proc sort data=ch06_03;  by subject;  run;
data ch06_04;
   merge ch06_02 ch06_03;
   by subject;
   run;
proc corr noprob nosimple data=ch06_04;
   var e_fev1 e_ht;
   run;


***** EXAMPLE 6.8 - Semi-Partial Correlation using PROC REG *****;
title1 "Ex 6.8/Output 6.9  Semi-Partial Correlation Using the SCORR1 or SCORR2 Option in REG";
proc reg data=GLM01.FILEF;
   model fev1 = weight height / scorr1 scorr2 ;
   run;


***** EXAMPLE 6.9 - Semi-Partial Correlation Obtained from Correlating Residuals *****;
title1 "Ex 6.9/Output 6.10  Semi-Partial Correlation Obtained from Correlating Residuals";
proc glm data=GLM01.FILEf noprint;
   model height = weight;
   output out=ch06_05 residual=e_ht;
   run;

proc corr data=ch06_05 nosimple noprob;
    var fev1 e_ht;
    run;


***** EXAMPLE 6.10 - Multiple Partial Correlation Obtained using PROC CORR *****;
title1 "Ex 6.10/Output 6.11  Multiple Partial Correlation Obtained Using the PARTIAL Statement in PROC CORR";
proc corr data=GLM01.FILEF nosimple /* noprob */;
   var fev1 height;
   partial weight age;
   run;


***** EXAMPLE 6.11 - Multiple Partial Correlation Obtained from Correlating Residuals *****;
title1 "Ex 6.11/Output 6.12 Multiple Partial Correlation Obtained from Correlating Residuals";
proc glm data=GLM01.FILEF;
   model fev1 height = weight age;
   manova / printe;
   run;


***** EXAMPLE 6.12 - Multiple Semi-Partial Correlation *****;
title1 "Ex 6.12/Output 6.13  Multiple Semi-Partial Correlation Obtained From Correlating Residuals";
proc glm data=GLM01.FILEF noprint;
   model height = weight age;
   output out=ch06_06 residual=e_ht;
   run;

proc corr data=ch06_06 nosimple noprob;
   var fev1 e_ht;
   run;


***** EXAMPLE 6.13 - Tests of Semi-Partial Correlation *****;
title1 "Ex 6.13/Output 6.14  Test of Semi-Partial Correlation r(FEV1, HEIGHT | WEIGHT)";
proc glm data=GLM01.FILEF;
   model fev1 = weight height age;
   run;


***** EXAMPLE 6.14 - Test of Multiple Semi-Partial Correlation *****;
title1 "Ex 6.14/Output 6.15  Model 1 of the Group Added-Last Model Pool";
proc glm data=GLM01.FILEF;
   model fev1 = weight;
   quit;
   run;


