function varargout = gui_colorselection(varargin)
% GUI_COLORSELECTION MATLAB code for gui_colorselection.fig
%      GUI_COLORSELECTION, by itself, creates a new GUI_COLORSELECTION or raises the existing
%      singleton*.
%
%      H = GUI_COLORSELECTION returns the handle to a new GUI_COLORSELECTION or the handle to
%      the existing singleton*.
%
%      GUI_COLORSELECTION('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUI_COLORSELECTION.M with the given input arguments.
%
%      GUI_COLORSELECTION('Property','Value',...) creates a new GUI_COLORSELECTION or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before gui_colorselection_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to gui_colorselection_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help gui_colorselection

% Last Modified by GUIDE v2.5 22-Nov-2019 16:35:39

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @gui_colorselection_OpeningFcn, ...
                   'gui_OutputFcn',  @gui_colorselection_OutputFcn, ...
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


% --- Executes just before gui_colorselection is made visible.
function gui_colorselection_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to gui_colorselection (see VARARGIN)

% Choose default command line output for gui_colorselection
handles.output = hObject;
c=[0,0,0;0,0,1;0,1,1;0,1,0;1,1,0;1,0,0;1,0,1;1,1,1];
rainbow=c2cmap(c);
c=[0,0,0;1,0,0];
red_blk=c2cmap(c);
c=[0,0,0;0,1,0];
green_blk=c2cmap(c);
c=[0,0,0;0,0,1];
blue_blk=c2cmap(c);
c=[0,0,1;0,1,0;1,1,0;1,0,0];
r_y_g_b=c2cmap(c);

df_colormap={'rainbow','parula','r_y_g_b','red_blk','green_blk','blue_blk','jet','hsv','hot','cool','spring','summer','autumn','winter','gray','bone','copper'};

sz=0.05;
for i=1:length(df_colormap)
ax{i} = axes('Position',[0.05 0.05+i*sz 0.7 0],'parent',handles.uibtgrp);
rb{i} = uicontrol('Style', 'radiobutton','string',df_colormap{i},...
    'parent',handles.uibtgrp,...
    'Units', 'Normalized', 'Position',[0.8,0.05+i*sz,0.15,sz],...
    'Callback',@(hObject,eventdata)gui_colorselection('ratiobutton_Callback',hObject,eventdata,guidata(hObject))); 


set(ax{i},'Visible','off')
c=eval(df_colormap{i});
rb{i}.UserData=c;
colormap(ax{i},c);
 colorbar(ax{i},'Northoutside','ticks',[],'ticklabels',[])
end
colormap(handles.axes1,rainbow);
colorbar(handles.axes1)


% Update handles structure
guidata(hObject, handles);

% UIWAIT makes gui_colorselection wait for user response (see UIRESUME)
 uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = gui_colorselection_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
c=colormap(handles.axes1);
varargout{1} = c;
delete(handles.figure1)


function ratiobutton_Callback(hObject,eventdata,handles)

c=hObject.UserData;
colormap(handles.axes1,c);



% --- Executes on button press in bt_customize.
function bt_customize_Callback(hObject, eventdata, handles)
% hObject    handle to bt_customize (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
colormapeditor
colormap(handles.axes1,colormap(gca));

% --- Executes on button press in bt_OK.
function bt_OK_Callback(hObject, eventdata, handles)
% hObject    handle to bt_OK (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
figure1_CloseRequestFcn(handles.figure1, eventdata, handles)

% --- Executes when user attempts to close figure1.
function figure1_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: delete(hObject) closes the figure
uiresume(hObject);
%delete(hObject);
