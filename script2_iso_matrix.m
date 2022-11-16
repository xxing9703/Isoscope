% This script demonstrates how to extract intensity matrix of isotopologues
% for a given metabolite peak along with the metadata from '.mat' without running isoScope

%% Step 1: load .mat into memory
load('Figure2-kidneys-lactate-M3.mat');  % add path if not in current
padding=[10,10,10,10]; % add paddings around the cropped image.
msi=msi_get_metadata(msi,padding); %initialize, get metadata

%% Step 2: Define an m/z peak using class Mzpk, set parameters
mypk=Mzpk('C6H8O7');  %initiate a peak (formula must be provided)
mypk.name='Citrate';  %name, optional
mypk.z=-1; % ion mode [M-H]- (default is -1)
mypk.ppm=5; % m/z tolerance in ppm (defalt is 5)
mypk.isoType=1; % choose isotope type: (1=13C (default), 2=15N, 3=2D, 4=13C15N). 

%% step 3  obtain the data matrix
msi=msi_get_idata(msi,mypk); % get intensity data (M=0 only)
msi=msi_get_isoidata(msi,mypk); %get intensity data for isotopologues (M=0,1,2...)

% msi.metadata stores the spatial [X Y] 
% msi.idata stors the intensity data for M=0
% msi.isoidata.idata stores the intensity data for all isotopologues
matrix=[msi.metadata,msi.isoidata.idata]; % concatenate metadata with intensity matrix

% copy paste from workspace or export 'matrix' to excel file using xlswrite(filename,matrix)
