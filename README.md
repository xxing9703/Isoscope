# Introduction
IsoScope is an open-source, user-friendly software package to visualize and perform data analysis of mass spectrometry imaging (msi) data, with a focus on isotope labeling. The package was originally designed and tested with Bruker’s solariX data, but can also take the standard .imzML data format. IsoScope has the basic functionalities of data parsing, processing, peak detection, image browsing, mass spectrum browsing, region of interest (ROI) selection, data extraction, image overlay, etc. IsoScope stands out for enabling facile analysis of isotope-labeled imaging data (including 13C, 15N, 2H and 13C15N double tracer). Specifically, with only a few clicks, the software can present spatial images for isotope labeled forms or average carbon atom labeling of a metabolite, including after natural isotope abundance correction.

<hr>

# Data Input
IsoScope takes the '.mat' data of matlab structure as direct input, which is already processed after peak picking, much smaller in size and contains centroid mass spectra peaks only.  So, please use tools provided to convert from the original image data first. 
There are three types of original data it can take:
1. The standard imaging data format of .imzML and .ibd files in pairs with identical filenames
2. mis file along with .d folder of the same name, the same file that flexImaging(commercial software from Bruker) loads. This is specific for Bruker's solariX XR FTICR instrument, code attempts to read and convert peaks.sqlite in .d folder.
3. xlsx or csv files with specific format (Note: this is for target plate samples only, not for MALDI)  

An example data file (kidney.mat) can be accessed from the link below. (Due to the large file size, it is not included in this repo)
https://drive.google.com/file/d/18Fctxx6yiY9cwl4HtC-PR1g_ex1fRrsl/view?usp=sharing

# Installation and running the code
## option 1: With Matlab Installed 
IsoScope was development with Matlab 2018b.  So the same or later version of matlab is highly recommended and you need a matlab license. 

The following Matlab toolboxes are required, please check those boxes when installing matlab:
-image processing tool box
-statistics and machine learning tool box

IsoScope.m is the main code to start the GUI application in matlab.
script_example.m is a script demo 

## Option 2: Without Matlab Installed
Download and run the installation file "MyAppInstaller_web.exe" in the subfoder \Isoscope\for_redistribution.  It will guide you through all the installations steps.
Note that, the initial run may take longer time to start the application.

This application is deployed under matlab 2019b of a Window 64bit system. You do not need a matlab license but you will be asked to install the matlab 2019 runtime library first, which is free.  

The installation file for Mac OS will be available soon.

# User's Guide
please find the user's guide documentation in the file "IsoScope User's Guide.pdf".


# Bug report
This software is under continuouse development and updates. If you have any questions, please contact the author: Xi Xing (xxing@Princeton.edu)





