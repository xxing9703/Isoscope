% get intensity matrix of the current peak list(pks) & m/z setting from gui.
function [msi,err]=msi_get_imax(msi,pks)
pk=msi.pk;
for i=1:length(pks)
    mypks(i)=Mzpk(pks(i));
    mypks(i).ppm=pk.ppm;
    mypks(i).offset=pk.offset;
    mypks(i).isoType=pk.isoType;
    mypks(i).z=pk.z;
end
matrix=[];cov=[];sig=[];
for i=1:length(mypks)    
    mypk=mypks(i);        
    msi=msi_get_idata(msi,mypk);
    er=msi.errdata;
    er(er==-99)=nan;
    err(:,i)=er;
    matrix=[matrix, msi.idata];   % matrix(isnan(matrix))=0;
end 
msi.imax=matrix;




