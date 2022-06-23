function varargout = gui_overlay_master(varargin)
% GUI_OVERLAY_MASTER MATLAB code for gui_overlay_master.fig
%      GUI_OVERLAY_MASTER, by itself, creates a new GUI_OVERLAY_MASTER or raises the existing
%      singleton*.
%
%      H = GUI_OVERLAY_MASTER returns the handle to a new GUI_OVERLAY_MASTER or the handle to
%      the existing singleton*.
%
%      GUI_OVERLAY_MASTER('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUI_OVERLAY_MASTER.M with the given input arguments.
%
%      GUI_OVERLAY_MASTER('Property','Value',...) creates a new GUI_OVERLAY_MASTER or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before gui_overlay_master_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to gui_overlay_master_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help gui_overlay_master

% Last Modified by GUIDE v2.5 23-Jun-2022 12:56:55

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @gui_overlay_master_OpeningFcn, ...
                   'gui_OutputFcn',  @gui_overlay_master_OutputFcn, ...
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


% --- Executes just before gui_overlay_master is made visible.
function gui_overlay_master_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to gui_overlay_master (see VARARGIN)

% Choose default command line output for gui_overlay_master
handles.output = hObject;

 H = findobj(allchild(groot), 'flat', 'UserData', 2021111);
    if ~isempty(H)
        msi=getappdata(H,'msi');
        handles.msi=msi;
        handles.H=H;
        sz=size(msi.imgdata);
        img00=zeros(sz(1),sz(2));
        imshow(img00,'Parent',handles.axes_img1);
        imshow(img00,'Parent',handles.axes_img2);
        imshow(img00,'Parent',handles.axes_img3);
        handles.dt_red=img00;
        handles.dt_green=img00;
        handles.dt_blue=img00;
        handles.img00=img00;

    else 
        msgbox('IsoScope not open','Error');
        return
    end
% Update handles structure
guidata(hObject, handles);

% UIWAIT makes gui_overlay_master wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = gui_overlay_master_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in bt_red.
function bt_red_Callback(hObject, eventdata, handles)
% hObject    handle to bt_red (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
msi=getappdata(handles.H,'msi');
handles.name1.String=msi.pk.name;
dt=msi.imgdata;%img=zeros(size(dt,1),size(dt,2),3);
img=dt/max(max(dt))*1.5;
imshow(img,'Parent',handles.axes_img1);
cla(handles.axes_hist1);
histogram(handles.axes_hist1, msi.idata/max(msi.idata));
yl=ylim(handles.axes_hist1);
hold(handles.axes_hist1,'on');
handles.cl1a=plot(handles.axes_hist1,[handles.slider1a.Value,handles.slider1a.Value],[yl(1),yl(2)],'g-');
hold(handles.axes_hist1,'on');
handles.cl1=plot(handles.axes_hist1,[handles.slider1.Value,handles.slider1.Value],[yl(1),yl(2)],'r-');
handles.slider1.Enable='on';
handles.slider1a.Enable='on';
handles.dt_red=dt;
guidata(hObject, handles);
bt_preview_Callback(hObject, eventdata, handles);

% --- Executes on button press in bt_green.
function bt_green_Callback(hObject, eventdata, handles)
% hObject    handle to bt_green (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
msi=getappdata(handles.H,'msi');
handles.name2.String=msi.pk.name;
dt=msi.imgdata;% img=zeros(size(dt,1),size(dt,2),3);
img=dt/max(max(dt))*1.5;
imshow(img,'Parent',handles.axes_img2);
cla(handles.axes_hist2);
histogram(handles.axes_hist2, msi.idata/max(msi.idata));
yl=ylim(handles.axes_hist2);
hold(handles.axes_hist2,'on');
handles.cl2a=plot(handles.axes_hist2,[handles.slider2a.Value,handles.slider2a.Value],[yl(1),yl(2)],'g-');
hold(handles.axes_hist2,'on');
handles.cl2=plot(handles.axes_hist2,[handles.slider2.Value,handles.slider2.Value],[yl(1),yl(2)],'r-');
handles.slider2.Enable='on';
handles.slider2a.Enable='on';
handles.dt_green=dt;
guidata(hObject, handles);
bt_preview_Callback(hObject, eventdata, handles);
% --- Executes on button press in bt_blue.
function bt_blue_Callback(hObject, eventdata, handles)
% hObject    handle to bt_blue (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
msi=getappdata(handles.H,'msi');
handles.name3.String=msi.pk.name;
dt=msi.imgdata;%img=zeros(size(dt,1),size(dt,2),3);
img=dt/max(max(dt))*1.5;
imshow(img,'Parent',handles.axes_img3);
cla(handles.axes_hist3);
histogram(handles.axes_hist3, msi.idata/max(msi.idata));
yl=ylim(handles.axes_hist3);
hold(handles.axes_hist3,'on');
handles.cl3a=plot(handles.axes_hist3,[handles.slider3a.Value,handles.slider3a.Value],[yl(1),yl(2)],'g-');
hold(handles.axes_hist3,'on');
handles.cl3=plot(handles.axes_hist3,[handles.slider3.Value,handles.slider3.Value],[yl(1),yl(2)],'r-');
handles.slider3.Enable='on';
handles.slider3a.Enable='on';
handles.dt_blue=dt;
guidata(hObject, handles);
bt_preview_Callback(hObject, eventdata, handles);
% --- Executes on button press in bt_preview.
function bt_preview_Callback(hObject, eventdata, handles)
% hObject    handle to bt_preview (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
A=handles.dt_red;
B=handles.dt_green;
C=handles.dt_blue;

A=A/max(max(A));
B=B/max(max(B));
C=C/max(max(C));

clim1=handles.slider1.Value;
clim2=handles.slider2.Value;
clim3=handles.slider3.Value;
clim1a=handles.slider1a.Value;
clim2a=handles.slider2a.Value;
clim3a=handles.slider3a.Value;

A1=(A-clim1a)/(clim1-clim1a);
B1=(B-clim2a)/(clim2-clim2a);
C1=(C-clim3a)/(clim3-clim3a);

M(:,:,1)=A1;
M(:,:,2)=B1;
M(:,:,3)=C1;
all=[A1,B1,C1]; 
all=all(all>=0);
all=all(all<=1);
histogram(handles.axes_histall,all);
imshow(M,'Parent',handles.axes_preview)
handles.M=M;
guidata(hObject, handles);
if isfield(handles,'cl1')
    handles.cl1.XData=[clim1,clim1];
end
if isfield(handles,'cl1a')
    handles.cl1a.XData=[clim1a,clim1a];
end
if isfield(handles,'cl2')
    handles.cl2.XData=[clim2,clim2];
end
if isfield(handles,'cl2a')
    handles.cl2a.XData=[clim2a,clim2a];
end
if isfield(handles,'cl3')
    handles.cl3.XData=[clim3,clim3];
end
if isfield(handles,'cl3a')
    handles.cl3a.XData=[clim3a,clim3a];
end

% --- Executes on slider movement.
function slider1_Callback(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
bt_preview_Callback(hObject, eventdata, handles);

% --- Executes during object creation, after setting all properties.
function slider1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function slider2_Callback(hObject, eventdata, handles)
% hObject    handle to slider2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
bt_preview_Callback(hObject, eventdata, handles);

% --- Executes during object creation, after setting all properties.
function slider2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function slider3_Callback(hObject, eventdata, handles)
% hObject    handle to slider3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
bt_preview_Callback(hObject, eventdata, handles);

% --- Executes during object creation, after setting all properties.
function slider3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on button press in bt_clear1.
function bt_clear1_Callback(hObject, eventdata, handles)
% hObject    handle to bt_clear1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.name1.String='';
imshow(handles.img00,'Parent',handles.axes_img1);
handles.dt_red=handles.img00;
guidata(hObject, handles);
bt_preview_Callback(hObject, eventdata, handles);
handles.slider1.Enable='off';
handles.slider1a.Enable='off';
cla(handles.axes_hist1);
handles=rmfield(handles,'cl1');
handles=rmfield(handles,'cl1a');
guidata(hObject, handles);
% --- Executes on button press in bt_clear2.
function bt_clear2_Callback(hObject, eventdata, handles)
% hObject    handle to bt_clear2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.name2.String='';
imshow(handles.img00,'Parent',handles.axes_img2);
handles.dt_green=handles.img00;
guidata(hObject, handles);
bt_preview_Callback(hObject, eventdata, handles);
handles.slider2.Enable='off';
handles.slider2a.Enable='off';
cla(handles.axes_hist2);
handles=rmfield(handles,'cl2');
handles=rmfield(handles,'cl2a');
guidata(hObject, handles);
% --- Executes on button press in bt_clear3.
function bt_clear3_Callback(hObject, eventdata, handles)
% hObject    handle to bt_clear3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.name3.String='';
imshow(handles.img00,'Parent',handles.axes_img3);
handles.dt_blue=handles.img00;
guidata(hObject, handles);
bt_preview_Callback(hObject, eventdata, handles);
handles.slider3.Enable='off';
handles.slider3a.Enable='off';
cla(handles.axes_hist3);
handles=rmfield(handles,'cl3');
handles=rmfield(handles,'cl3a');
guidata(hObject, handles);
% --- Executes on slider movement.
function slider1a_Callback(hObject, eventdata, handles)
% hObject    handle to slider1a (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
bt_preview_Callback(hObject, eventdata, handles);

% --- Executes during object creation, after setting all properties.
function slider1a_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider1a (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function slider2a_Callback(hObject, eventdata, handles)
% hObject    handle to slider2a (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
bt_preview_Callback(hObject, eventdata, handles);

% --- Executes during object creation, after setting all properties.
function slider2a_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider2a (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function slider3a_Callback(hObject, eventdata, handles)
% hObject    handle to slider3a (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
bt_preview_Callback(hObject, eventdata, handles);

% --- Executes during object creation, after setting all properties.
function slider3a_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider3a (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on button press in bt_plot.
function bt_plot_Callback(hObject, eventdata, handles)
% hObject    handle to bt_plot (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
figure
imshow(handles.M);
