% use 80 percentile of the merged MS signal as the noise baseline, multiplies fold for noise cutoff 
function [mz_out,msdata]=ms_merge_bat(msi,scanID_sub,sp,fold)
mz_out=[];
ids=scanID_sub(randperm(length(scanID_sub),sp));
fprintf(['ms_merging...','\n']); 
for i=1:length(ids)  
 ms=double([msi.data(ids(i)).peak_mz(:),msi.data(ids(i)).peak_sig(:)]);%a spectrum 
 ms=ms_remove_dup(ms,msi.pk.ppm); %remove dup
 msdata(i).mz=msi.data(ids(i)).peak_mz;
 msdata(i).sig=double(msi.data(ids(i)).peak_sig);     
 mz_out=mergeTwoSorted(mz_out,[ms,ones(size(ms,1),1)]);
 mz_out=ms_merge(mz_out,msi.pk.ppm);
 ct(i)=size(mz_out,1);
end
mz_out(mz_out(:,3)>length(ids),3)=length(ids);
mz_out(:,2)=mz_out(:,2)/sp;

idx=find(mz_out(:,2)>prctile(mz_out(:,2),80)*fold);  % noise level cutoff
mz_out=mz_out(idx,:);