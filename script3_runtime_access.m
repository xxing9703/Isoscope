% This script explains how to access data while isoScope is running
% It requires a running matlab environment with workspace accessible
% start isoscope and load a data before testing 
% A variable called "handles" should be visible in the workspace, which is the handle for gui 

% msi is a structure that contains most of the data.
msi=getappdata(handles.figure1, 'msi');

msi.idata % the intensity data (array) of the current image
msi.imgdata % the intensity data in (X,Y) of the current image
msi.imgC % the color image data, which can be displayed with imshow
msi.isoidata % structure contains intensity data of isotopologues. it's available only if enrichment button is pressed
    msi.isoidata.idata  %intensity data of isotopologues (original)
    msi.isoidata.idata_cor  % after normalization & with natural isotope correction
    msi.isoidata.idata_cor_original % before normalization & with natural isotope correction
    msi.isoidata.norm  % after normalization & without natural isotope correction
    msi.isoidata.idata_fra  % fractional labeling with natural isotope correction
    msi.isoidata.idata_fra_nocor  % fractional labeling without natural isotope correction
    msi.isoidata.idata_err  % err data for m/z in ppm


% pks is a structure that contains the list of targeted peaks loaded. 
pks=getappdata(handles.figure1, 'pks');
pks.data  % peak list, in the format of cell array {name, formula, m/z}
pks.sdata % peak list, in the format of structure array
  %example: use either ways below to access the formula of the first peak in the list
  pks.data{1,2}
  pks.sdata(1).Formula

% functions for updating (retreiving) image data
i=7;
mypk=Mzpk(pks.sdata(i));  % select a peak
msi=msi_get_idata(msi,mypk); % get idata
msi=msi_get_isoidata(msi,mypk); % get idata for isotopologue







