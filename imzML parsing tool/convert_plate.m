function convert_plate(handles)
%fname='20191017_NADTesting.xlsx';
[file,path]=uigetfile({'*.xlsx; *.csv'},'Load formated MALDI file only!!!','multiselect','on');
if isequal(file,0)
   disp('User selected Cancel');
    return
end
fname=fullfile(path,file);
msi.fname=fname;
msi.res=1000;  % signature for isoscope to know it is plate data and set padding=1
if length(fname)==1
    [~,sheets]=xlsfinfo(fname);
    flag=1; %single xlsx
else
    for i=1:length(fname)
      [~, sheets{i}, ~] = fileparts(fname{i});
    end
    flag=2; % multi csv;
end

alp='ABCDEFGHIJKLMNOPQRSTUVWXYZ';
ct=0;
fprintf('converting.....')
handles.text_status1.String='Converting...';
handles.text_status1.BackgroundColor=[1,0,0];
drawnow()
for i=1:length(sheets)
    i
   str=split( sheets{i} , {'_','-'} );
   if length(str)>1
    str=str{1};  %get the head string of each tab
    rowstr=upper(str(1));  %row index
    colstr=str(2:end); %col index
    row=strfind(alp,rowstr);
    col=str2num(colstr);
    if flag==1
        T=readtable(fname,'sheet',sheets{i});
    else
        T=readtable(fname{i});
    end
   if ~isempty(T)
    pks=table2struct(T);
    dataset{row,col}=pks;    
    ct=ct+1;
    msi.data(ct).id=ct;
%     msi.data(ct).x=row;
%     msi.data(ct).y=col;
     msi.data(ct).y=row; %flip x and y; --2021.2.15
     msi.data(ct).x=col;
     
    msi.data(ct).peak_mz=[pks.m_z];
    msi.data(ct).peak_sig=[pks.I];
    msi.data(ct).name=sheets{i};
   else
      ct=ct+1;
    msi.data(ct).id=ct;
    msi.data(ct).y=row; %flip x and y;
    msi.data(ct).x=col;     
    msi.data(ct).peak_mz=0;
    msi.data(ct).peak_sig=0;
    msi.data(ct).name=sheets{i}; 
   end
   end
end
fprintf('done\n');
handles.text_status1.String='Ready';
handles.text_status1.BackgroundColor=[0,1,0];
drawnow()
[file,path]=uiputfile('*.mat','Save file');
if isequal(file,0)
   disp('User selected Cancel');
    return
end
fout=fullfile(path,file);
save(fout,'msi');


