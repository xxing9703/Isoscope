% update imgdata -- %new function%, must have msi.metadata
% Note: msi.idata and msi.imgdata must exist
function msi=msi_update_imgdata(msi) 
imgdata=msi.imgdata;
imgScanIDdata=msi.imgScanIDdata;
   for i=1:size(msi.metadata,1)                
        imgdata(msi.metadata(i,2),msi.metadata(i,1))= msi.idata(i);  %1d ->2d 
        imgScanIDdata(msi.metadata(i,2),msi.metadata(i,1))=i;
   end 
 msi.imgdata=imgdata;
 msi.imgScanIDdata=imgScanIDdata;