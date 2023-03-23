function varargout = gui_select(varargin)
% GUI_SELECT MATLAB code for gui_select.fig
%      GUI_SELECT, by itself, creates a new GUI_SELECT or raises the existing
%      singleton*.
%
%      H = GUI_SELECT returns the handle to a new GUI_SELECT or the handle to
%      the existing singleton*.
%
%      GUI_SELECT('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUI_SELECT.M with the given input arguments.
%
%      GUI_SELECT('Property','Value',...) creates a new GUI_SELECT or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before gui_select_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to gui_select_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help gui_select

% Last Modified by GUIDE v2.5 22-Mar-2023 22:10:02

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @gui_select_OpeningFcn, ...
                   'gui_OutputFcn',  @gui_select_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before gui_select is made visible.
function gui_select_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to gui_select (see VARARGIN)

% Choose default command line output for gui_select
handles.out = hObject;
if nargin>3
   setappdata(handles.figure1,'arg',varargin);
%    if isempty(varargin{2})
%        handles.bt_sim.Enable='off';
%    end
 h=varargin{1}; %pks 
 pks=getappdata(h.figure1,'pks');
 msi=getappdata(h.figure1,'msi');
 dt=pks.data;
 ordering=pks.ordering; 
 sz=size(dt,2);
 handles.uitable1.ColumnName=[pks.header,'select'];
else
 dt={'met1';'met2';'met3'};
 pks.data=dt;
 pks.ordering=[1,2,3];  
 sz=1;
 handles.uitable1.ColumnName={'name','select'};
end
set(handles.uitable1, 'ColumnFormat', [repmat({'char'},1,sz),'logical']);
selected=1;
col2=false(size(dt,1),1);
col2(selected)=1;
col2=num2cell(col2);
dt=[dt(ordering,:),col2];
set(handles.uitable1, 'Data', dt);
set_uitable_color(handles,dt,size(dt,2));
handles.uitable1.ColumnEditable(length(pks.header)+1)=true;
handles.text_total.String=num2str(size(dt,1));
% Update handles structure
handles.pks=pks;
handles.msi=msi;
R=msi.R;
S=msi.S;
str=[];ct=0;
for i=1:length(R)
    str=[str;['R(',num2str(i),')']];
    ct=ct+1;
    subID{ct}=R(i).subID;
end
for i=1:length(S)
    str=[str;['S(',num2str(i),')']];
    ct=ct+1;
    subID{ct}=S(i).subID;
end
handles.subID=subID;
handles.pop1.String=str;
handles.h=h;
guidata(hObject, handles);
eventdata.Indices=[1,2];
uitable1_CellSelectionCallback(hObject, eventdata, handles)
% UIWAIT makes gui_select wait for user response (see UIRESUME)
 uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = gui_select_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.pks;
delete(hObject);

function select(handles)
pks=handles.pks;
dt=handles.uitable1.Data;
%pkid=pks.pkid;
pkid=handles.pkid;
ordering=pks.ordering;
corref_new=pks.corref(ordering,ordering); %reordered corref
if handles.checkbox1.Value==0
    [A,B]=sort(corref_new(pkid,:),'descend'); %correlation
else
    [A,B]=sort(corref_new(pkid,:),'ascend');  %anti-correlation
end
c1=str2num(handles.edit1.String);  %top n
c1=min(c1,length(B));
handles.edit1.String=num2str(c1);

c2=str2num(handles.edit2.String);  %score cutoff

if handles.radiobutton4.Value
    selected=B(1:c1);    
elseif handles.radiobutton5.Value
    if handles.checkbox1.Value==0
       selected=B(A>c2);
    else
       selected=B(A<-c2);
    end
end
    
col_end=false(size(dt,1),1); %update last column checks
if ~isempty(selected)
 corref_new(pkid,selected)
 col_end(selected)=1;
end
col_end=num2cell(col_end);

dt(:,end)=col_end;
set(handles.uitable1, 'Data', dt);
handles.text_num.String=num2str(length(selected));
dt=handles.uitable1.Data;
set_uitable_color(handles,dt,size(dt,2));
handles.text_stat.String=[num2str(length(selected)),' qualifying peaks detected!'];


% --- Executes on button press in bt_OK.
function bt_OK_Callback(hObject, eventdata, handles)
% hObject    handle to bt_OK (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
ckecked=handles.uitable1.Data(:,end);
idx=[];
for i=1:size(ckecked,1)
    if ckecked{i,end}
        idx=[idx,i];
    end
end
pks=handles.pks;
pks.data=pks.data(pks.ordering(idx),:);
 T=cell2table(pks.data(:,1:3));
 T.Properties.VariableNames = {'Name','Formula','m_z'};
pks.sdata=table2struct(T);
pks.corref=pks.corref(pks.ordering(idx),pks.ordering(idx));
pks.ordering=1:size(pks.data,1); %update ordering

handles.pks=pks;
guidata(hObject, handles);
figure1_CloseRequestFcn(handles.figure1, eventdata, handles);

% --- Executes on button press in bt_cancel.
function bt_cancel_Callback(hObject, eventdata, handles)
% hObject    handle to bt_cancel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
figure1_CloseRequestFcn(handles.figure1, eventdata, handles);

% --- Executes when user attempts to close figure1.
function figure1_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: delete(hObject) closes the figure
uiresume(hObject);



function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents of edit1 as a double


% --- Executes during object creation, after setting all properties.
function edit1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit2_Callback(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit2 as text
%        str2double(get(hObject,'String')) returns contents of edit2 as a double


% --- Executes during object creation, after setting all properties.
function edit2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in radiobutton1.
function bt_all_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton1
dt=handles.uitable1.Data;
col2=true(size(dt,1),1);
col2=num2cell(col2);
dt(:,end)=col2;
set(handles.uitable1, 'Data', dt);
set_uitable_color(handles,dt,size(dt,2));
handles.text_num.String=num2str(size(dt,1));


% --- Executes on button press in radiobutton2.
function bt_none_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton2
dt=handles.uitable1.Data;
col2=false(size(dt,1),1);
col2=num2cell(col2);
dt(:,end)=col2;
set(handles.uitable1, 'Data', dt);
set_uitable_color(handles,dt,size(dt,2));
handles.text_num.String='0';


% --- Executes on button press in bt_reverse.
function bt_reverse_Callback(hObject, eventdata, handles)
% hObject    handle to bt_reverse (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
dt=handles.uitable1.Data;
selected=dt(:,end);
for i=1:length(selected)
    selected{i}=~selected{i};
end
dt(:,end)=selected;
set(handles.uitable1, 'Data', dt);
set_uitable_color(handles,dt,size(dt,2));
handles.text_num.String=num2str(sum(cell2mat(selected)));


% --- Executes on button press in radiobutton4.
function radiobutton4_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton4


% --- Executes on button press in radiobutton5.
function radiobutton5_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton5



% --- Executes when entered data in editable cell(s) in uitable1.
function uitable1_CellEditCallback(hObject, eventdata, handles)
% hObject    handle to uitable1 (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.CONTROL.TABLE)
%	Indices: row and column indices of the cell(s) edited
%	PreviousData: previous data for the cell(s) edited
%	EditData: string(s) entered by the user
%	NewData: EditData or its converted form set on the Data property. Empty if Data was not changed
%	Error: error string when failed to convert EditData to appropriate value for Data
% handles    structure with handles and user data (see GUIDATA)
dt=handles.uitable1.Data;
ct=sum(cell2mat(dt(:,end)));
handles.text_num.String=num2str(ct);
set_uitable_color(handles,dt,size(dt,2));


% --- Executes on button press in bt_top.
function bt_top_Callback(hObject, eventdata, handles)
% hObject    handle to bt_top (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
dt=handles.uitable1.Data;
col2=false(size(dt,1),1);
N=str2num(handles.edit_N.String);
 for i=1:N
     col2(i)=true;
 end
col2=num2cell(col2);
dt(:,end)=col2;

set(handles.uitable1, 'Data', dt);
set_uitable_color(handles,dt,size(dt,2));
handles.text_num.String=N;


% --- Executes on button press in bt_bottom.
function bt_bottom_Callback(hObject, eventdata, handles)
% hObject    handle to bt_bottom (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
dt=handles.uitable1.Data;
col2=false(size(dt,1),1);
N=str2num(handles.edit_N.String);
 for i=1:N
     col2(end-i+1:end)=true;
 end
col2=num2cell(col2);
dt(:,end)=col2;

set(handles.uitable1, 'Data', dt);
set_uitable_color(handles,dt,size(dt,2));
handles.text_num.String=N;


function edit_N_Callback(hObject, eventdata, handles)
% hObject    handle to edit_N (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_N as text
%        str2double(get(hObject,'String')) returns contents of edit_N as a double


% --- Executes during object creation, after setting all properties.
function edit_N_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_N (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in checkbox1.
function checkbox1_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox1



% --- Executes when selected cell(s) is changed in uitable1.
function uitable1_CellSelectionCallback(hObject, eventdata, handles)
% hObject    handle to uitable1 (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.CONTROL.TABLE)
%	Indices: row and column indices of the cell(s) currently selecteds
% handles    structure with handles and user data (see GUIDATA)
if ~isempty(eventdata.Indices)
id=eventdata.Indices(1);
handles.uitable1.UserData=id;
handles.text_id.String=num2str(id);
msi=handles.msi;
if isempty(msi.imax) 
    pk=Mzpk(handles.pks.sdata(id));
    pk.ppm=str2num(handles.h.edit_ppm.String);%ppm pass over
    pk.offset=str2num(handles.h.edit_offset.String);%offset pass over
    pk.z=handles.h.popup_z.Value-3; %z pass over
    pk.addType=handles.h.popup_addtype.Value;%addType pass over
    pk.isoType=handles.h.popup_isotype.Value; %isoType pass over   
    msi=msi_get_idata(msi,pk); % get idata from pk
else
  msi.idata=msi.imax(:,id);  %directly get idata from msi.imax
end
  msi=msi_update_imgdata(msi); % update to get 2d imgdata
  msi=msi_get_imgC(msi,handles.h);
  imshow(msi.imgC,'Parent',handles.axes1);
handles.pkid=id;
handles.msi=msi;
guidata(hObject, handles);
end


function filterline_Callback(hObject, eventdata, handles)
% hObject    handle to filterline (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of filterline as text
%        str2double(get(hObject,'String')) returns contents of filterline as a double


% --- Executes during object creation, after setting all properties.
function filterline_CreateFcn(hObject, eventdata, handles)
% hObject    handle to filterline (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in bt_filter.
function bt_filter_Callback(hObject, eventdata, handles)
% hObject    handle to bt_filter (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
msi=handles.msi;
R=msi.R;
S=msi.S;
id=[];
dt=handles.uitable1.Data;
if size(dt,1)~=length(R(1).c)
    warndlg('Please click cancel and run targeted analysis to update the intensity matrix first!','warning')
     return
end
filterline=handles.filterline.String;
try
  handles.text_stat.String='applying filters...' ;   
  id=eval(['find(', filterline,');']);
catch 
  handles.text_stat.String='Filterline error!';
  return
end
if isempty(id)   % no peaks found
   handles.text_stat.String='no peaks found!';   
else    
    ct=length(id);
    col2=false(size(dt,1),1);
    col2(id)=true;
    col2=num2cell(col2);
    dt(:,end)=col2;
   set(handles.uitable1, 'Data', dt);
   set_uitable_color(handles,dt,size(dt,2));
   handles.text_num.String=num2str(ct);
   handles.text_stat.String=[num2str(ct),' qualifying peaks detected!'];
    
    id_next=id(1);
    handles.text_id.String=id_next;
    ev.Indices=[id_next,1];
    uitable1_CellSelectionCallback(hObject, ev, handles)
end


% --- Executes on selection change in pop1.
function pop1_Callback(hObject, eventdata, handles)
% hObject    handle to pop1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns pop1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from pop1
subID=handles.subID{handles.pop1.Value};
msi=handles.msi;
meta=msi.metadata;
imgdata=zeros(max(meta(:,2))+10,max(meta(:,1))+10);

for i=1:length(subID)
    idx=subID(i);
    imgdata(meta(idx,2),meta(idx,1))=1;
end
imshow(msi.imgC,'Parent',handles.axes1);
hold(handles.axes1,'on')
f=imshow(imgdata,'parent',handles.axes1);
f.AlphaData = 0.4;


% --- Executes during object creation, after setting all properties.
function pop1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pop1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on key press with focus on uitable1 and none of its controls.
function uitable1_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to uitable1 (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.CONTROL.TABLE)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)
id=handles.uitable1.UserData;
dt=handles.uitable1.Data;
if strcmp(eventdata.Key,'g')
    dt{id,end}=true;
    handles.uitable1.Data{id,end}=true;
    ct=sum(cell2mat(dt(:,end)));
    handles.text_num.String=num2str(ct);
    set_uitable_color(handles,dt,size(dt,2));   
elseif strcmp(eventdata.Key,'b')
    dt{id,end}=false;
    handles.uitable1.Data{id,end}=false;
    ct=sum(cell2mat(dt(:,end)));
    handles.text_num.String=num2str(ct);
    set_uitable_color(handles,dt,size(dt,2));

end



% --- Executes on button press in bt_select.
function bt_select_Callback(hObject, eventdata, handles)
% hObject    handle to bt_select (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
select(handles);


% --- Executes on button press in pushbutton14.
function pushbutton14_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton14 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in bt_left.
function bt_right_Callback(hObject, eventdata, handles)
% hObject    handle to bt_left (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
idx=find(cell2mat(handles.uitable1.Data(:,end)));
id=str2num(handles.text_id.String);
tp=find((idx-id)>0);
if ~isempty(tp)
    id_next=idx(tp(1));
    handles.text_id.String=id_next;
    ev.Indices=[id_next,1];
    uitable1_CellSelectionCallback(hObject, ev, handles)
end


% --- Executes on button press in bt_right.
function bt_left_Callback(hObject, eventdata, handles)
% hObject    handle to bt_right (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
idx=find(cell2mat(handles.uitable1.Data(:,end)));
id=str2num(handles.text_id.String);
tp=find((idx-id)<0);
if ~isempty(tp)
    id_next=idx(tp(end));
    handles.text_id.String=id_next;
    ev.Indices=[id_next,1];
    uitable1_CellSelectionCallback(hObject, ev, handles)
end

