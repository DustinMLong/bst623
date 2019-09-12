********************************************************************************;
* CHAPTER 11 EXAMPLES                                                          *;
* Use data FILEO                                                               *;
********************************************************************************;
LIBNAME GLM01 "..\DATA";
footnote "-- CH11.SAS --";

title1 "Output 11.1 Contents of Data";
proc contents data=GLM01.FILEO;
   run;

title1 "Output 11.2 Missing and extreme values, raw data";
proc univariate plot data=GLM01.FILEO;
   id subject;
   var infpat1-infpat4
       redpat1-redpat4
       valhyp1-valhyp4
       invhyp1-invhyp4
       time1-time4
       satm satv male;
   run;

proc print data=GLM01.FILEO;
   where subject=35;
   title2 "SUBJECT 35 HAS EXTREME VALUE OF 32 FOR REDPAT1";
   run;


***  Create additional predictor variables            ***;
***  Generate random number from uniform distribution ***;
***     for use in splitting the sample               ***;
data fileo;
   set GLM01.FILEO;
   sat = satm + satv;
   ihyp_tot = sum(invhyp1,invhyp2,invhyp3,invhyp4);
   vhyp_tot = sum(valhyp1,valhyp2,valhyp3,valhyp4);
   rpat_tot = sum(redpat1,redpat2,redpat3,redpat4);
   ipat_tot = sum(infpat1,infpat2,infpat3,infpat4);
   sumpat = rpat_tot + ipat_tot;
   sumhyp = ihyp_tot + vhyp_tot;
   sumtime = sum(time1,time2,time3,time4);
   ihyp_imp = invhyp1 - invhyp4;
   rpat_imp = redpat1 - redpat4;
   time_imp = time1 - time4;
   trialimp = trials1 - trials4;
   seed = 8329;
   random = ranuni(seed);
   label ihyp_tot = "Total invalid hypotheses"
         vhyp_tot = "Total valid hypotheses"
         rpat_tot = "Total redundant patterns"
         ipat_tot = "Total informative patterns"
         sumpat   = "Total patterns"
         sumhyp   = "Total hypotheses"
         sumtime  = "Total time"
         ihyp_imp = "Improvement for invalid hypotheses"
         rpat_imp = "Improvement for redundant patterns"
         time_imp = "Improvement for time"
         trialimp = "Improvement for # of trials";
   run;

title1 "Output 11.3 Missing and extreme values, derived variables";
proc means data=fileo maxdec=2 min max mean std;
   var ihyp_tot vhyp_tot rpat_tot ipat_tot
       sumpat sumhyp sumtime
       ihyp_imp rpat_imp time_imp trialimp;
   run;

proc univariate plot data=fileo;
   id subject;
   var ihyp_tot vhyp_tot rpat_tot ipat_tot
       sumpat sumhyp sumtime
       ihyp_imp rpat_imp time_imp trialimp;
   title2 "SUBJECT 35 HAS EXTREME VALUE OF 32 FOR REDPAT1";
   run;


*** Split the sample, 80% exploratory / 20% confirmatory ***;
proc sort data=fileo;
   by random;
   run;

data fileo ch11_01 ch11_02;
   set fileo;
   if _n_ < (129 * 0.8) then do;
      sample = 1;
      output ch11_01;
      sat1 = sat;
      end;
   else do;
      sample=2;
      output ch11_02;
      sat2 = sat;
      end;
   output fileo;
   run;


*** EXPLORATORY ANALYSIS ***;

***  Backward elimination of groups ***;
proc reg data=ch11_01;
   model sat = {male}
               {ipat_tot rpat_tot vhyp_tot ihyp_tot}
               {trialimp rpat_imp ihyp_imp}
               {time_imp}
               {sumtime} /
         selection=backward sls=.000000000001 details
         groupnames="Male" "Performance" "TrialsImp"
                    "TimeImp" "Time";
   title1 "Output 11.4 Backward elimination of groups";
   title2 "Exploratory data";
   run;

*** Cp criterion to determine sample size ***;
proc reg data=ch11_01 outest=ch11_03 noprint;
   model sat = ipat_tot rpat_tot vhyp_tot ihyp_tot /
               selection=rsquare cp;
   title1 "Output 11.5 Cp criterion for size of final model";
   title2 "Exploratory data";
   run;

proc plot data=ch11_03;
   plot _cp_*_p_ / vref = 3 4 vaxis=1 to 10 by 1;
   title3 "_P_ (Number of parameters in model) is equivalent to p+1";
   quit;
   run;

*** Backward Single Variable Elimination to Determine Best Model ***;
proc reg data=ch11_01;
   model sat = ipat_tot rpat_tot vhyp_tot ihyp_tot /
         selection=backward sls=.00000000001 details;
   title1 "Output 11.6 Backward Single Variable Elimination";
   title2 "Exploratory data";
   quit;
   run;

*** Regression Diagnostics for Best Model ***;
title1 "Output 11.7-11.12 Best Model SAT = IPAT_TOT RPAT_TOT RHYP_TOT";
title2 "Exploratory data";
proc reg data=ch11_01 outest=ch11_04 lineprinter;
   model sat = ipat_tot rpat_tot ihyp_tot /
         collinoint tol vif;
   output out=ch11_05 p=yhat rstudent=jack_res cookd=cooks_d h=leverage;
   plot rstudent.*predicted.;
   run;

proc univariate data=ch11_05 plot;
   id subject;
   var jack_res cooks_d leverage;
   run;

*** Examination of the influence of Subject 96 ***;
title1 "Output 11.13 Best Model SAT = IPAT_TOT RPAT_TOT RHYP_TOT";
title2 "Exploratory data";
proc reg data=ch11_01;
   model sat = ipat_tot rpat_tot ihyp_tot;
   where subject ne 96;
   title3 "Subject 96 deleted, based on Cooks D, to determine influence";
   run;


*** CONFIRMATORY ANALYSIS ***;

** Compute predicted values y_2 hat from confirmatory sample X **
** and exploratory sample Beta-hat                             **;

PROC IML;
   reset noprint;
   use ch11_02;
   ** Create the response matrix **;
   read all var "sat" into y2;
   ** Include the predictors in the predictor matrix **;
   read all var {ipat_tot rpat_tot ihyp_tot} into Xp;
   ** Include a column for the intercept in predictors **;
   N = nrow(Xp);
   one = j(N,1,1);
   X2 = one || Xp;

   ** Create Beta-hat from exploratory analysis **;
   use ch11_04;
   read all var {intercept ipat_tot rpat_tot ihyp_tot} into Betatemp;
   Betahat = Betatemp`;

   ** Create predicted values y*2 for 2nd sample **;
   y_2hat = X2*Betahat;

   y2out=y2||y_2hat;
   y2nm={"y2" "y2_hat"};
   create ch11_06 var y2nm;
   append from y2out;
   close ch11_06;

quit;
run;

** Compute the squared cross-validation correlation **;
proc corr data=ch11_06;
   var y2 y2_hat;
   title1 "Output 11.14 Squared cross-validation correlation R(2)**2";
   title2 "Confirmatory X, exploratory Beta-hat";
   run;

** Compute the correlation R(1)**2 for the exploratory sample **;
proc corr data=ch11_05;
   var yhat sat;
   title1 "Output 11.14 Exploratory correlation R(1)**2";
   run;

** Examine regression diagnostics for the confirmatory sample **;
title1 "Output 11.15-11.20 Best Model SAT = IPAT_TOT RPAT_TOT IHYP_TOT";
title2 "Confirmatory data";
proc reg data=ch11_02 lineprinter;
   model sat = ipat_tot rpat_tot ihyp_tot / collinoint vif tol;
   output out=ch11_07 p=yhat rstudent=jack_res cookd=cooks_d h=leverage;
   plot rstudent.*predicted.;
   run;

proc univariate data=ch11_07 plot;
   id subject;
   var jack_res cooks_d leverage;
   run;


*** FINAL MODEL ***;

** Fit the best model using the complete set of data **;
** Examine regression diagnostics                    **;
title1 "Output 11.21-11.26 Best Model SAT = IPAT_TOT RPAT_TOT IHYP_TOT";
title2 "Complete data";
proc reg data=fileo lineprinter;
   model sat = ipat_tot rpat_tot ihyp_tot / collinoint vif tol;
   output out=ch11_08 p=yhat rstudent=jack_res cookd=cooks_d h=leverage;
   plot rstudent.*predicted.;
   run;

proc univariate data=ch11_08 plot;
   id subject;
   var jack_res cooks_d leverage;
   run;


