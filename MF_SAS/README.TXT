This directory structure contains four subdirectories:

DATA contains 
  text files of all data from Appendicies D and H.

IML contains 
  POWERLIB.IML, needed for Chapter 17 examples.  

PROGEX contains
  code to generate all output for examples in all chapters.

PROGFILE contains
  SAS data steps to create all SAS files, FILEA - FILEQ, 
  referenced in Appendices D and H.


Requirements:
SAS/BASE, SAS/STAT, and SAS/GRAPH, version 7 or above.

Instructions:
- Run the programs that create the following SAS files: FILEE, FILEF, FILEJ, 
  and FILEO.  These SAS files will be created in the DATA directory.
- Run the program containing example code for any chapter of interest.


This code will run "as is" on most PC/Windows systems, either 
interactively or in batch mode.  If the chapter 17 program does not run,
this is most likely because there are options set for SAS/GRAPH 
that are not compatible with your system. 

On systems other than PC/Windows, the LIBNAME and FILENAME statements
must be changed to conform to the operating system requirements.
This should be the only change required.