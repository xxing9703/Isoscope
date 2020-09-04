function [adduct_pair,annotation]=msi_find_adduct(pks,adduct,ppm)
adduct_pair=[];
annotation=cell(length(pks),1);
annotation(cellfun('isempty',annotation)) = {''};
[~,B]=sort([pks.mz]); %sort pks.mz
pks_sorted=pks(B);
[~,B]=sort([adduct.diff]); %sort adduct.mz
adduct_sorted=adduct(B);

sz=length(pks_sorted);
ct=0;
for k=1:length(adduct_sorted)
    dif=abs(adduct_sorted(k).diff);
    a=[pks_sorted.mz];  %mz sorted array
    i=2;j=1; %start point 

tp=0;
while i<=sz  % i -- higher mass, j -- lower mass
    if a(i)-a(j)<=dif+a(j)*ppm
       if a(i)-a(j)>=dif-a(j)*ppm % within range, matches mass diff
          
            ct=ct+1;
            if adduct_sorted(k).diff>0  %negative sign
                ii=i;jj=j;
            else
                ii=j;jj=i;                               
            end
            adduct_pair(ct).childID=pks_sorted(ii).id;
            adduct_pair(ct).parentID=pks_sorted(jj).id;
            adduct_pair(ct).feature=adduct_sorted(k).feature;
            adduct_pair(ct).name=adduct_sorted(k).name; 
            adduct_pair(ct).ppm=round((pks_sorted(i).mz-pks_sorted(j).mz-dif)/pks_sorted(ii).mz*1e6*10)/10; 
            annotation{pks_sorted(ii).id}=adduct_sorted(k).name;
           
           j=j+1;tp=tp+1; %in range, walk down one step,  tp++                    
       else
           i=i+1;j=j-tp;tp=0; %not in range, walk right one step, walk up tp steps if any, reset tp
       end                       
   else
       j=j+1;     %walk down one step  
   end    
end

end

fprintf('Done\n')
