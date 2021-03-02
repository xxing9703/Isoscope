function varargout = gui_rroi(varargin)
% GUI_RROI MATLAB code for gui_rroi.fig
%      GUI_RROI, by itself, creates a new GUI_RROI or raises the existing
%      singleton*.
%
%      H = GUI_RROI returns the handle to a new GUI_RROI or the handle to
%      the existing singleton*.
%
%      GUI_RROI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUI_RROI.M with the given input arguments.
%
%      GUI_RROI('Property','Value',...) creates a new GUI_RROI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before gui_rroi_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to gui_rroi_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help gui_rroi

% Last Modified by GUIDE v2.5 02-Mar-2021 16:08:31

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @gui_rroi_OpeningFcn, ...
                   'gui_OutputFcn',  @gui_rroi_OutputFcn, ...
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


% --- Executes just before gui_rroi is made visible.
function gui_rroi_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to gui_rroi (see VARARGIN)

% Choose default command line output for gui_rroi
handles.output = hObject;
handles.roigrp=[];
handles.R=[];
% Update handles structure
guidata(hObject, handles);

% UIWAIT makes gui_rroi wait for user response (see UIRESUME)
% uiwait(handles.figure_rroi);


% --- Outputs from this function are returned to the command line.
function varargout = gui_rroi_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in bt_loadfixed.
function bt_loadfixed_Callback(hObject, eventdata, handles)
% hObject    handle to bt_loadfixed (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[filename,filepath]=uigetfile('*.png;*.jpg;*.tif','Load fixed image');
fname=fullfile(filepath,filename);
if isequal(fname,0)
   disp('User selected Cancel');
else   
    img_fixed=imread(fname);   % HE data
    imshow(img_fixed,'parent',handles.ax1)
    f=figure;
    f.Position(1)=10;f.Position(2)
    set(f,'tag','rroi');
    handles.axes1=axes;
    I1=imshow(img_fixed,'parent',handles.axes1);
    sz=size(I1.CData);
    handles.text_sz1.String=[num2str(sz(1)),' X ', num2str(sz(2))];
    handles.slider1.Enable='on';
    handles.bt_loadmoving1.Enable='on';
    handles.uipanel2.Visible='on';
    handles.uipanel_guide.Visible='on';
    %handles.img_fixed=img_fixed;
    handles.I1=I1;
    handles.f=f;
    handles.bt_savegif.Enable='on';
    guidata(hObject, handles);
    
end

% --- Executes on button press in bt_loadmoving1.
function bt_loadmoving1_Callback(hObject, eventdata, handles)
% hObject    handle to bt_loadmoving1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
c=questdlg('Please select image source.','question','From file','IsoScope','Cancel','From file');
if strcmp(c,'From file')
 [filename,filepath]=uigetfile('*.png;*.jpg;*.tif','Load moving image');
 fname=fullfile(filepath,filename);
 if isequal(fname,0)
   disp('User selected Cancel');
 else   
    moving=imread(fname);   % moving  
 end
elseif strcmp(c,'IsoScope')
    H = findobj(allchild(groot), 'flat', 'UserData', 2021111);
    if ~isempty(H)
        msi=getappdata(H,'msi');
        handles.msi=msi;
        moving=msi.imgC;
    else 
        msgbox('IsoScope not open','Error');
        return
    end
else
    return
end
    sz=size(moving);
    handles.text_sz2.String=[num2str(sz(1)),' X ', num2str(sz(2))];
    imshow(moving,'parent',handles.ax2)
    fixed=handles.I1.CData;
    type=handles.popup_type1.String{handles.popup_type1.Value};
    if ~isempty(handles.R)
     answer = questdlg('Use the previous Registration?','question','Yes','No,create new','No,create new');
     switch answer
        case 'Yes'
          regR=handles.R;
          movingR = imwarp(moving,regR.t,'nearest','OutputView',regR.ref_fixed);
          err=regR.err;
        case 'No,create new'
          [movingR,regR]=cp_reg(moving,fixed,type);
          err=regR.err;
     end        
    else
        [movingR,regR]=cp_reg(moving,fixed,type);
        err=regR.err;
    end
    %handles.text_sz2.String=['err=',num2str(err,3)];
    if isfield(handles,'I2')
        I2=handles.I2;
        I2.CData=movingR;
    else
        I2 = imagesc(handles.axes1,'CData',movingR);
    end
    
    I2.AlphaData=0.5;
    handles.slider2.Enable='on';
    handles.slider2.Value=0.5;
    
    handles.bt_loadmoving2.Enable='on';
    handles.R=regR;
    handles.I2=I2;
    figure(handles.f)
    guidata(hObject, handles);

% --- Executes on button press in bt_loadmoving2.
function bt_loadmoving2_Callback(hObject, eventdata, handles)
% hObject    handle to bt_loadmoving2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
c=questdlg('Please select image source.','question','From file','IsoScope','Cancel','From file');
if strcmp(c,'From file')
 [filename,filepath]=uigetfile('*.png;*.jpg;*.tif','Load moving image');
 fname=fullfile(filepath,filename);
 if isequal(fname,0)
   disp('User selected Cancel');
 else   
    moving=imread(fname);   % moving
 end
elseif strcmp(c,'IsoScope')
    H = findobj(allchild(groot), 'flat', 'UserData', 2021111);
    if ~isempty(H)
        msi=getappdata(H,'msi');
        handles.msi=msi;
        moving=msi.imgC;
    else 
        msgbox('IsoScope not open','Error');
        return
    end
else
    return
end
    sz=size(moving);
    handles.text_sz3.String=[num2str(sz(1)),' X ', num2str(sz(2))];
    imshow(moving,'parent',handles.ax3)
    fixed=handles.I2.CData;
    type=handles.popup_type2.String{handles.popup_type2.Value};
%     [movingR,regR]=cp_reg(moving,fixed,type);
%     I3 = imagesc(handles.axes1,'CData',movingR);  
    if ~isempty(handles.R)
     answer = questdlg('Use the existing Registration?','question','Yes','No,create new','No,create new');
     switch answer
        case 'Yes'
          regR=handles.R;
          movingR = imwarp(moving,regR.t,'nearest','OutputView',regR.ref_fixed);
          err=regR.err;
        case 'No,create new'
          [movingR,regR]=cp_reg(moving,fixed,type);
          err=regR.err;
     end        
    else
        [movingR,regR]=cp_reg(moving,fixed,type);
        err=regR.err;
    end
    %handles.text_sz3.String=['err=',num2str(err,3)];
    if isfield(handles,'I3')
        I3=handles.I3;
        I3.CData=movingR;
    else
        I3 = imagesc(handles.axes1,'CData',movingR);
    end

    I3.AlphaData=0.5;
    handles.slider3.Enable='on';
    handles.slider3.Value=0.5;
    
    handles.R=regR;
    handles.I3=I3;
    figure(handles.f)
    guidata(hObject, handles);

% --- Executes on slider movement.
function slider1_Callback(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
handles.I1.AlphaData=handles.slider1.Value;
handles.ax1.Children.AlphaData=handles.slider1.Value+0.2;

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
handles.I2.AlphaData=handles.slider2.Value;
handles.ax2.Children.AlphaData=handles.slider2.Value+0.2;

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
handles.I3.AlphaData=handles.slider3.Value;
handles.ax3.Children.AlphaData=handles.slider3.Value+0.2;

% --- Executes during object creation, after setting all properties.
function slider3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

% --- Executes on button press in bt_savegif.
function bt_savegif_Callback(hObject, eventdata, handles)
% hObject    handle to bt_savegif (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

fps=handles.popup_fps.Value*0.05;
n_frames=handles.popup_frames.Value*10;
alpha=[0:1/n_frames:1,1:-1/n_frames:0];

[filename,filepath]=uiputfile({'*.gif'},'Save gif');
fname=fullfile(filepath,filename);
% specify which image to adjust transparency
    if isfield(handles,'I3')
        II=handles.I3;        
    elseif isfield(handles,'I2')
        II=handles.I2;
    else
        II=handles.I1;
    end
a=II.AlphaData; % store the alpha data before change it;
for n = 1:length(alpha)
    n     
      II.AlphaData=alpha(n);
      frame = getframe(handles.axes1); 
      im = frame2im(frame); 
      [imind,cm] = rgb2ind(im,256); 
      % Write to the GIF File 
      if n ==1
          imwrite(imind,cm,fname,'gif', 'Loopcount',inf); 
      else 
          imwrite(imind,cm,fname,'gif','WriteMode','append','DelayTime',fps); 
      end 
end
II.AlphaData=a; %reset alphadata



% --- Executes on button press in bt_addroi.
function bt_addroi_Callback(hObject, eventdata, handles)
% hObject    handle to bt_addroi (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

roigrp=handles.roigrp;
pentype=handles.popupmenu1.String{handles.popupmenu1.Value};
c1=handles.bt_c1.BackgroundColor;
c2=handles.bt_c2.BackgroundColor;
cstr=[c1;c2];
ref = imref2d(size(handles.I1.CData));
handles.bt_addroi.String='Drawing...';
myroi=ROI(handles.axes1,pentype,ref,cstr);
handles.bt_addroi.String='Add Roi';
myroi.tag=['roi',num2str(length(roigrp)+1)];
roigrp=[roigrp;myroi];
update_roitable(handles.uitable1,roigrp);
handles.roigrp=roigrp;
guidata(hObject, handles);

% --- Executes on button press in bt_c1.
function bt_c1_Callback(hObject, eventdata, handles)
% hObject    handle to bt_c1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
c=handles.bt_c1.BackgroundColor;
handles.bt_c1.BackgroundColor=uisetcolor(c);

% --- Executes on button press in bt_c2.
function bt_c2_Callback(hObject, eventdata, handles)
% hObject    handle to bt_c2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
c=handles.bt_c2.BackgroundColor;
handles.bt_c2.BackgroundColor=uisetcolor(c);

% --- Executes on button press in bt_loadroi.
function bt_loadroi_Callback(hObject, eventdata, handles)
% hObject    handle to bt_loadroi (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[filename,filepath]=uigetfile('*rroi','open roi files');
file=fullfile(filepath,filename);
if isequal(file,0)
   disp('User selected Cancel');
else
roigrp=handles.roigrp;
for i=1:length(roigrp)
    delete(roigrp(i).plt);
end
update_roitable(handles.uitable1,[]);
O=load(file,'-mat');
if isfield(O,'roigrpR')
    roigrpR=O.roigrpR;
  for i=1:length(roigrpR)
    roigrpR(i).plt.Parent=handles.axes1;
    roigrpR(i).ax=handles.axes1;
  end
  update_roitable(handles.uitable1,roigrpR);
  handles.roigrp=roigrpR;
  guidata(hObject, handles);
end

end

% --- Executes on selection change in popupmenu1.
function popupmenu1_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu1


% --- Executes during object creation, after setting all properties.
function popupmenu1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes when selected cell(s) is changed in uitable1.
function uitable1_CellSelectionCallback(hObject, eventdata, handles)
% hObject    handle to uitable1 (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.CONTROL.TABLE)
%	Indices: row and column indices of the cell(s) currently selecteds
% handles    structure with handles and user data (see GUIDATA)

if ~isempty(eventdata.Indices)
    %update pk and mass selection panel
    id=eventdata.Indices;
    roigrp=handles.roigrp;
    myroi=roigrp(id(1));
        
    if id(1,2)==2  %move ROI
%         handles.text_status1.String='ROI draw in process...';
%         handles.text_status1.BackgroundColor=[1,0.6,0];
     set(0, 'currentfigure', handles.f); 
        myroi=myroi.move;
%         handles.text_status1.String='Ready...';
%         handles.text_status1.BackgroundColor=[0,1,0];
%         myroi.sig=myroi.get_signal(msi.imgdata);  
  
    elseif id(1,2)==1 %change ROI name
        prompt = {'Enter new roi name:'};
        answer = inputdlg(prompt,'Input',[1 45],{myroi.tag});
        myroi.tag=answer{1};
    elseif id(1,2)==5  %update ROI notes
        prompt = {'update roi notes:'};
        answer = inputdlg(prompt,'Input',[1 45],{myroi.note});
        myroi.note=answer{1};
        %myroi.sig=myroi.get_signal(msi.imgdata);  
    elseif id(1,2)==6   %delete ROI   
        myroi.delete;
        myroi=[];
    end
    if isempty(myroi)
        roigrp(id(1))=[];        
    else
        roigrp(id(1))=myroi;
    end
    update_roitable(handles.uitable1,roigrp);
   handles.roigrp=roigrp;
guidata(hObject, handles);
end


% --- Executes on button press in bt_saveroi.
function bt_saveroi_Callback(hObject, eventdata, handles)
% hObject    handle to bt_saveroi (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[filename,filepath]=uiputfile('*.rroi','Save roi file');
file=fullfile(filepath,filename);
if isequal(file,0)
   disp('User selected Cancel');
else
roigrpR=handles.roigrp;
R=handles.R;
save(file,'roigrpR','R','-mat');
end


% --- Executes on selection change in popup_type1.
function popup_type1_Callback(hObject, eventdata, handles)
% hObject    handle to popup_type1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popup_type1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popup_type1


% --- Executes during object creation, after setting all properties.
function popup_type1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popup_type1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popup_type2.
function popup_type2_Callback(hObject, eventdata, handles)
% hObject    handle to popup_type2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popup_type2 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popup_type2


% --- Executes during object creation, after setting all properties.
function popup_type2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popup_type2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popup_fps.
function popup_fps_Callback(hObject, eventdata, handles)
% hObject    handle to popup_fps (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popup_fps contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popup_fps


% --- Executes during object creation, after setting all properties.
function popup_fps_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popup_fps (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popup_frames.
function popup_frames_Callback(hObject, eventdata, handles)
% hObject    handle to popup_frames (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popup_frames contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popup_frames


% --- Executes during object creation, after setting all properties.
function popup_frames_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popup_frames (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --------------------------------------------------------------------
function pb1_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to pb1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if isfield(handles,'I2') && isfield(handles,'R')
 I2=handles.I2;
 H = findobj(allchild(groot), 'flat', 'UserData', 2021111);
 if ~isempty(H)    
    msi=getappdata(H,'msi');
    handles.msi=msi;
    if isfield(msi,'imgC')
      moving=msi.imgC;
      imshow(moving,'parent',handles.ax2);
      sz=size(moving);
      handles.text_sz2.String=[num2str(sz(1)),' X ', num2str(sz(2))];
      
      regR=handles.R;
      movingR = imwarp(moving,regR.t,'nearest','OutputView',regR.ref_fixed);
      I2.CData=movingR;

    else
      msgbox('No data loaded in IsoScope','Error')  
    end
 else
     msgbox('IsoScope not open','Error')
 end
else
    msgbox('No registration or image loaded','Error')
end
 
 

% --------------------------------------------------------------------
function pb2_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to pb2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if isfield(handles,'I3') && isfield(handles,'R')
 I3=handles.I3;
 H = findobj(allchild(groot), 'flat', 'UserData', 2021111);
 if ~isempty(H)    
    msi=getappdata(H,'msi');
    handles.msi=msi;
    if isfield(msi,'imgC')
      moving=msi.imgC;
      imshow(moving,'parent',handles.ax3)
      sz=size(moving);
      handles.text_sz3.String=[num2str(sz(1)),' X ', num2str(sz(2))];
      
      regR=handles.R;
      movingR = imwarp(moving,regR.t,'nearest','OutputView',regR.ref_fixed);
      I3.CData=movingR;
    else
      msgbox('No data loaded in IsoScope','Error')  
    end
 else
     msgbox('IsoScope not open','Error')
 end
else
    msgbox('No registration or image loaded','Error')
end



% --------------------------------------------------------------------
function pb_right_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to pb_right (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles

% --------------------------------------------------------------------
function pb_left_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to pb_left (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function pb_up_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to pb_up (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function pb_down_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to pb_down (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function pb_zoomin_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to pb_zoomin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function pb_zoomout_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to pb_zoomout (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function pb_rotateL_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to pb_rotateL (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function pb_rotateR_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to pb_rotateR (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



% --------------------------------------------------------------------
function pb_batch_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to pb_batch (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
O=load('iongrp.mat');
iongrp=O.iongrp;
fixed=handles.I1.CData;
 f=figure('units','normalized','outerposition',[0 0 1 1]);
 ax=axes();
for i=1:length(iongrp)    
    moving=iongrp(i).imgC;
    movingR = imwarp(moving,handles.R.t,'nearest','OutputView',handles.R.ref_fixed);
    I1=imshow(fixed,'parent',ax);
    I2=imagesc(ax,'CData',movingR);
    I2.AlphaData=handles.slider2.Value; 
    title(ax,[iongrp(i).name,' (m/z=',num2str(iongrp(i).mz),')'])
    print(f,fullfile('output',['overlay',num2str(i)]),'-dpng')     
end
delete(f)
