%distin  input isotopmer distribution matrix, one sample per column
%n: C number, m: N number
%Cb: C impurity, Nb: N impurity
function [distout,mm,distout_pct]=isocorr_CN(distin,n,m,Cb,Nb)

Ca=0.0107;  %natural 13C abundance
Na=0.00364; %natural 15N abundance

if nargin<4
   Cb=0.01;  
   Nb=0.01;
end

%C matrix
dim=(n+1)*(m+1);
M=zeros(dim,dim);
mm=zeros(dim,dim,4);
mmp=zeros(dim,dim,4);
for i=1:dim
   C_num_row=floor((i-1)/(m+1));
   N_num_row=mod((i-1),(m+1));
    for j=1:i
         C_num_col=floor((j-1)/(m+1));
         N_num_col=mod((j-1),(m+1));
         
         a1=n-C_num_col;
         b1=C_num_row-C_num_col;    
        
      
         a2=m-N_num_col;
         b2=N_num_row-N_num_col;      
      mm(i,j,:)=[a1,b1,a2,b2];
      if b1>=0 && b2>=0     
        M(i,j)=dbinom(a1,b1,Ca)*dbinom(a2,b2,Na);
      end
    end
end

Mp=zeros(dim,dim);
for i=1:dim
   C_num_row=floor((i-1)/(m+1));
   N_num_row=mod((i-1),(m+1));
    for j=i:dim
         C_num_col=floor((j-1)/(m+1));
         N_num_col=mod((j-1),(m+1));
         
         a1=C_num_col;
         b1=C_num_col-C_num_row;    
        
      
         a2=N_num_col;
         b2=N_num_col-N_num_row;      
      mmp(i,j,:)=[a1,b1,a2,b2];
      if b1>=0 && b2>=0     
        Mp(i,j)=dbinom(a1,b1,Cb)*dbinom(a2,b2,Nb);
      end        

    end
end

N=M*Mp;
distout=distin;
 for i=1:size(distin,2)
     distout(:,i)=lsqnonneg(N,distin(:,i));
 end
 distout_pct=distout./(sum(distout,1)+1e-10);

% distout=max(distout,0); %nonzero
% distout=distout./sum(distout,2); 


function out=dbinom(a,b,r)
out=nchoosek(a,b)*(1-r)^(a-b)*r^b;
