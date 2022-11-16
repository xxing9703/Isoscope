% This function reads full mass spectrum from disk .ibd file
% Input: file handle, msi structure, ids to read or xy position
% usage read_ims(fid,msi,id) or read_ims(fid,msi,[],xy)
% fid=fopen ('..\Kidney DMAN.ibd');
% modified 10/6/2021 to determine precision of (double, precision)
function spec=read_ims(fid,msi,id,xy)
DBL=8;
precision={'single','double'};
p1=(msi.data(1).offset2-msi.data(1).offset)/msi.data(1).length/4; % mz precision
if msi.data(1).offset==msi.data(2).offset %continuous mode
    p2=(msi.data(2).offset2-msi.data(1).offset2)/msi.data(1).length/4; % intensity precision
else  % processed mode
    p2=(msi.data(2).offset-msi.data(1).offset2)/msi.data(1).length/4; % intensity precision
end
if p1>2 || p2>2 || p1<1 || p2<1
    fprintf('Data precision error');
end


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
mz=fread(fid,msi.data(id_t).length,precision{p1});  %read desired length @double (8 bytes) 

%read intensity
if isfield(msi.data,'offset2')
    fseek(fid, msi.data(id_t).offset2,-1); 
else
    fseek(fid, msi.data(id_t).offset+msi.data(id_t).length*DBL,-1);
end

sig=fread(fid,msi.data(id_t).length,precision{p2});

spec(n).id=msi.data(id_t).id;
spec(n).x=x(n);
spec(n).y=y(n);
spec(n).peak_mz=single(mz);  % use single instead of double to reduce size
spec(n).peak_sig=single(sig);
end

