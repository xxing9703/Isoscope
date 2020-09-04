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

% Last Modified by GUIDE v2.5 25-Oct-2019 10:08:59

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
    handles.pushbutton2.Enable='on';
end


% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
fname=handles.text1.String;
if ~isempty(fname)
option.peakwidth=1e-4;
option.threshold=str2num(handles.edit1.String);
handles.pushbutton2.String='In process...';

drawnow();
msi=msi_process(fname,option);
[filepath,name,~] = fileparts(fname);
fmsi=fullfile(filepath,[name,'.mat']);
handles.pushbutton2.String='Saving to disk...';
save(fmsi,'msi','-v7.3');
handles.pushbutton2.String='covert';
handles.output=fmsi;
guidata(hObject, handles);
else
    msgbox('No files selected');
end
