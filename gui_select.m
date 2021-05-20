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

% Last Modified by GUIDE v2.5 04-May-2021 17:30:01

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
 pks=varargin{1}; %pks 
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
cellArray=[dt(ordering,:),col2];
set(handles.uitable1, 'Data', cellArray);
set(handles.uitable1, 'ColumnEditable', true(1,sz+1));
% Update handles structure
handles.pks=pks;
guidata(hObject, handles);

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
pkid=pks.pkid;
ordering=pks.ordering;
corref_new=pks.corref(ordering,ordering); %reordered corref
sz=size(dt,1);
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

dt(:,sz+1)=col_end;
set(handles.uitable1, 'Data', dt);
handles.text_num.String=num2str(length(selected));


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
select(handles);

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
select(handles);

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
handles.text_num.String=num2str(size(dt,1));
handles.uibuttongroup2.Visible='off';

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
handles.text_num.String='0';
handles.uibuttongroup2.Visible='off';

% --- Executes on button press in radiobutton3.
function bt_sim_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton3
handles.uibuttongroup2.Visible='on';
select(handles);

% --- Executes on button press in radiobutton4.
function radiobutton4_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton4
select(handles);

% --- Executes on button press in radiobutton5.
function radiobutton5_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton5
select(handles);


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
handles.text_num.String=N;
handles.uibuttongroup2.Visible='off';

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
handles.text_num.String=N;
handles.uibuttongroup2.Visible='off';


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
select(handles);