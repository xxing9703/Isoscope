function distout=isocorr_mat(distin,n,type)

r=0.0107; r1=0.0107; %ro=3.8e-4; 
if nargin>2
   if type==1
     r=0.0107; r1=0.0107;
   elseif type==2
     r=0.00364; r1=0.00364;
   elseif type==3
     r=0.000115;r1=0.000115;
   end
end
if size(distin,2)==1
    distin=distin';
end
if nargin<2
    n=size(distin,2)-1;
end

%C matrix
M=zeros(n+1,n+1);
for i=1:n+1
    for j=1:i
      a=n+1-j;
      b=i-j;
      M(i,j)=nchoosek(a,b)*(1-r)^(a-b)*r^b;
    end
end
Mp=zeros(n+1,n+1);
for i=1:n+1
    for j=i:n+1
      a=n+1-(n+2-j);
      b=j-i;
      Mp(i,j)=nchoosek(a,b)*(1-r1)^(a-b)*r1^b;
    end
end
%O matrix
% Mo=zeros(n+1,n+1);
% for i=1:n+1
%     if i>1   
%     Mo(i,i-1)=nchoosek(2,1)*(1-ro)*ro;
%     end
%     Mo(i,i)=nchoosek(2,0)*(1-ro)^2;
% end

N=inv(M*Mp);
distout=N*distin';
distout=distout';
distout=max(distout,0); %nonzero
distout=distout./sum(distout,2); 
%distout=max(distout,0); %nonzero
%distout=distout/sum(distout); %re-normalize

%figure,bar([A,B])