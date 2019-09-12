********************************************************************************;
* CHAPTER 5 EXAMPLES                                                           *;
* Use data FILEF                                                               *;
********************************************************************************;
LIBNAME GLM01 "..\DATA";
footnote "-- CH05.SAS --";

***** EXAMPLE 5.1 - Added-Last Model Pool     *****;
***** EXAMPLE 5.6 - Added-Last Test           *****;
***** EXAMPLE 5.8 - Intercept Added-Last Test *****;
title1  "Ex5.1 Added-Last Model Pool";
title2 "Ex5.6/Output 5.3 Model (-2) of the Added-Last Model Pool";
title3 "Ex5.8/Output 5.6 Model (-0) of the Added-Last Model Pool";
proc reg data=GLM01.FILEF;
   m_0:  model fev1 = height weight age / noint;    * Model (-0) *; 
   m_1:  model fev1 = weight age;                   * Model (-1) *;
   m_2:  model fev1 = height age;                   * Model (-2) *;
   full: model fev1 = height weight age;            * Full Model *;
   run;


***** EXAMPLE 5.2 - Added-in-Order Model Pool               *****;
***** EXAMPLE 5.3 - Relationships Between USS, CSS, and SSE *****;
***** EXAMPLE 5.7 - Added-in-Order Test                     *****;
***** EXAMPLE 5.9 - Intercept Added-in-Order Test           *****;
title1  "Ex5.2 Added-in-Order Model Pool";
title2 "Ex5.3/Output 5.1 Full Model";
title3 "Ex5.7/Output 5.4 Model 1 of the Added-In-Order Model Pool";
title4 "Ex5.7/Output 5.5 Model 2 of the Added-In-Order Model Pool";
title5 "Ex5.9/Output 5.7-5.8, Null and Model 0 of the Added-In-Order Model Pool";
proc reg data=GLM01.FILEF;
   null: model fev1 = / noint;                      * Null Model *;
   m0:   model fev1 = ;                             * Model 0    *;
   m1:   model fev1 = height;                       * Model 1    *;
   m2:   model fev1 = height weight;                * Model 2    *;
   full: model fev1 = height weight age / ss1 ss2;  * Full Model *;
   run;


***** EXAMPLE 5.5 - Uncorrected Overall Test *****;
title1 "Ex5.5/Output 5.2 Full Model using the INT option";
proc glm data=GLM01.FILEF;
   model fev1 = height weight age / int;
   run;


***** EXAMPLE 5.11 - Group Added-Last Test *****;
title1 "Ex5.11/Output 5.9 Model 2 of the Group Added-Last Model Pool";
proc glm data=GLM01.FILEF;
   model fev1 = age;
   run;

title1 "Ex5.11 Group Added-Last Test";
proc reg data=GLM01.FILEF;
   full: model fev1 = height weight age;
   Group_Added_Last: test height=0, weight=0;
   run;

title1 "Ex5.11 Group Added-Last Test";
proc glm data=GLM01.FILEF;
   model fev1 = height weight age;
   contrast "Group Added-Last"
             height 1 ,
             weight 1 ;
   contrast "Group Added-Last"
          intercept 0   height 1   weight 0   age 0 ,
          intercept 0   height 0   weight 1   age 0  ;
   run;


***** EXAMPLE 5.12 - Group Added-in-Order Model Pool *****;
title1  "Ex5.12 Group Added-in-Order Test";
title2 "(methods that do not use the full model MSE)";
proc reg data=GLM01.FILEF;
   m2: model fev1 = height weight ;
   Group_Added_In_Order: test height=0, weight=0;
   run;

proc glm data=GLM01.FILEF;
   model fev1 = height weight ;
   contrast "Group Added-In-Order"
             height 1  ,
             weight 1 ;
   run;


***** EXAMPLE 5.11 - Group Added-Last Test     *****;
***** EXAMPLE 5.13 - Group Added-in-Order Test *****;
title1 "Ex5.11, 5.13 P-values";
data ch05_01;
   Example = "5.11";
   pval = 1 - probf(7.08,2,67);
   output;
   Example = "5.13";
   pval = 1 - probf(136.55,1,67);
   output;
   run;

proc print data=ch05_01;
   run;


