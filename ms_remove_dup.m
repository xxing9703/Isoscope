%expand the list without having dup
function ms=ms_remove_dup(ms,ppm)
%[~,B]=sort(ms(:,1)); %sort pks.mz
%ms_sorted=ms(B,:);
ms_sorted=ms;
sz=size(ms_sorted,1);
ct=0;

a=ms_sorted(:,1);
flag=zeros(sz,1);
for i=2:sz
   j=i-1;
    while j>0 && abs(a(i)-a(j))<a(i)*ppm*1e-6 
        if flag(j)==0 
            if ms_sorted(i,2)>ms_sorted(j,2)
              flag(j)=1;
            else
              flag(i)=1;
            end
          break
        end
          j=j-1;
    end
end
ms=ms_sorted(flag==0,:);




