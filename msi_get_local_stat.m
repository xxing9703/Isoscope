%local regions are defined by msi.R (ROI) or msi.S (segments)
%R.subID or S.subID defines the local mask.  This function calculates the statistic for each local region
%R.c stores the coverage%, R.s stores the mean signal(zeros are counted). 
% msi.imax (intensity matrix)is required to have before running this function
% flag=0 default do both, flag=1: R only, flag=2: S only
function msi=msi_get_local_stat(msi,flag)
if nargin<2
    flag=0;
end
roigrp=getappdata(msi.handles.figure1,'roigrp');
M=msi.imax;
if ~isempty(roigrp) && flag~=2
   for i=1:length(roigrp) 
     R(i).subID=roigrp(i).BW.*msi.imgScanIDdata;
     R(i).subID=R(i).subID(R(i).subID>0);
     R(i).c=zeros(size(M,2),1);
     R(i).s=zeros(size(M,2),1);
     M_sub=M(R(i).subID,:);
    for j=1:size(M,2)
        R(i).c(j)=nnz(M_sub(:,j))/size(M_sub,1);
    end
     R(i).s=mean(M_sub)';
   end
   msi.R=R;
end
if ~isempty(msi.seg) && flag~=1
   segs=unique(msi.seg);
   for i=1:length(segs)     
     S(i).subID=find(msi.seg==segs(i));
     S(i).c=zeros(size(M,2),1);
     S(i).s=zeros(size(M,2),1);
     M_sub=M(S(i).subID,:);
    for j=1:size(M,2)
        S(i).c(j)=nnz(M_sub(:,j))/size(M_sub,1);
    end
     S(i).s=mean(M_sub)';
   end
   msi.S=S;
end



