%set uitable row color based on values [0-1] in column(idx)
function set_uitable_color(handles,dt,idx)
if idx==0
   for i=1:size(dt,1)
    handles.uitable1.BackgroundColor(i,:)=[1,1,1];  
   end
elseif idx<=size(dt,2)
%  for i=1:size(dt,1)
%    cl=min(dt{i,idx},1);
%    tic
%    handles.uitable1.BackgroundColor(i,:)=[1,1,1-cl];
%    toc
%    if cl>0.99
%        handles.uitable1.BackgroundColor(i,:)=[0,1,0];
%    end
%  end
 cl=ones(size(dt,1),3);
 for i=1:size(dt,1)
   tp=1-min(dt{i,idx},1);   
   cl(i,3)=tp;
   if tp<0.01
   cl(i,:)=[0,1,0];
   end   
 end   
   handles.uitable1.BackgroundColor=cl;
end
end