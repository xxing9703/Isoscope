function update_roitable(uitable,roigrp)
%dt=uitable.Data;
if isempty(roigrp)
    dt=[];
else
for i=1:length(roigrp)
   dt{i,1}=roigrp(i).tag;
   dt{i,2}=roigrp(i).pen;
   dt{i,3}=roigrp(i).size;
   dt{i,4}=roigrp(i).sig;
   dt{i,5}=roigrp(i).note;
   dt{i,6}='         [x]';
end
end
uitable.Data=dt;