function pks=msi_loadpks(handles,fname)
[~,~,B]=xlsread(fname);
header=B(1,1:end);
dt=B(2:end,:);

set(handles.uitable1,'ColumnName',header);
set(handles.uitable1,'data',dt);

set(handles.popup_sort,'String',['none',header]);
set(handles.popup_sort,'Value',1);

T=readtable(fname);
S=table2struct(T);
pks.header=header;
pks.data=dt;
pks.sdata=S; %structure data
pks.pkid=1;
pks.ordering=1:size(T,1);
pks.corref=zeros(size(dt,1),size(dt,1));
pks.filename=fname;




% set(handles.popup_sort,'String',['none',header]);
% set(handles.popup_sort,'Value',1);
% set(handles.uipanel2,'Title',['#pks : ',num2str(size(dt,1))]);

% pks.header=header;
% pks.data=dt;
% pks.ordering=1:size(dt,1);
% pks.pkid=currentID;
% pks.corref=zeros(size(dt,1),size(dt,1));

% setappdata(handles.figure1,'pks',dt);
% setappdata(handles.figure1,'ordering',1:size(dt,1));
% setappdata(handles.figure1,'pkid',currentID);

