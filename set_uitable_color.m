%set uitable row color based on values [0-1] in column(idx)
function set_uitable_color(handles,dt,idx)
if idx==0
   for i=1:size(dt,1)
    handles.uitable1.BackgroundColor(i,:)=[1,1,1];  
   end
else
 for i=1:size(dt,1)
     cl=min(dt{i,idx},1);
   handles.uitable1.BackgroundColor(i,:)=[1,1,1-cl];
   if cl>0.99
       handles.uitable1.BackgroundColor(i,:)=[0,1,0];
   end
 end
end