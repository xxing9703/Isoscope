# Introduction
IsoScope is an open-source, user-friendly software package to visualize and perform data analysis of mass spectrometry imaging (msi) data, with a focus on isotope labeling. The package was originally designed and tested with Bruker’s solariX data, but can also take the standard .imzML data format. IsoScope has the basic functionalities of data parsing, processing, peak detection, image browsing, mass spectrum browsing, region of interest (ROI) selection, data extraction, image overlay, etc. IsoScope stands out for enabling facile analysis of isotope-labeled imaging data (including 13C, 15N, 2H and 13C15N double tracer). Specifically, with only a few clicks, the software can present spatial images for isotope labeled forms or average carbon atom labeling of a metabolite, including after natural isotope abundance correction.

<hr>

# Data Input
IsoScope takes the '.mat' data of matlab structure as direct input, which is already processed after peak picking, much smaller in size and contains centroid mass spectra peaks only.  So, please use tools provided to convert from the original image data first. 
There are three types of original data it can take:
1. The standard imaging data format of .imzML and .ibd files in pairs with identical filenames
2. mis file along with .d folder of the same name, the same file that flexImaging(commercial software from Bruker) loads. This is specific for Bruker's solariX XR FTICR instrument, code attempts to read and convert peaks.sqlite in .d folder.
3. xlsx or csv files with specific format (Note: this is for target plate samples only, not for MALDI)  

# Example Data
example Input imaging data in ".mat" format can be found in public repositories:

[Kidney Data:dx.doi.org/10.6084/m9.figshare.15482112](http://dx.doi.org/10.6084/m9.figshare.15482112)

[Brain Data:dx.doi.org/10.6084/m9.figshare.15505848](http://dx.doi.org/10.6084/m9.figshare.15505848) 

The demo code takes the example data "Figure2-kidneys-lactate-M3.mat" from the first link above.


# Installation and running the code
## Option 1: With Matlab Installed 
IsoScope was development with Matlab 2018b.  So the same or later version of matlab is highly recommended and you need a matlab license. 

The following Matlab toolboxes are also required, please check those boxes when installing matlab:
-image processing tool box
-statistics and machine learning tool box

IsoScope.m is the main code to start the GUI application in matlab.
script_example.m is a script demo 

## Option 2: Without Matlab Installed
For Windows 64bit system, this application was packaged under matlab 2019b
Download and run the installation file: "\Isoscope\for_redistribution\MyAppInstaller_web.exe"

For MAC OS system, this application was packaged under matlab 2020a
Download, unzip and run the installation file "\Isoscope\for_redistribution\MyAppInstaller_web_OS.app.zip". 

It will guide you through all the installations steps including the installation of a matlab runtime library (free). Typical installation time is <10 mins.
Please note that, the initial run may take longer time to start the application.

# User's Guide
Please find the user's guide documentation in the file "IsoScope User's Guide.pdf".

# Licence
It's under MIT license.

# Bug report
This software is under continuouse development and updates. If you have any questions, please contact the author: Xi Xing (xxing@Princeton.edu)





