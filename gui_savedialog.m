function varargout = gui_savedialog(varargin)
% GUI_SAVEDIALOG MATLAB code for gui_savedialog.fig
%      GUI_SAVEDIALOG, by itself, creates a new GUI_SAVEDIALOG or raises the existing
%      singleton*.
%
%      H = GUI_SAVEDIALOG returns the handle to a new GUI_SAVEDIALOG or the handle to
%      the existing singleton*.
%
%      GUI_SAVEDIALOG('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUI_SAVEDIALOG.M with the given input arguments.
%
%      GUI_SAVEDIALOG('Property','Value',...) creates a new GUI_SAVEDIALOG or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before gui_savedialog_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to gui_savedialog_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help gui_savedialog

% Last Modified by GUIDE v2.5 21-Apr-2020 23:32:01

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @gui_savedialog_OpeningFcn, ...
                   'gui_OutputFcn',  @gui_savedialog_OutputFcn, ...
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


% --- Executes just before gui_savedialog is made visible.
function gui_savedialog_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to gui_savedialog (see VARARGIN)

% Choose default command line output for gui_savedialog
handles.output = hObject;
handles.msi=varargin{1};

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes gui_savedialog wait for user response (see UIRESUME)
 uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = gui_savedialog_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;
delete(hObject);


% --- Executes on button press in bt_OK.
function bt_OK_Callback(hObject, eventdata, handles)
% hObject    handle to bt_OK (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if handles.radiobutton1.Value 
    dt=handles.msi.idata;
    if ~isempty(handles.msi.isoidata)
        dt=handles.msi.isoidata.idata;
    end
elseif handles.radiobutton2.Value
    dt=handles.msi.imgdata;
elseif handles.radiobutton3.Value
    dt=handles.msi.errdata;
    if ~isempty(handles.msi.isoidata)    
        dt=msi.isoidata.idata_err;
    end
elseif handles.radiobutton4.Value
    dt=handles.msi.wdata;
elseif handles.radiobutton5.Value
   [filename,filepath]=uiputfile({'*.png';'*.jpg';'*.tif'},'Save image');
   fname=fullfile(filepath,filename);
   if isequal(filename,0)
     disp('User selected Cancel');
   else         
      imwrite(handles.msi.imgC,fname);   
      %imwrite(handles.msi.imgdata,fname);       
   end
   figure1_CloseRequestFcn(handles.figure1, eventdata, handles);
   return
end
[filename,filepath]=uiputfile({'*.xlsx';'*.csv';'*.txt'},'Save as');
file=fullfile(filepath,filename);
if isequal(file,0)
   disp('User selected Cancel');
else
   writetable(table(dt),file,'WriteVariableNames', 0)
   figure1_CloseRequestFcn(handles.figure1, eventdata, handles);
end


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
