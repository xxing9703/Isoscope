function [O,xy]=msi_merge(fn)
 if iscell(fn)
    fname=fn;
 else
    fname{1}=fn; 
 end 
O.msi.fname=fname{1};
O.msi.data=[];

for i=1:length(fname)
    P=load(fname{i});    
    xy(i,:)=[min([P.msi.data.x]),...
             min([P.msi.data.y]),...
             max([P.msi.data.x])-min([P.msi.data.x])+1,...
             max([P.msi.data.y])-min([P.msi.data.y])+1];
      %[x_start,y_start, width, height]
    O.msi.data=[O.msi.data,P.msi.data];
    O.msi.res=P.msi.res;
end

