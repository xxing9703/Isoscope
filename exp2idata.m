%translate user defined expression to code and get calculated idata
%for example (p1m2+p2)/p3 is translated into
%(p(handles,1,2)+p(handles,2))/p(handles,3)
%p is function that takes peak# (p) and M# (m) as 2nd and 3rd parameters
%if 3rd parameter is not specified, m=0 by default
function idata=exp2idata(exp,handles)
% msi=getappdata(handles.figure1,'msi');
% pks=getappdata(handles.figure1,'pks');
%exp='(p1m2+p2+p3)/(p4+p5+p6)';
try
ss=strsplit(exp,{'+','-','/'});
for i=1:length(ss)
    if isempty(strfind(ss{i},'p')) %no p
        
    elseif isempty(strfind(ss{i},'m')) %no m
      tp=strsplit(ss{i},'p');
      new=strrep(ss{i},tp{2},['(',tp{2},')']);
      exp=strrep(exp,ss{i},new);
    else
      tp=strsplit(ss{i},{'p','m'}); 
      new=strrep(ss{i},[tp{2},'m',tp{3}],['(',tp{2},',',tp{3},')']);
      exp=strrep(exp,ss{i},new);
    end    
end
exp=strrep(exp,'p(','p_idata(handles,');
exp=strrep(exp,'/','./');

 idata=eval(exp);
catch
  idata=[];
 
end
% msi=msi_update_imgdata(msi);
% handles.imobj.CData=msi.imgdata;
% setappdata(handles.figure1,'msi',msi);
% update_clim(hObject, eventdata, handles);

end

function out=p_idata(handles,p,m)
if nargin<3
    m=0;
end
msi=getappdata(handles.figure1,'msi');
pks=getappdata(handles.figure1,'pks');
pk=Mzpk(pks.sdata(p));
pk.M=m;

pk.ppm=str2num(handles.edit_ppm.String);%ppm pass over
pk.offset=str2num(handles.edit_offset.String);%offset pass over
pk.z=handles.popup_z.Value-3; %z pass over
pk.addType=handles.popup_addtype.Value;%addType pass over
pk.isoType=handles.popup_isotype.Value; %isoType pass over

[~,out]=msi_get_idata(msi,pk);
end


