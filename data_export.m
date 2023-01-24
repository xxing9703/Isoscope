function data_export(handles,filename,batch,roi,iso,corr)
% handles to isoscope, need to set z, isotype, ppm in gui
% batch=0 (current mz only) or 1 (do batch)
% roi=0 (no roi breakdown) or 1 (roi breakdown saved as separate sheets)
% iso=0 (pks only, corr does not apply) or 1 (include all isotopes, need to know formula)
% corr=0 (no iso-correction) or 1(correction, original), or 2 (correction, normalized)
if isfile(filename)
    fprintf('file already exist!\n')
    return
end
msi=getappdata(handles.figure1, 'msi');
pks=getappdata(handles.figure1, 'pks');
pks=pks.sdata;
pk=msi.pk;
if batch==1
  for i=1:length(pks)
    mypks(i)=Mzpk(pks(i));
    mypks(i).ppm=pk.ppm;
    mypks(i).isoType=pk.isoType;
    mypks(i).z=pk.z;
  end
else
    mypks=pk;
end
ty={'13C','15N','2H','13C15N'};
TT={'ppm',num2str(mypks(1).ppm);'isoType',ty{mypks(1).isoType};...
    'ionMode',num2str(mypks(1).z);'num pks',num2str(length(mypks));...
    'isocorr',num2str(corr)};
if corr==0
    field='idata';
elseif corr==1
    field='idata_cor_original';
elseif corr==2
    field='idata_cor';
end
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

if iso==0
   for i=1:length(mypks)
        mypk=mypks(i);        
        header=[header;cellstr(mypk.name)];
        msi=msi_get_idata(msi,mypk);
        matrix=[matrix, msi.idata];    matrix(isnan(matrix))=0;
          for j=1:length(roigrp)           
             matrix_roi{j}=[matrix_roi{j},msi.idata(subid{j})];         
          end    
    end  
else
    for i=1:length(mypks)
        mypk=mypks(i);
        ct=mypk.maxM_;
        strs=cellstr(num2str([0:ct]',[mypk.name,'_M','%02d']));
        header=[header;strs];
        msi=msi_get_isoidata(msi,mypk);
        matrix=[matrix, msi.isoidata.(field)];    matrix(isnan(matrix))=0;
          for j=1:length(roigrp)           
             matrix_roi{j}=[matrix_roi{j},msi.isoidata.(field)(subid{j},:)];         
          end    
    end
end

header=['ID','X','Y',header'];
meta=msi.metadata;
ID=1:size(meta,1);
meta=[ID',meta];
%filename='test2.xlsx';
T0=cell2table(header);
T=cell2table(num2cell([meta,matrix]));

writetable(T0,filename,'sheet','main','WriteVariableNames',false);
writetable(T,filename,'sheet','main','WriteVariableNames',false,'WriteMode','Append');
writecell(TT,filename,'sheet','parameters');
if roi==1 % extra sheet showing ROI breakdown
 for i=1:length(matrix_roi)
    T=cell2table(num2cell([meta(subid{i},:),matrix_roi{i}]));
    writetable(T0,filename,'sheet',roigrp(i).tag,'WriteVariableNames',false);
    writetable(T,filename,'sheet',roigrp(i).tag,'WriteVariableNames',false,'WriteMode','Append');
 end
end




