% added 6/6/2022, to update list tables in "error" and "1D intensity tabs"
function update_roigrp(handles)

 roigrp=getappdata(handles.figure1,'roigrp');
 handles.list2.String={roigrp.tag};
 handles.list2.Value=1;

 handles.list3.String={roigrp.tag};
 handles.list3.Value=1;