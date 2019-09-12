*******************************************************************************;
* FILED: Bone Mineral Content Data                                            *;
*******************************************************************************;

TITLE1 "FILED: Bone Mineral Content Data";
TITLE2 "Sjostedt, Zetterberg, Hansson, Hult & Ekstrom";
TITLE3 "Acta Orthopaedica Scandinavica, 1994, 65, 161-165";
TITLE4 "Create permanent data file";

FILENAME IN01  "..\DATA\FILED.DAT";
LIBNAME  OUT01 "..\DATA\";

DATA OUT01.FILED;
LENGTH METHOD $1;
     INFILE IN01;
     INPUT SPECIMEN AGE METHOD BMC STIFF0 STIFF10 STIFF20
           COMP1 COMP1000 COMP2000 COMP3000 COMPTOTL STIFFAFT COMPULT;
LABEL SPECIMEN="Cadaver source"
      AGE     ="Age in years"
      METHOD  ="Osteosynthesis pin type/method"
      BMC     ="Bone mineral content, g/cm**2"
      STIFF0  ="Stiffness, 0 deg forc/diaphysis, MN/m"
      STIFF10 ="Stiffness, 10 deg forc/diaphysis, MN/m"
      STIFF20 ="Stiffness, 20 deg forc/diaphysis, MN/m"
      COMP1   ="Compression in cycle 1, mm"
      COMP1000="Compression in cycles 2-1000, mm"
      COMP2000="Compression in cycles 1001-2000, mm"
      COMP3000="Compression in cycles 2001-3000, mm"
      COMPTOTL="Total compression during loading"
      STIFFAFT="Stiffness after loading, MN/m"
      COMPULT ="Ultimate compression strength, N";

PROC PRINT DATA=OUT01.FILED;

PROC MEANS DATA=OUT01.FILED MEAN STD MIN MAX;
VAR _NUMERIC_;

PROC FREQ DATA=OUT01.FILED;
TABLES _CHARACTER_ ;
RUN;