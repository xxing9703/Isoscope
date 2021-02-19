# Introduction
IsoScope is an open-source, user-friendly software package to visualize and perform data analysis of mass spectrometry imaging (msi) data, with a focus on isotope labeling. The package was originally designed and tested with Bruker’s solariX data, but can also take the standard .imzML data format. IsoScope has the basic functionalities of data parsing, processing, peak detection, image browsing, mass spectrum browsing, region of interest (ROI) selection, data extraction, image overlay, etc. IsoScope stands out for enabling facile analysis of isotope-labeled imaging data (including 13C, 15N, 2H and 13C15N double tracer). Specifically, with only a few clicks, the software can present spatial images for isotope labeled forms or average carbon atom labeling of a metabolite, including after natural isotope abundance correction.

<hr>

# Data Input
The standard imaging data format of .imzML and .ibd files in pairs with identical filenames
OR
.mis file with .d folder of the same name (Brukers solariX XR FTICR) 

Data will need to be converted to '.mat' before IsoScope takes directly as the input.  (See User's guide for details)

# Installation
Matlab 2018b or later is required, along with the following toolboxes:
-image processing tool box
-statistics and machine learning tool box

IsoScope.m is the main code to start the GUI application in matlab.
Demo_example.m is a script demo 

# Bug report
If you have any questions, please contact Xi Xing (xxing@Princeton.edu)





