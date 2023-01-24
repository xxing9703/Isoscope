isoType=1;  % 13C
ppm=5;
z=-1;

%% ---------------------------------
msi=getappdata(handles.figure1, 'msi');
pks=getappdata(handles.figure1, 'pks');
pks=pks.sdata;
roigrp=getappdata(handles.figure1, 'roigrp');
matrix=[];
header=[];
for j=1:length(roigrp)   
    tp=roigrp(j).BW.*msi.imgScanIDdata; % idata(index) subset
    ids=tp(:); 
    ids=ids(ids>0);
    subid{j}=ids;
    matrix_roi{j}=[];  
end
for i=1:length(pks)
    mypk=Mzpk(pks(i));
    mypk.ppm=ppm;
    mypk.isoType=isoType;
    mypk.z=z;

    ct=mypk.maxM_;
    strs=cellstr(num2str([0:ct]',[mypk.name,'_M','%02d']));
    header=[header;strs];
    msi=msi_get_isoidata(msi,mypk);
    matrix=[matrix, msi.isoidata.idata];

      for j=1:length(roigrp)           
         matrix_roi{j}=[matrix_roi{j},msi.isoidata.idata(subid{j},:)];         
      end    
end

%% ---------------
header=['X','Y',header'];
meta=msi.metadata;
filename='test2.xlsx';
T0=cell2table(header);
T=cell2table(num2cell([meta,matrix]));
writetable(T0,filename,'sheet','main','WriteVariableNames',false);
writetable(T,filename,'sheet','main','WriteVariableNames',false,'WriteMode','Append');
for i=1:length(matrix_roi)
    T=cell2table(num2cell([meta(subid{i},:),matrix_roi{i}]));
    writetable(T0,filename,'sheet',roigrp(i).tag,'WriteVariableNames',false);
    writetable(T,filename,'sheet',roigrp(i).tag,'WriteVariableNames',false,'WriteMode','Append');
end




