function varargout = gui_convert(varargin)
%gui_convert MATLAB code file for gui_convert.fig
%      gui_convert, by itself, creates a new gui_convert or raises the existing
%      singleton*.
%
%      H = gui_convert returns the handle to a new gui_convert or the handle to
%      the existing singleton*.
%
%      gui_convert('Property','Value',...) creates a new gui_convert using the
%      given property value pairs. Unrecognized properties are passed via
%      varargin to gui_convert_OpeningFcn.  This calling syntax produces a
%      warning when there is an existing singleton*.
%
%      gui_convert('CALLBACK') and gui_convert('CALLBACK',hObject,...) call the
%      local function named CALLBACK in gui_convert.M with the given input
%      arguments.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help gui_convert

% Last Modified by GUIDE v2.5 13-Sep-2020 11:12:09

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @gui_convert_OpeningFcn, ...
                   'gui_OutputFcn',  @gui_convert_OutputFcn, ...
                   'gui_LayoutFcn',  [], ...
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


% --- Executes just before gui_convert is made visible.
function gui_convert_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   unrecognized PropertyName/PropertyValue pairs from the
%            command line (see VARARGIN)

% Choose default command line output for gui_convert
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes gui_convert wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = gui_convert_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;
%delete(hObject)



function edit_cutoff_Callback(hObject, eventdata, handles)
% hObject    handle to edit_cutoff (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_cutoff as text
%        str2double(get(hObject,'String')) returns contents of edit_cutoff as a double


% --- Executes during object creation, after setting all properties.
function edit_cutoff_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_cutoff (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[file,path]=uigetfile({'*.imzML;*.ibd'},'Select .imzML or .ibd file');
if isequal(file,0)
   disp('User selected Cancel');
else
    fname=fullfile(path,file);
    handles.text1.String=fname;
    handles.bt_convert.Enable='on';
    handles.bt_preview.Enable='off';
    handles.bt_parse.Enable='on';
    handles.text_pixel.String='0';
    handles.text_point.String='0';
    
end


% --- Executes on button press in bt_convert.
function bt_convert_Callback(hObject, eventdata, handles)
% hObject    handle to bt_convert (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
answer = questdlg('  Is your data centroid or profile?  If not sure, preview first', ...
	'Please confirm your data type', ...
	'centroid & keep it','profile & convert to centroid','Not sure','Not sure');
% Handle response
switch answer
    case 'centroid & keep it'
        handles.checkbox1.Value=0;
    case 'profile & convert to centroid'
        handles.checkbox1.Value=1;
    case 'Not sure'
        return
end

fname=handles.text1.String;
if ~isempty(fname)
option.peakwidth=1e-4;
option.threshold=str2num(handles.edit_cutoff.String);
option.profile=handles.checkbox1.Value;
handles.text_status.String='In process...';
handles.text_status.BackgroundColor='r';
drawnow();

norm=handles.popup_norm.Value;
if strcmp(handles.bt_preview.Enable,'off')
  msi=msi_process(fname,option,norm);
else
  msi=msi_process(handles.msi,option,norm); %bypass parse
end

[filepath,name,~] = fileparts(fname);
fmsi=fullfile(filepath,[name,'.mat']);
handles.text_status.String='Saving to disk...';
drawnow();
save(fmsi,'msi','-v7.3');
handles.text_status.String='Ready';
handles.text_status.BackgroundColor='g';
handles.output=fmsi;
guidata(hObject, handles);
else
    msgbox('No files selected');
end


% --- Executes on button press in bt_parse.
function bt_parse_Callback(hObject, eventdata, handles)
% hObject    handle to bt_parse (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
fname=handles.text1.String;
[path,name] = fileparts(fname);
if ~isempty(fname)
  f1=fullfile(path,[name '.imzML']);
  f2=fullfile(path,[name '.ibd']); 
  
  handles.text_status.String='parsing...';
  handles.text_status.BackgroundColor='r';
  drawnow();
  
  msi=parse_imzML(f1); %modified 10/6/2021
  
  handles.text_status.String='Ready';
  handles.text_status.BackgroundColor='g';
  drawnow();
 handles.text_pixel.String=num2str(length(msi.data));
 handles.msi=msi;
 handles.f2=f2;
 handles.bt_preview.Enable='on';
 guidata(hObject, handles);
end

% --- Executes on button press in bt_preview.
function bt_preview_Callback(hObject, eventdata, handles)
% hObject    handle to bt_preview (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
fid=fopen(handles.f2);
msi=handles.msi;
id=str2num(handles.edit_id.String);
spec=read_ims(fid,msi,id);
option.peakwidth=0.0001;
option.threshold=str2num(handles.edit_cutoff.String);
option.profile=handles.checkbox1.Value;

norm=handles.popup_norm.Value;
handles.text_top.String=num2str(max(spec.peak_sig),2);
handles.text_mean.String=num2str(mean(spec.peak_sig),2);
% find noise level
   tp=sort(spec.peak_sig);
   tp=mean(tp(1:floor(0.8*length(spec.peak_sig)))); %80%
handles.text_noise.String=num2str(tp,2);


spec=spec_norm(spec,norm);

stick=spec2stick(spec,option);

handles.text_point.String=num2str(length(spec.peak_sig));



if handles.checkbox1.Value   %show stickplot
  plot(handles.axes1,spec.peak_mz,spec.peak_sig,'.-b');
  hold on
  stem(handles.axes1,stick.peak_mz,-stick.peak_sig,'.r');
  handles.text_peaks.String=num2str(length(stick.peak_sig));
else
  stem(handles.axes1,spec.peak_mz,spec.peak_sig,'.-b');
  handles.text_peaks.String=num2str(length(spec.peak_sig));
end
hold off

mz=str2num(handles.edit_mz.String);
mzwindow=str2num(handles.edit_mzwindow.String);
if mzwindow>0
 xlim([mz-mzwindow,mz+mzwindow]);
end
zoom on

% --- Executes on button press in bt_peakpicking.
function bt_peakpicking_Callback(hObject, eventdata, handles)
% hObject    handle to bt_peakpicking (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on selection change in popup_norm.
function popup_norm_Callback(hObject, eventdata, handles)
% hObject    handle to popup_norm (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popup_norm contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popup_norm
bt_preview_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function popup_norm_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popup_norm (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_id_Callback(hObject, eventdata, handles)
% hObject    handle to edit_id (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_id as text
%        str2double(get(hObject,'String')) returns contents of edit_id as a double
bt_preview_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function edit_id_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_id (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_mz_Callback(hObject, eventdata, handles)
% hObject    handle to edit_mz (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_mz as text
%        str2double(get(hObject,'String')) returns contents of edit_mz as a double
bt_preview_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function edit_mz_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_mz (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_mzwindow_Callback(hObject, eventdata, handles)
% hObject    handle to edit_mzwindow (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_mzwindow as text
%        str2double(get(hObject,'String')) returns contents of edit_mzwindow as a double
bt_preview_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function edit_mzwindow_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_mzwindow (see GCBO)
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
if strcmp(handles.bt_preview.Enable,'on')
 bt_preview_Callback(hObject, eventdata, handles)
end
