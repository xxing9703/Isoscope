%convert roigrp 
function roigrp=roimapping(roigrp,R)

for i=1:length(roigrp)    
    [x,y] = transformPointsInverse(R.t, roigrp(i).plt.Position(:,1), roigrp(i).plt.Position(:,2));
    roigrp(i).plt.Position=[x,y]; %change plot XY positions
    [x,y] = transformPointsInverse(R.t,roigrp(i).edge(:,1),roigrp(i).edge(:,2));
    roigrp(i).edge=[x,y]; %change edge value
    roigrp(i).BW=imwarp(roigrp(i).BW,R.t_inv,'nearest','OutputView',R.ref_moving); %change BW
    roigrp(i).ref=R.ref_moving; %change ref
    roigrp(i).size=sum(sum(roigrp(i).BW)); %Change roi size
end