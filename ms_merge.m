%expand the list without having dup
function ms=ms_merge(ms,ppm)
% tic
% [~,B]=sort(ms(:,1)); %sort pks.mz
% ms_sorted=ms(B,:);
% toc
ms_sorted=ms;
sz=size(ms_sorted,1);

a=ms_sorted(:,1);
flag=zeros(sz,1);
for i=2:sz
   if abs(a(i)-a(i-1))<a(i)*ppm*1e-6 && flag(i-1)==0
        flag(i)=1;
        ct1=ms_sorted(i-1,3);
        ct2=ms_sorted(i,3);
        
        ms_sorted(i-1,1)= (ms_sorted(i-1,1)*ct1+ ms_sorted(i,1)*ct2)/(ct1+ct2);
        ms_sorted(i-1,2)= ms_sorted(i-1,2)+ ms_sorted(i,2);
        ms_sorted(i-1,3)=ct1 + ct2;     ms_sorted(i,3)=0;       
   end
end
ms=ms_sorted(flag==0,:);




