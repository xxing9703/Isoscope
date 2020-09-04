function varargout = gui_msview(varargin)
% GUI_MSVIEW MATLAB code for gui_msview.fig
%      GUI_MSVIEW, by itself, creates a new GUI_MSVIEW or raises the existing
%      singleton*.
%
%      H = GUI_MSVIEW returns the handle to a new GUI_MSVIEW or the handle to
%      the existing singleton*.
%
%      GUI_MSVIEW('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUI_MSVIEW.M with the given input arguments.
%
%      GUI_MSVIEW('Property','Value',...) creates a new GUI_MSVIEW or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before gui_msview_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to gui_msview_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help gui_msview

% Last Modified by GUIDE v2.5 14-Jun-2019 15:41:14

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @gui_msview_OpeningFcn, ...
                   'gui_OutputFcn',  @gui_msview_OutputFcn, ...
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


% --- Executes just before gui_msview is made visible.
function gui_msview_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to gui_msview (see VARARGIN)

% Choose default command line output for gui_msview
handles.output = hObject;
% O=load('mz_out.mat');
% ms.dt=O.mz_out;
ms.dt=varargin{1};
ms.x=ms.dt(:,1);
ms.y=ms.dt(:,2);
stem(handles.axes1,ms.x,ms.y,'.-');
%xlim([100,300])
set (gcf, 'WindowButtonMotionFcn', @mouseMove);
set (gcf, 'WindowButtonDownFcn', @mouseDone);
set(gcf,'toolbar','figure');
set(gcf,'menubar','figure');
ms.currentID=1;
ms.currentXY=[];
ms.current_pt=[];
ms.current_text=[];
ms.refID=[];
ms.refXY=[];
%ms.ref_pt=[];
ms.ref_text=[];
setappdata(handles.figure1,'ms',ms);

%zoom on
% Update handles structure
guidata(hObject, handles);

% UIWAIT makes gui_msview wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = gui_msview_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

function mouseMove (object, eventdata)
ms=getappdata(object,'ms');
ax=findobj(object,'type','axes');
C=get (ax, 'CurrentPoint');
[X,Y,B]=getCurrentXY(ms.dt,C);
title(ax, ['m/z=', num2str(X), ', sig=',num2str(Y,'%10.2e'), '']);  
ms.currentID=B;
ms.currentXY=[X,Y];
if ~isempty(ms.refID)
    delta_mz=ms.currentXY(1)-ms.refXY(1);
    signal_r=ms.currentXY(2)/ms.refXY(2);
    set(ms.current_pt,'visible','off');
    set(ms.current_text,'visible','off');
    hold(ax,'on')
    ms.current_pt=plot(ax,[ms.refXY(1),ms.currentXY(1)],[ms.refXY(2),ms.currentXY(2)]','--r');
    ms.current_text=text(ax,C(1,1),C(1,2),['\Deltam/z=',num2str(delta_mz), ', r=',num2str(signal_r,'%.2g')]);
else
    set(ms.current_text,'visible','off');
    ms.current_text=text(ax,C(1,1),C(1,2),'double click to select');
end
setappdata(object,'ms',ms);



function mouseDone(object, eventdata)
ms=getappdata(object,'ms');
ms.refID=ms.currentID;
ms.refXY=ms.currentXY;

a=get(object,'SelectionType');
 if strcmp(a,'open')       
    set(ms.ref_text,'visible','off');    
    ms.ref_text=text(gca,ms.refXY(1),ms.refXY(2)-2,['\leftarrow',num2str(ms.refXY(1))]);
    setappdata(object,'ms',ms);
 elseif strcmp(a,'extend')
     zoom on
 elseif strcmp(a,'alt')
     zoom off
 end


function [X,Y,B]=getCurrentXY(dt,C)
x=C(1,1);
y=C(1,2);
[~,B]=min(abs(dt(:,1)-x)+0.98*abs(log10(dt(:,2)/y)));
  X=dt(B,1);
  Y=dt(B,2);




% --- Executes on mouse press over figure background, over a disabled or
% --- inactive control, or over an axes background.
function figure1_WindowButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on key press with focus on figure1 or any of its controls.
function figure1_WindowKeyPressFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.FIGURE)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)
if strcmp(eventdata.Modifier{:},'shift')
     zoom;     
     hManager = uigetmodemanager(gcf);
     [hManager.WindowListenerHandles.Enabled] = deal(false);
     set(gcf, 'WindowKeyPressFcn', @figure1_WindowKeyPressFcn);
end



% --- Executes on key release with focus on figure1 or any of its controls.
function figure1_WindowKeyReleaseFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.FIGURE)
%	Key: name of the key that was released, in lower case
%	Character: character interpretation of the key(s) that was released
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) released
% handles    structure with handles and user data (see GUIDATA)
