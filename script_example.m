% This is a demo script, displays absolute or enrichment ratio image for Citrate 13C isotope M=6
% In step 2 and 3 choose to run either a or b, but not both.

%% Step 1, load data
fname='..\Imaging Data\kidney.mat';  % change the path to your data location
load (fname);
padding=[20,20,20,20]; % add paddings around data region after a default tight cropping
msi=msi_get_metadata(msi,padding); %initialize, get metadata,ref and alphadata
%% Step 2: Define a mass peak
mypk=Mzpk('C6H8O7');  %initiate a peak with inputting formular
mypk.name='Citrate';  %type in name, optional
%% Step 2a alternative: select a mass peak from pre-defined pks table
% fname='list00.xlsx'; %load metabolite known list
% pkid=10; %pick a peak (10th peak in the list which is citrate)
% pks=table2struct(readtable(fname)); %create a peak list structure
% mypk=Mzpk(pks(pkid)); 

%% Step 3 Add peak settings
mypk.z=-1; % ion mode (default is -1)
mypk.ppm=5; % m/z tolerance in ppm (defalt is 5)
mypk.offset=0;  % added m/z offset in ppm (default is 0)
mypk.isoType=1; % choose isotope type: (1=13C (default), 2=15N, 3=2D, 4=13C15N). This setting only matters for isotopes(M>0)
mypk.M=6;  % specify which isotopomer to display (default is 0)
mypk.addType=1; % there's a predefined adduct list stored in T, which differs by ion mode, (default is 1: no adduct). 
% type mypk to display all settings of the m/z peak 

%% step 4  run this code to get the isoimage data and display images for enrichment ratio
display_type=2; %1=absolute, 2=enrichment ratio, 3=labeling fraction;
msi=msi_get_idata(msi,mypk); % get intensity data
msi=msi_get_isoidata(msi,mypk); %get intensity data for isotope data (natual isotope corrected)
msi=msi_select_idata(msi,mypk.M_,display_type); %copy the selected data to msi.imgdata
%% Step 4a. alternative: run this code to get the image data for absolute intensity
% msi=msi_get_idata(msi,mypk); % get intensity data
% msi=msi_update_imgdata(msi); % update imgdata
%%  Step 5. display settings
 cmap=parula;  %specify colormap
 colorscale=[0,0.45]; %specfy colorscale, normalized to the 1
 scalebarOnOff='on';
 resize=4;  % image resize magnification factor
%% Step 6.  run code below to display the image 
 msi.imgC=msi2rgb(msi.imgdata,msi.alphadata,cmap,colorscale);  
 f=figure('units','normalized');
 ax=axes(f, 'units','normalized');
 imobj=imshow(msi.imgC,msi.ref,'parent',ax);
 ax.Colormap=cmap;
 ax.CLim=colorscale*max(msi.idata); %color limit 
 colorbar(ax)
 scalebar=Pscale(ax);
 scalebar.visible=scalebarOnOff;
 f.OuterPosition=[0 0 1 1]; %maximize figure