% Copyright 2018, Princeton University
% Written by Xi Xing
% This function reads full mass spectrum from disk .ibd file
% Input: file handle, msi structure, ids to read or xy position
% usage read_ims(fid,msi,id) or read_ims(fid,msi,[],xy)
% fid=fopen ('..\Kidney DMAN.ibd');

function spec=read_ims(fid,msi,id,xy)
DBL=8;


if nargin==3  
x = [msi.data(id).x];
y = [msi.data(id).y];
elseif nargin>3
    x=xy(:,1);
    y=xy(:,2);
    del=[];
    for n=1:size(xy,1)
      tp=find([msi.data.x]==x(n) & [msi.data.y]==y(n));
      if isempty(tp)
          del=[del,n];
          id(n)=0;
      else
          id(n)=tp;
      end
    end
    if ~isempty(del)
    x(del)=[];
    y(del)=[];
    id(del)=[];
    end
end

for n=1:length(id)
  id_t=id(n);    
%read mz
fseek(fid, msi.data(id_t).offset,-1);  %move pointer to absolute offset (-1)
mz=fread(fid,msi.data(id_t).length,'double');  %read desired length @double (8 bytes) 

%read intensity
if isfield(msi.data,'offset2')
    fseek(fid, msi.data(id_t).offset2,-1); 
else
    fseek(fid, msi.data(id_t).offset+msi.data(id_t).length*DBL,-1);
end

sig=fread(fid,msi.data(id_t).length,'double');

spec(n).id=msi.data(id_t).id;
spec(n).x=x(n);
spec(n).y=y(n);
spec(n).peak_mz=single(mz);  % use single instead of double to reduce size
spec(n).peak_sig=single(sig);
end

