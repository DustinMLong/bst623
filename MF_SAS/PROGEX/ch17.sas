********************************************************************************;
* CHAPTER 17 EXAMPLES                                                          *;
********************************************************************************;
footnote "-- CH17.SAS --";

* Source: Figure 1 Taylor and Muller, 1995, Amer Statcn, 49, p43-47 *;
* Pointwise confidence intervals as a fctn of dif between means     *;

** Name of output files containing power curves **;
filename out01 ".\CH170101.CGM";
filename out02 ".\CH170201.CGM";

** Download the code POWERLIB.IML from the following website:          **;
**    http://www.bios.unc.edu/~muller                                  **;
** Place in neighboring directory, iml, and reference as follows.      **;
filename powerlib "..\iml\powerlib.iml";

title1;
***** EXAMPLE 17.1 - Two-Dimensional Power Curve *****;
proc iml worksize=2000 symsize=4000;
   %include powerlib;
   opt_off = {warn case rhoscal alpha};
   opt_on={ noprint ds};
   round=3;
   beta = { 0    1}`;
   c = {-1 1};
   essencex=I(2);
   sigma = { .068}; *this is the variance;
   *uncensored approach;
   alphacl=.05;
   nuscreen=24-2;
   critlow=cinv(alphacl/2,nuscreen);
   crithigh=cinv(1-alphacl/2,nuscreen);
   clomega=critlow/nuscreen;
   cuomega=crithigh/nuscreen;
   sigscal= ( (1/cuomega) || {1} || (1/clomega) )`;
   repn={12}`;
   alpha={.01};
   betascal=do(0,.75,.01);
   run power;

proc sort data=pwrdt1 out=ch17_01;
   by sigscal descending betascal;
   run;

** Options for graphics - DEVICE may need to be specified for user system **;
goptions display nocharacters papersize=letter gsfmode=replace 
   device=cgmof97p
   colors=(black) cback=white 
   horigin=0in vorigin=0in
   htext=12pt htitle=12pt hby=12pt 
   ftext=swissx ftitle=swissx fby=swissx
   hpos=80 vpos=60
   hsize=5.0in vsize=3.5in;

symbol1 i=spline v=none l=2 w=2;
symbol2 i=spline v=none l=1 w=2;
symbol3 i=spline v=none l=2 w=2;
axis1 order=(0 to 1 by .2 ) width=3 minor=none major=(w=2)
      label=("Power");
axis2 order=(0 to .75 by .25) width=3 minor=none major=(w=2)
      label=("Mean Difference, 1/cr (dl/mg)");

title1 "Ex17.1 Two-Dimensional Power Curve";

goptions gsfname=out01;
proc gplot data=ch17_01;
   plot power*betascal=sigscal / href=.5 noframe 
        vzero vaxis=axis1 hzero haxis=axis2 nolegend;
   label sigscal="variance multiplier";
   run;
   quit;
   run;


***** EXAMPLE 17.2 - Three-Dimensional Power Curve *****;
proc iml worksize=2000 symsize=4000;
   %include powerlib;
   opt_off = {warn case rhoscal alpha};
   opt_on={ noprint ds};
   round=3;
   alpha={.01};
   sigma = { .068};  sigscal=  {1} ;
   beta = { 0    1}`;
   c = {-1 1};
   essencex=I(2);
   repn=do(3,18,3);
   betascal=do(0,.75,.05);
   run power;

%macro graph(tilt,rotate);
   proc g3d data=ch17_02;
   plot betascal*total_n=power/
       zmin=0 zmax=1.0 zticknum=6   yticknum=4    xticknum=6   side;
*  rotate= &rotate       tilt  = &tilt    ;
   label total_n ="N"
         betascal="Delta"
         power   ="Power" ;
   run;
%mend;

title1 "Ex17.2 Three-Dimensional Power Curve";
proc g3grid data=pwrdt2 out=ch17_02;
     grid  betascal*total_n=power /spline  naxis1=16  naxis2=11 ;

goptions gsfname=out02;	
%graph(90, 300);