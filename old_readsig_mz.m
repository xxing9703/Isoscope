function [mz_out,output]=readsig_mz(msi,mz_out,scanID_sub,sp)
ids=scanID_sub(randperm(length(scanID_sub),sp));
ppm=msi.pk.ppm;
dt=msi.data;
output=zeros(size(mz_out,1),length(ids)); 

for j=1:length(ids)    
    spec_mz=dt(ids(j)).peak_mz;
    spec_sig=double(dt(ids(j)).peak_sig);
    for i=1:size(mz_out,1)      
       mz=mz_out(i,1); 
        sig=ms2sig(spec_mz,spec_sig,[mz*(1-ppm*1e-6),mz*(1+ppm*1e-6)]);
        if sig>0
        output(i,j)=sig;
        end
    end  
  %  sc(i)=prctile(tp,95)/prctile(nonzeros(tp),5);
end
mz_out(:,2)=sum(output,2)/sp;
for i=1:size(mz_out,1)
   mz_out(i,3)=nnz(output(i,:))/size(output,2);
end
