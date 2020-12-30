function varargout = isoScope(varargin)
% ISOSCOPE MATLAB code for isoScope.fig
%      ISOSCOPE, by itself, creates a new ISOSCOPE or raises the existing
%      singleton*.
%
%      H = ISOSCOPE returns the handle to a new ISOSCOPE or the handle to
%      the existing singleton*.f
%
%      ISOSCOPE('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in ISOSCOPE.M with the given input arguments.
%
%      ISOSCOPE('Property','Value',...) creates a new ISOSCOPE or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before isoScope_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to isoScope_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help isoScope

% Last Modified by GUIDE v2.5 17-Dec-2020 22:40:41

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @isoScope_OpeningFcn, ...
                   'gui_OutputFcn',  @isoScope_OutputFcn, ...
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


% --- Executes just before isoScope is made visible.
function isoScope_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to isoScope (see VARARGIN)

% Choose default command line output for isoScope
handles.output = hObject;
addpath(genpath('GUI Layout Toolbox'));
addpath(genpath('imzML parsing tool'));
handles=gui_ini(handles);

axtoolbar(handles.axes1,{'zoomin','zoomout','pan','datacursor'},'visible','on');
%axtoolbar(handles.axes2,{'zoomin','zoomout','pan','datacursor','restoreview'},'visible','on');

h.zoom=zoom(handles.figure1);
h.zoom.Enable='off';
h.zoom.ActionPostCallback = @mypostcallback;

h.pan=pan(handles.figure1);
h.pan.Enable='off';
h.pan.ActionPostCallback = @mypostcallback;

pks=msi_loadpks(handles,'list00.xlsx');  %load peaks from defaul peak list
pk=Mzpk(pks.sdata(pks.pkid)); %define an arbitrary peak from the peak list.
update_pk(handles,pk);  %update ui

setappdata(handles.figure1,'pk',pk);
setappdata(handles.figure1,'pks',pks);
assignin('base','handles',handles);
% Update handles structure
guidata(hObject, handles);

% UIWAIT makes isoScope wait for user response (see UIRESUME)
% uiwait(handles.figure1);

function mypostcallback(obj,evd)
msi=getappdata(obj,'msi');
msi.scaleobj=msi.scaleobj.update;


% --- Outputs from this function are returned to the command line.
function varargout = isoScope_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function edit1_Callback(hObject, eventdata, handles)


% --- Executes during object creation, after setting all properties.
function edit1_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_ppm_Callback(hObject, eventdata, handles)
pk=getappdata(handles.figure1,'pk');
pk.ppm=str2num(handles.edit_ppm.String);
pk.M=0;
update_pk(handles,pk);
setappdata(handles.figure1,'pk',pk);
pb_plot_ClickedCallback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function edit_ppm_CreateFcn(hObject, ~, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_offset_Callback(hObject, eventdata, handles)
pk=getappdata(handles.figure1,'pk');
pk.offset=str2num(handles.edit_offset.String);
pk.M=0;
update_pk(handles,pk);
setappdata(handles.figure1,'pk',pk);
pb_plot_ClickedCallback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function edit_offset_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popup_z.
function popup_z_Callback(hObject, eventdata, handles)
pk=getappdata(handles.figure1,'pk');
pk.z=handles.popup_z.Value-3;
pk.addType=1;
update_pk(handles,pk);
setappdata(handles.figure1,'pk',pk);
pb_plot_ClickedCallback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function popup_z_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popup_isotype.
function popup_isotype_Callback(hObject, eventdata, handles)
pk=getappdata(handles.figure1,'pk');
pk.isoType=handles.popup_isotype.Value;
pk.M=0;
handles.bt_enrich.String=pk.isoName{pk.isoType};
update_pk(handles,pk);
setappdata(handles.figure1,'pk',pk);
pb_plot_ClickedCallback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function popup_isotype_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_formula_Callback(hObject, eventdata, handles)
pk=getappdata(handles.figure1,'pk');
pk.formula=handles.edit_formula.String;
pk.M=0;
update_pk(handles,pk);
setappdata(handles.figure1,'pk',pk);
pb_plot_ClickedCallback(hObject, eventdata, handles)

function edit_formula_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_name_Callback(hObject, eventdata, handles)

function edit_name_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function edit_mass_Callback(hObject, eventdata, handles)
pk=getappdata(handles.figure1,'pk');
pk.mass=str2num(handles.edit_mass.String);
pk.M=0;
update_pk(handles,pk);
setappdata(handles.figure1,'pk',pk);
pb_plot_ClickedCallback(hObject, eventdata, handles)

function edit_mass_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popup_M.
function popup_M_Callback(hObject, eventdata, handles)
% hObject    handle to popup_M (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popup_M contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popup_M
pk=getappdata(handles.figure1,'pk');
pk.M_=handles.popup_M.Value;
update_pk(handles,pk);
setappdata(handles.figure1,'pk',pk);
pb_plot_ClickedCallback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function popup_M_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popup_M (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_maxM_Callback(hObject, eventdata, handles)
% hObject    handle to edit_maxM (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_maxM as text
%        str2double(get(hObject,'String')) returns contents of edit_maxM as a double


% --- Executes during object creation, after setting all properties.
function edit_maxM_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_maxM (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popup_addtype.
function popup_addtype_Callback(hObject, eventdata, handles)
% hObject    handle to popup_addtype (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popup_addtype contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popup_addtype
pk=getappdata(handles.figure1,'pk');
pk.addType=handles.popup_addtype.Value;
update_pk(handles,pk);
setappdata(handles.figure1,'pk',pk);
pb_plot_ClickedCallback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function popup_addtype_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popup_addtype (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function popup_sort_Callback(hObject, eventdata, handles)
% hObject    handle to popup_sort (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popup_sort contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popup_sort
handles.text_status1.String='Sorting';
handles.text_status1.BackgroundColor=[1,0,1];
drawnow;

col_old=handles.popup_sort.UserData; %retrieve last sorting column# (0-n) from userdata   
col=handles.popup_sort.Value-1;
if col==col_old
  handles.popup_sort.BackgroundColor(1)=1-handles.popup_sort.BackgroundColor(1); %toggle between 1 and 0
end

pks=getappdata(handles.figure1,'pks');
dt=pks.data; %pks.data is always the origianl sorting
ordering_old=pks.ordering; %ordering index
pkid_old=pks.pkid;
corref=pks.corref;  %this never changes

if col==0  %#0 none
    dt_sorted=dt;
    ordering=1:size(dt,1);  %[1,2,...n]
else
    if handles.popup_sort.BackgroundColor(1)>0.9 %white color [1 1 1]
      [dt_sorted,ordering]=sortrows(dt,col,'ascend');
    else   % cyan color [0 1 1]
      [dt_sorted,ordering]=sortrows(dt,col,'descend');  
    end
end

pks.ordering=ordering;  %update ordering
pks.pkid=find(ordering==ordering_old(pkid_old)); %update pkid
setappdata(handles.figure1,'pks',pks); %update pks
handles.uitable1.Data=dt_sorted; %show sorted data in uitable

if max(max(corref))>0  %if corref available
 set_uitable_color(handles,dt_sorted,4); %4th column is score
else
 set_uitable_color(handles,dt,0);   % 0, no coloring
end

handles.popup_sort.UserData=col;
handles.text_status1.String='Ready';
handles.text_status1.BackgroundColor=[0,1,0];

% --------------------------------------------------------------------
function pb_openmsi_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to pb_openmsi (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[file,path]=uigetfile('*.mat','Select One or More Files', ...
   'MultiSelect', 'on');
if isequal(file,0)
   disp('User selected Cancel');
else    
    
    fname=fullfile(path,file);
    if ~iscell(fname)
      fn{1}=fname; 
      fname=fn;
    end     
      %-------if in networkdrive, download first, then load and delete
       if(fname{1}(1)>'M')
           handles.text_status1.String='File transfering...';
           handles.text_status1.BackgroundColor=[1,0,0];
           drawnow();
           mkdir tmp
           for i=1:length(fname)
            copyfile(fname{i},'tmp');
            [~,name,ext]=fileparts(fname{i});
            fn{i}=fullfile([pwd,'\tmp'],[name,ext]);
           end
           fname=fn;
       end
       
      %-----------
    handles.text_status1.String='Loading...';
    handles.text_status1.BackgroundColor=[1,0,0];
    drawnow();
        [O,~]=msi_merge(fname);
    handles.figure1.Name=O.msi.fname;
        
    if exist('tmp','dir')  %delete the temp folder including files if exist
        handles.text_status1.String='deleting tmp...';drawnow();
        rmdir tmp s
    end
    cla(handles.axes1);
    handles.axes1.XLimMode='auto';
    handles.axes1.YLimMode='auto';
    cla(handles.ax1);
    cla(handles.ax2);
    cla(handles.ax3);
    pk=getappdata(handles.figure1,'pk'); %pk can exist without msi
    msi=O.msi;    
%     msi=msi_ini(msi);    
%     msi=msi_get_idata(msi,pk);    
%     msi=msi_get_imgdata(msi);
    padding=[10,10,10,10]; % set padding
    msi.padding=padding;
    msi.pk=pk;
    msi.cmap=parula;
    msi.res=double(msi.res);
    
    msi=msi_get_metadata(msi,padding); %initialize, get metadata,ref and alphadata
    msi=msi_get_idata(msi,pk); % get 1d intensity data from mypk
    msi=msi_update_imgdata(msi); % update to get 2d imgdata

    msi.wdata=ones(size(msi.imgdata));%initialize weight=1 for each pixel
    
    msi.select_idata_type=0; 
    msi.isoidata=[];
    msi.currentID=1;  
    msi=msi_get_ms(msi);    
   % msi.ref=imref2d(size(msi.imgdata),msi.res,msi.res);  %create axis reference
   %pad=[1,1,1,1]; %padding
   %XLim=[min(msi.xx)*msi.res-pad(1),max(msi.xx)*msi.res+pad(3)];  %crop,padding, change XY limits
   %YLim=[min(msi.yy)*msi.res-pad(2),max(msi.yy)*msi.res+pad(4)];
   colorscale=[0,1];  %adjust color brightness
   msi.CLim=(max(msi.idata)+1e-9)*colorscale;
   msi.bgColor=get(handles.bt_bcolor,'BackgroundColor');
    
   % axes1 ----------initial drawing of image
   % handles.imobj=msi_ini_draw(handles.axes1,msi.imgdata,msi.ref,msi.alphadata,parula,CLim,'k',XLim,YLim); %%%%%%%initialize 
    handles.imobj=msi_create_imobj(handles.axes1,msi);
    
    handles.imobj.ButtonDownFcn = @axes1_ButtonDownFcn;% ----for ButtonDown action on the image
     
   % ax1   
   handles.msobj=stem(handles.ax1,msi.ms.XData,msi.ms.YData,'.'); %-------------MS object
        xlabel(handles.ax1,'m/z');
        ylabel(handles.ax1,'signal');
   %ax2
   handles.errobj=histogram(handles.ax2,msi.errdata(msi.errdata>-99));%-----------err object
        xlim(handles.ax2,[-pk.ppm,pk.ppm]);
        xlabel(handles.ax2,'ppm');
   %ax3     
   handles.sigobj=stem(handles.ax3,msi.idata,'.');
        xlim(handles.ax3,[0,size(msi.idata,1)]);           
        ylabel(handles.ax3,'signal')     
   %ax4
   sig=msi.idata;         
   handles.pieobj=pie(handles.ax4,[length(find(sig==0)),length(find(sig>0))]);
   
   
   
   msi.scaleobj=Pscale(handles.axes1);  %draw the scalebar on axes1
   msi.scaleobj.visible='Off';
   msi.handles=handles;
   setappdata(handles.figure1,'msi',msi);
    handles.text_status1.String='Ready...';
    handles.text_status1.BackgroundColor=[0,1,0];
    
   handles.bt_enrich.Enable='on'; 
  
  guidata(hObject, handles); 
  update_clim(hObject, eventdata, handles)
  
  %add weight image to axes2
  copyaxes(handles.axes2,handles.axes1);
  handles.axes2.CLim=[0,max(max(msi.wdata))];
  imobj2=handles.axes2.Children(3);
  imobj2.CData=msi.wdata;
  
  
  %handles.imobj.CData=msi.imgdata;
  handles.pb_plot.Enable=true;
  handles.pb_crop.Enable=true;
  handles.pb_savedata.Enable=true;
  handles.pb_overlay.Enable=true;
  handles.pb_seg.Enable=true;
  
end
    


% --------------------------------------------------------------------
function pb_plot_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to pb_plot (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

msi=getappdata(handles.figure1,'msi');
pk=getappdata(handles.figure1,'pk');
if ~isempty(msi.isoidata)
    if handles.bt_abs.Value
        msi=msi_select_idata(msi,pk.M_,1);
    elseif handles.bt_ratio.Value
      msi=msi_select_idata(msi,pk.M_,2);
    elseif handles.bt_fraction.Value
      msi=msi_select_idata(msi,pk.M_,3);  
    end
else
    msi.select_idata_type=0;
    msi=msi_get_idata(msi,pk); %get idata from pk
end

%    msi=msi_get_imgdata(msi);  %get imgdata from idata
    msi=msi_update_imgdata(msi);
    
    imgdata=msi.imgdata;
    if msi.select_idata_type==3
      imgdata=msi.imgdata./msi.wdata;  %apply weight to fraction image ONLY!!
    end
 
    handles.imobj.CData=imgdata; %update image object CData;
    if isfield(handles,'hh')
        if isvalid(handles.hh.axes1)
    R=handles.R;
    R.moving=imgdata2gray(msi);
    R.movingR = imwarp(R.moving,R.t,'nearest','OutputView',R.Rfixed);
    handles.hh.axes1.Children(2).CData=R.movingR;
    handles.hh.R=R;
    guidata(handles.hh.figure1,handles.hh)
        end
    end
    
    handles.msobj.XData=msi.ms.XData; %update ms
    handles.msobj.YData=msi.ms.YData;
    handles.errobj.Data=msi.errdata(msi.errdata>-99); %update errdata
    handles.errobj.BinMethod='auto';      %update histogram
           xlim(handles.ax2,[-pk.ppm,pk.ppm]); 
    handles.sigobj.YData=msi.idata; %update 1-D signal
    cla(handles.ax4,'reset')
    pie(handles.ax4,[length(find(msi.idata==0)),length(find(msi.idata>0))]);
   roigrp=getappdata(handles.figure1,'roigrp');
   if ~isempty(roigrp)
       for i=1:length(roigrp)           
           roigrp(i).sig=roigrp(i).get_signal(msi.imgdata); %update roi signal
       end
       setappdata(handles.figure1,'roigrp',roigrp);
       update_roitable(handles.uitable2,roigrp) %update roi table
   end
msi.errscore=err2score(msi.errdata,pk.ppm);
setappdata(handles.figure1,'msi',msi);
update_clim(hObject, eventdata, handles);  %update clim of the image plot

function pb_crop_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to pb_crop (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
msi=getappdata(handles.figure1,'msi');
waitfor(msgbox('Crop the image (drag and drop), double click to confirm, and then save this subset of imaging data','Instruction:'))
handles.text_status1.String='rec ROI selection...';
myroi=ROI(handles.axes1,'rectangle',msi.ref,'by');
myroi.plt.Visible='off';
edge=myroi.edge;
bd=[min(edge);max(edge)]'; %find bounds of x and y [xmin,xmax;ymin,ymax]
%ids=find([msi.data.x]>bd(1,1) & [msi.data.x]<bd(1,2) & [msi.data.y]>bd(2,1) & [msi.data.y]<bd(2,2));
    % this works with the old version of cropping display, without msi.metadata, 
mdata=msi.metadata;
ids=find(mdata(:,1)>bd(1,1) & mdata(:,1)<bd(1,2) & mdata(:,2)>bd(2,1) & mdata(:,2)<bd(2,2));

Msi.fname=msi.fname;
Msi.data=msi.data(ids);
Msi.res=msi.res*1000;
msi=Msi;
[filename,filepath]=uiputfile('*.mat','save to file');
fname=fullfile(filepath,filename);
if isequal(fname,0)
   disp('User selected Cancel');
else
handles.text_status1.String='Saving to disk...';
handles.text_status1.BackgroundColor='r';
drawnow();
msi.fname=fname;
save(fname,'msi','-v7.3');
handles.text_status1.String='Ready';
handles.text_status1.BackgroundColor='g';
end

function pb_savedata_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to pb_savedata (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
msi=getappdata(handles.figure1,'msi');
gui_savedialog(msi);

function pb_overlay_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to pb_overlay (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[filename,filepath]=uigetfile('*.png;*.jpg;*.tif','Load Microscopy image');
fname=fullfile(filepath,filename);
if isequal(fname,0)
   disp('User selected Cancel');
else   
    fixed=imread(fname);
    %figure,imshow(fixed);
end
msi=getappdata(handles.figure1,'msi');
%moving=imgdata2gray(msi);
moving=msi2rgb(msi.imgdata,msi.alphadata,msi.cmap,[handles.slider1.Value,handles.slider2.Value],handles.axes1.Color);
[mp,fp] = cpselect(moving,fixed,'Wait',true);

t = fitgeotrans(mp,fp,'affine');
Rfixed = imref2d(size(fixed));
movingR = imwarp(moving,t,'nearest','OutputView',Rfixed);
%figure,aa=imshowpair(fixed,registered,'blend');
R.moving=moving;
R.fixed=fixed;
R.movingR=movingR;
R.Rfixed=Rfixed;
R.t=t;

%hh=gui_roiview(R);
%handles.hh=hh;

handles.imobj.CData=R.movingR;
handles.imobj.AlphaData=0.5;
I2 = imagesc(handles.axes1,'CData',R.fixed);
I2.AlphaData=0.5;

I2.XData=handles.imgobj.XData;
I2.YData=handles.imobj.YData;

handles.axes1.DataAspectRatioMode='auto'
% I1 = imshow(R.movingRC,'Parent',a1); %a1.Children(3)   
% I2 = imagesc(a1,'CData',R.fixed); %a1.Children(2)
% I1.UserData=1;
% I2.UserData=2;
% a1.Position=[0.1,0.2,0.8,0.75];
% SliderH(1) = uicontrol('style','slider','position',[50 20 200 20],'Value',1,'UserData',1);
% SliderH(2) = uicontrol('style','slider','position',[50 50 200 20],'Value',1,'UserData',2);
% addlistener(SliderH, 'Value', 'PostSet', @callbackfn);

handles.R=R;
guidata(hObject, handles);

function pb_seg_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to pb_seg (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
msg='Clustering will be based on the peak list as shown in the table, please do untargeted or select desired peaks first, would you like to proceed?'; 
h=questdlg(msg,'warning','OK','Cancel','OK');
switch h
  case 'OK'
     prompt = {'Enter k value for Kmean Clustering:','Enter p value for PCA reduced dimensionaility (0 for no reduce)'};
 answer = inputdlg(prompt,'Input',[1 45],{'6','5'});
 k=str2num(answer{1});
 p=str2num(answer{2});
handles.text_status1.String='Clustering in process...';
handles.text_status1.BackgroundColor=[1,0.3,0];
drawnow();
msi=getappdata(handles.figure1,'msi');
assignin('base','msi',msi);
pks=getappdata(handles.figure1,'pks');
n=length(pks.sdata);
for i=1:n
    if i/10==floor(i/10)
   handles.text_status1.String=['Clustering in process...',num2str(i),'/',num2str(n)];
   drawnow();
    end
 pk=Mzpk(pks.sdata(i));
 msi=msi_get_idata(msi,pk);
 a(:,i)=msi.idata;
end
if p>0
 aa=pca(a'); %pca reduced 
 aa=aa(:,1:p); %top p 
else
 aa=a;
end

idx=kmeans(aa,k);
msi.idata=idx;
msi=msi_update_imgdata(msi);
img=msi.imgdata;
figure,imshow(label2rgb(img))
handles.text_status1.String='Ready';
handles.text_status1.BackgroundColor='g';
  case 'Cancel'
     
  otherwise
end


function update_clim(hObject, eventdata, handles)
msi=getappdata(handles.figure1,'msi');
if isempty(msi)
    return
end
idata=msi.idata;

if handles.radiobutton1.Value
    handles.slider1.Enable='off';
    handles.slider2.Enable='off';
    handles.edit_clim1.Enable='off';
    handles.edit_clim2.Enable='off';
    lb=0;
    ub=max(prctile(idata,99),min(idata(idata>0)));    
    if isempty(ub)
        ub=lb+1e-9;
    end
    handles.edit_clim1.String=num2str(lb);
    handles.edit_clim2.String=num2str(ub);
    handles.slider1.Value=lb;
    handles.slider2.Value=ub/(max(idata)+1e-9);
elseif handles.radiobutton2.Value 
    handles.slider1.Enable='on';
    handles.slider2.Enable='on';
    handles.edit_clim1.Enable='off';
    handles.edit_clim2.Enable='off';
    lb=max(idata)*handles.slider1.Value;
    ub=max(idata)*handles.slider2.Value;
    handles.edit_clim1.String=num2str(lb);
    handles.edit_clim2.String=num2str(ub);
elseif handles.radiobutton3.Value
    handles.slider1.Enable='off';
    handles.slider2.Enable='off';
    handles.edit_clim1.Enable='on';
    handles.edit_clim2.Enable='on';
    lb=str2num(handles.edit_clim1.String);
    ub=str2num(handles.edit_clim2.String);  
end

handles.axes1.CLim=[lb,ub+1e-9];





% --- Executes when selected cell(s) is changed in uitable1.
function uitable1_CellSelectionCallback(hObject, eventdata, handles)
if ~isempty(eventdata.Indices)
    %update pk and mass selection panel
    id=eventdata.Indices(1);           
    pks=getappdata(handles.figure1,'pks');
    pks.pkid=id;  %update pkid
    setappdata(handles.figure1,'pks',pks);
    pk=Mzpk(pks.sdata(pks.ordering(id))); %pk reset
    
    pk.ppm=str2num(handles.edit_ppm.String);%ppm pass over
    pk.offset=str2num(handles.edit_offset.String);%offset pass over
    pk.z=handles.popup_z.Value-3; %z pass over
    pk.addType=handles.popup_addtype.Value;%addType pass over
    pk.isoType=handles.popup_isotype.Value; %isoType pass over
    setappdata(handles.figure1,'pk',pk); 
    
    update_pk(handles,pk); 
       
    msi=getappdata(handles.figure1,'msi');
    if ~isempty(msi)
     msi.isoidata=[];
     setappdata(handles.figure1,'msi',msi);    
     bt_toggle_Callback(handles.bt_abs, eventdata, handles); 
     set(handles.bt_abs,'Enable','off');
     set(handles.bt_ratio,'Enable','off');
     set(handles.bt_fraction,'Enable','off');
    end
    
    
    
end



function axes1_ButtonDownFcn(hObject, eventdata)
msi=getappdata(gcf,'msi');
if isempty(msi)
    fprintf('missing data\n');
    return
end
axesHandle  = get(hObject,'Parent');
coordinates = get(axesHandle,'CurrentPoint');
x=round(coordinates(1,1)/msi.res);
y=round(coordinates(1,2)/msi.res);
id=find(msi.xx==x & msi.yy==y);
sig=msi.idata(id);
msi.handles.text_status2.String=['X = ',num2str(x), ';  Y = ',num2str(y),';  Sig = ', num2str(sig,'%.3g')];
if ~isempty(id)
msi.currentID=id;%setappdata(gcf,'msi',msi);
msi=msi_get_ms(msi); %update ms
msi.handles.msobj.XData=msi.ms.XData;
msi.handles.msobj.YData=msi.ms.YData;
end

setappdata(gcf,'msi',msi);

function uitable2_CellSelectionCallback(hObject, eventdata, handles)
if ~isempty(eventdata.Indices)
    %update pk and mass selection panel
    id=eventdata.Indices;
    roigrp=getappdata(handles.figure1,'roigrp');
    myroi=roigrp(id(1));
    msi=getappdata(handles.figure1,'msi');
    
    if id(1,2)==2  %move ROI
        %myroi.plt.Color='b';myroi.plt.StripeColor='y';
        handles.text_status1.String='ROI draw in process...';
        handles.text_status1.BackgroundColor=[1,0.6,0];
        myroi=myroi.move;
        handles.text_status1.String='Ready...';
        handles.text_status1.BackgroundColor=[0,1,0];
        myroi.sig=myroi.get_signal(msi.imgdata);  
        %myroi.plt.Color='c';myroi.plt.StripeColor='r';
    elseif id(1,2)==1 %change ROI name
        prompt = {'Enter new roi name:'};
        answer = inputdlg(prompt,'Input',[1 45],{myroi.tag});
        myroi.tag=answer{1};
    elseif id(1,2)==5  %update ROI notes
        prompt = {'update roi notes:'};
        answer = inputdlg(prompt,'Input',[1 45],{num2str(myroi.weight)});
        myroi.weight=answer{1};
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
    update_roitable(handles.uitable2,roigrp);
    setappdata(handles.figure1,'roigrp',roigrp);
end

function bt_loadpks_Callback(hObject, eventdata, handles)
[filename,path]=uigetfile('*.xlsx','Metabolite List');
file=fullfile(path,filename);
if isequal(file,0)
   disp('User selected Cancel');
else
    pks=msi_loadpks(handles,file);  %pks is a struct
    setappdata(handles.figure1,'pks',pks);
    dt=pks.data;
    set_uitable_color(handles,dt,0);    
    ev.Indices=[1,1]; %click on the first peak
    uitable1_CellSelectionCallback(hObject, ev, handles);     
end

function bt_savepks_Callback(hObject, eventdata, handles)
[filename,filepath]=uiputfile('*.xlsx','Save pks file');
file=fullfile(filepath,filename);
if isequal(file,0)
   disp('User selected Cancel');
else
   pks=getappdata(handles.figure1,'pks');
   writetable( struct2table(pks.sdata),file); %save pks to excel file
 
end

function bt_restorepks_Callback(hObject, eventdata, handles)
pks=getappdata(handles.figure1,'pks');
pks=msi_loadpks(handles,pks.filename);  %pks is a struct
setappdata(handles.figure1,'pks',pks);
dt=pks.data;
set_uitable_color(handles,dt,0);    
ev.Indices=[1,1]; %click on the first peak
uitable1_CellSelectionCallback(hObject, ev, handles);     


function bt_addroi_Callback(hObject, eventdata, handles)
handles.pn1.SelectedChild = 1;
handles.bt_roionoff.Value=1;
bt_roionoff_Callback(handles.bt_roionoff, eventdata, handles)

roigrp=getappdata(handles.figure1,'roigrp');
msi=getappdata(handles.figure1,'msi');


types={'polygen','rectangle','ellipse','freehand'};
prompt = {'Enter roi name:','Enter pen type (1=ploygen, 2=rectangle, 3=ellipse, 4=freehand):',...
    'Enter pen color (choose any two letters from [rgbcmykw], i.e., bw, ky)','Notes:'};
answer = inputdlg(prompt,'Input',[1 65],{['r',num2str(length(roigrp)+1)],'1','rc', ' '});

pentype=types{str2num(answer{2})};  %pentype

cstr=answer{3};  %pencolor
if contains('rbgcmykw',cstr(1)) && contains('rbgcmykw',cstr(2))
   cstr=cstr(1:2);
else
   cstr='cr';
end

handles.text_status1.String='ROI draw in process...';
handles.text_status1.BackgroundColor=[1,0.6,0];
myroi=ROI(handles.axes1,pentype,msi.ref,cstr);
handles.text_status1.String='Ready...';
handles.text_status1.BackgroundColor=[0,1,0];

myroi.tag=answer{1};


myroi.weight=answer{4};
myroi.sig=myroi.get_signal(msi.imgdata);
roigrp=[roigrp;myroi];
setappdata(handles.figure1,'roigrp',roigrp);

update_roitable(handles.uitable2,roigrp);

function bt_addweight_Callback(~, eventdata, handles)

msi=getappdata(handles.figure1,'msi');
handles.pn1.SelectedChild = 2;

prompt = {'Update weight (default=1)'};
answer = inputdlg(prompt,'Input',[1 45],{'1'});


handles.text_status1.String='ROI draw in process...';
handles.text_status1.BackgroundColor=[1,0.5,0];
myroi=ROI(handles.axes2,'polygen',msi.ref);
handles.text_status1.String='Ready...';
handles.text_status1.BackgroundColor=[0,1,0];


myroi.plt.Visible='off';
msi.wdata(myroi.BW)=str2num(answer{1});

handles.axes2.CLim=[0,max(max(msi.wdata))];
imobj2=handles.axes2.Children(end);
imobj2.CData=msi.wdata;

setappdata(handles.figure1,'msi',msi);



function bt_loadroi_Callback(hObject, eventdata, handles)
[filename,filepath]=uigetfile('*.ROI','open roi files');
file=fullfile(filepath,filename);
if isequal(file,0)
   disp('User selected Cancel');
else
roigrp=getappdata(handles.figure1,'roigrp');
for i=1:length(roigrp)
    delete(roigrp(i).plt);
end
update_roitable(handles.uitable2,[]);
O=load(file,'-mat');

if isfield(O,'roigrp')
    roigrp=O.roigrp;
  for i=1:length(roigrp)
    roigrp(i).plt.Parent=handles.axes1;
    roigrp(i).ax=handles.axes1;
  end
  update_roitable(handles.uitable2,roigrp);
  setappdata(handles.figure1,'roigrp',roigrp);
end

if isfield(O,'wdata')
   msi=getappdata(handles.figure1,'msi');  
   msi.wdata=O.wdata;
   imobj2=handles.axes2.Children(end);
   imobj2.CData=msi.wdata;
   setappdata(handles.figure1,'msi',msi);   
end
    

end


function bt_saveroi_Callback(hObject, eventdata, handles)
[filename,filepath]=uiputfile('*.ROI','Save roi file');
file=fullfile(filepath,filename);
if isequal(file,0)
   disp('User selected Cancel');
else
roigrp=getappdata(handles.figure1,'roigrp');
msi=getappdata(handles.figure1,'msi');
wdata=msi.wdata;
save(file,'roigrp','wdata','-mat');
end

function bt_roionoff_Callback(hObject, eventdata, handles)
if hObject.Value  
  set(hObject,'BackgroundColor','g');  
  roigrp=getappdata(handles.figure1,'roigrp');
  if ~isempty(roigrp)
      for i=1:length(roigrp)
          roigrp(i).plt.Visible='on';
      end
  end
else  
  set(hObject,'BackgroundColor',[.94,.94,.94]);
  roigrp=getappdata(handles.figure1,'roigrp');
  if ~isempty(roigrp)
      for i=1:length(roigrp)
          roigrp(i).plt.Visible='off';
      end
  end

end

function bt_rainbow_Callback(hObject, eventdata, handles)
c=gui_colorselection;
handles.axes1.Colormap=c;

function bt_bcolor_Callback(hObject, eventdata, handles)
 c=uisetcolor;
 handles.axes1.Color=c;
 set(handles.bt_bcolor,'BackgroundColor',c);

function bt_scalebar_Callback(hObject, eventdata, handles)
msi=getappdata(handles.figure1,'msi');
if hObject.Value
  msi.scaleobj.visible='On';
  set(hObject,'BackgroundColor','g');
else
  msi.scaleobj.visible='Off';
  set(hObject,'BackgroundColor',[.94,.94,.94]);
end
msi.scaleobj.update;
setappdata(handles.figure1,'msi',msi);

function bt_enrich_Callback(hObject, eventdata, handles)
 handles.text_status1.String='Calculate Enrichment...';
 handles.text_status1.BackgroundColor=[1,0,0];
 drawnow();          
msi=getappdata(handles.figure1,'msi');
pk=getappdata(handles.figure1,'pk');
msi=msi_get_isoidata(msi,pk);  %calcualte isodata
  item=0;
  for j=1:size(msi.isoidata.idata,2)
     item=item+1;
     pk.M_=j;
        pks_{item,1}=[pk.name,'_M',pk.MList_{j}];
        pks_{item,2}=pk.formula;
        pks_{item,3}=num2str(pk.mz_);
          
     msi=msi_select_idata(msi,j,1); %1: intensity
handles.bt_abs.Enable='on';
handles.bt_abs.Value=1;
handles.bt_ratio.Enable='on';
handles.bt_fraction.Enable='on';
%handles.bt_isobar.Enable='on';
setappdata(handles.figure1,'msi',msi);
bt_toggle_Callback(handles.bt_abs, eventdata, handles);
handles.text_status1.String='Ready...';
handles.text_status1.BackgroundColor=[0,1,0];
     
     
     roigrp=getappdata(handles.figure1,'roigrp');
     if length(roigrp)==0
    handles.uitable_sheet1.Data=[];
    handles.uitable_sheet2.Data=[];
    handles.uitable_sheet3.Data=[];
    handles.uitable_sheet1.ColumnName=[];
    handles.uitable_sheet2.ColumnName=[];
    handles.uitable_sheet3.ColumnName=[];
        return;
     end
       for k=1:length(roigrp)
         sig1(item,k)=roigrp(k).get_signal(msi.imgdata); %update roi signal  
       end
     msi=msi_select_idata(msi,j,2); %2: enrichment
       for k=1:length(roigrp)
         sig2(item,k)=roigrp(k).get_signal(msi.imgdata); %update roi signal  
       end       
  end    
    msi=msi_select_idata(msi,j,3); %3. fraction
       for k=1:length(roigrp)
         imgdata=msi.imgdata./msi.wdata; %weight added.
         sig3(k)=roigrp(k).get_signal(imgdata); %update roi signal  
       end 
  sheet1=[pks_,num2cell(sig1)];
  sheet2=[pks_,num2cell(sig2)];
  sheet3=[pk.name,pk.formula,pk.mz_,num2cell(sig3)];
  head=[{'Name','Formula','mz'},{roigrp.tag}];
  handles.uitable_sheet1.Data=sheet1;
  handles.uitable_sheet2.Data=sheet2;
  handles.uitable_sheet3.Data=sheet3;
  handles.uitable_sheet1.ColumnName=head;
  handles.uitable_sheet2.ColumnName=head;
  handles.uitable_sheet3.ColumnName=head;
  
%   T1=cell2table([head;sheet1]);
% T2=cell2table([head;sheet2]);
% T3=cell2table([head;sheet3]);





%msi=msi_select_idata(msi,M,1);


function bt_toggle_Callback(hObject, eventdata, handles)
msi=getappdata(handles.figure1,'msi');
pk=getappdata(handles.figure1,'pk');

h1=handles.bt_abs;
h2=handles.bt_ratio;
h3=handles.bt_fraction;

if strcmp(hObject.String,'abs')
    set(h1,'Value',1,'BackgroundColor','g'); 
    set(h2,'Value',0,'BackgroundColor',[.94,.94,.94]); 
    set(h3,'Value',0,'BackgroundColor',[.94,.94,.94]); 
    pb_plot_ClickedCallback(hObject, eventdata, handles);
elseif strcmp(hObject.String,'ratio')
    set(h2,'Value',1,'BackgroundColor','g'); 
    set(h1,'Value',0,'BackgroundColor',[.94,.94,.94]); 
    set(h3,'Value',0,'BackgroundColor',[.94,.94,.94]); 
    pb_plot_ClickedCallback(hObject, eventdata, handles);
elseif strcmp(hObject.String,'frac')
    set(h3,'Value',1,'BackgroundColor','g'); 
    set(h1,'Value',0,'BackgroundColor',[.94,.94,.94]); 
    set(h2,'Value',0,'BackgroundColor',[.94,.94,.94]); 
    pb_plot_ClickedCallback(hObject, eventdata, handles);
else
    set(h1,'Enable','off');
    set(h2,'Enable','off');
    set(h3,'Enable','off');
end


function bt_targeted_Callback(hObject, eventdata, handles)
% O=load('I2.mat');
% I2=O.I2;
% I2 = rgb2gray(I2);
% I2=I2*floor(255/max(max(I2))); 
% theta=0.02;nX=1;
% t2=[nX 0 0; 0 nX 0; 0 0 1];   %^^^^resizing transformation
% t3=[cos(theta),sin(theta),0;-sin(theta),cos(theta),0;0,0,1]; %^^^^rotation transformation
% T=t2*t3;
% tform = affine2d(T);
% I3 = imwarp(I2,tform);
% p3=handles.axes1.Children(3).CData;  %imageing
% ref1=imref2d(size(p3),0.05,0.05);
% I3=padarray(I3,[1830,6880],'pre'); %transformed histology
% ref3=imref2d(size(I3),0.0048,0.0048);
% figure,imshowpair(p3,ref1,I3,ref3)


handles.text_status1.String='Targeted ...';
handles.text_status1.BackgroundColor=[1,0,0];
drawnow();

msi=getappdata(handles.figure1,'msi');
sz=length([msi.data]);
mz_out=[];
sampling=min(500,size(msi.idata,1));
ppm=str2num(handles.edit_ppm.String);
answer = inputdlg({'Enter #of samplings:'},'Input',[1,35],{num2str(sampling)});
n=str2num(answer{1});
ids=randperm(sz,n);

pks=getappdata(handles.figure1,'pks');
dt=pks.data;
matrix=zeros(size(dt,1),n);
H=1.00727646677;
pk=getappdata(handles.figure1,'pk');
for i=1:n  
  ms1=msi.data(ids(i)).peak_mz(:);
  ms2=msi.data(ids(i)).peak_sig(:);
  for j=1:size(dt,1)
     mz= dt{j,3}+H*pk.z;     
     [matrix(j,i),~] = ms2sig(ms1,ms2,[mz-mz*ppm*1e-6,mz+mz*ppm*1e-6]);      
  end
end
corref=corr(matrix', matrix');
for i=1:size(dt,1)
 dt{i,4}=nnz(matrix(i,:))/n;
end

header=handles.uitable1.ColumnName;
header(4)={'score'};
handles.uitable1.Data=dt;
handles.popup_sort.String=['none';header(:)];
set_uitable_color(handles,dt,4);
pks.data=dt;
pks.ordering=1:size(dt,1);
pks.corref=corref;
setappdata(handles.figure1,'pks',pks);
 %----------done
handles.text_status1.String='Ready';
handles.text_status1.BackgroundColor=[0,1,0];

function bt_untargeted_Callback(hObject, eventdata, handles)
handles.text_status1.String='Untargeted ...';
handles.text_status1.BackgroundColor=[1,0,0];
drawnow();

pk=getappdata(handles.figure1,'pk'); %pk reset
pks=getappdata(handles.figure1,'pks'); %pk reset
pk.z=handles.popup_z.Value-3; %z pass over
pk.addType=1;
setappdata(handles.figure1,'pk',pk);     
update_pk(handles,pk); 

msi=getappdata(handles.figure1,'msi');
sz=length([msi.data]);
mz_out=[];
sampling=min(500,size(msi.idata,1));
ppm=str2num(handles.edit_ppm.String);

answer = inputdlg({'Enter #of samplings:','cutoff()'},'Input',[1,35],{num2str(sampling),'0.2'});
n=str2num(answer{1});
pct=str2num(answer{2});

ids=randperm(sz,n);

for i=1:n
    i    
 ms=double([msi.data(ids(i)).peak_mz(:),msi.data(ids(i)).peak_sig(:)]);%a spectrum 
 ms=ms_remove_dup(ms,ppm); %remove dup
 msdata(i).mz=msi.data(ids(i)).peak_mz;
 msdata(i).sig=double(msi.data(ids(i)).peak_sig);     
 mz_out=mergeTwoSorted(mz_out,[ms,ones(size(ms,1),1)]);
 mz_out=ms_merge(mz_out,ppm);
end

mz_out(:,2)=mz_out(:,2)/n; %averaged
mz_=[];sig_=[];
for i=1:size(mz_out,1)
    mz_=[mz_;mz_out(i,1);mz_out(i,1);mz_out(i,1)];
    sig_= [sig_;0;mz_out(i,2);0];
end

a=mz_out(:,3); %frequency counts
b=mz_out(:,2); %averaged signal

%[length(a(a>(0.2*n))),length(b(b>1e4))]

mz_out_short=mz_out(a>(pct*n),:);  %apply coverage cutoff from user input

H=1.00727646677;
pk=getappdata(handles.figure1,'pk');
mz_nt=mz_out_short(:,1)-H*pk.z;
data=cell(length(mz_nt),4);
data(:,1)=cellstr(num2str([1:length(mz_nt)]',['Un','-%04d']));
data(:,3)=num2cell(mz_nt);
data(:,4)=num2cell(mz_out_short(:,3)/n);
%set(handles.uipanel2,'Title', ['#pks : ',num2str(size(data,1))]);
handles.text_status1.String='Calculate I matrix';drawnow();
tic
matrix=zeros(length(mz_nt),n);
for i=1:length(mz_nt)
    pks_(i).mz=mz_nt(i);
    pks_(i).id=i;
    %calculate the intensity matrix for filtered good peaks
    
    for j=1:n
       mz_=mz_out_short(i,1);
       dm=ppm*1e-6*mz_out_short(i,1);
      mz_range=[mz_-dm,mz_+dm];  
    [b,c]=findInSorted(msdata(j).mz,mz_range);
    tp=b:c;
      if ~isempty(tp)
         matrix(i,j)=max(msdata(j).sig(tp));
      end
    end
end
toc
corref=corr(matrix', matrix');

handles.text_status1.String='dbase searching';drawnow();
dbase=readtable('db_master.xlsx');
dbase=table2struct(dbase);
info=msi_find_dbase(dbase,pks_,ppm*1e-6,0);  %dbase formula matching
data(:,2)={info.formula};

handles.text_status1.String='finding adduct';drawnow();
load adduct
[~,annotation]=msi_find_adduct(pks_,adduct,ppm*1e-6);  %adduct finder
data(:,5)=annotation;

%show table, put color
 header={'Name','Formula','m_z','score','annotation'};
 handles.uitable1.ColumnName=header;
 handles.uitable1.Data=data;
 handles.popup_sort.String=['none';header(:)];
 handles.popup_sort.Value=1;
 set_uitable_color(handles,data,4);
 T=cell2table(data);
 T.Properties.VariableNames = header;
 pks.sdata=table2struct(T);
 pks.data=data;
 pks.pkid=1;
 pks.ordering=1:size(data,1);
 pks.corref=corref;
 setappdata(handles.figure1,'pks',pks); %update pks.data
 

 %----------done
handles.text_status1.String='Ready';
handles.text_status1.BackgroundColor=[0,1,0];
%handles.bt_targeted.Enable='off';

  ev.Indices=[1,1]; %event data in uitable selected row#
  uitable1_CellSelectionCallback(hObject, ev, handles); %click uitable

function bt_select_Callback(hObject, eventdata, handles)
pks=getappdata(handles.figure1,'pks');
pks=gui_select(pks); % call peak selection gui **********
setappdata(handles.figure1,'pks',pks);
set(handles.uitable1,'ColumnName',pks.header);
set(handles.uitable1,'data',pks.data);
set_uitable_color(handles,pks.data,4);
handles.popup_sort.Value=1;
handles.popup_sort.UserData=1;
ev.Indices=[1,1];
uitable1_CellSelectionCallback(hObject, ev, handles);

function bt_batch1_Callback(hObject, eventdata, handles)
 roigrp=getappdata(handles.figure1,'roigrp');
 if isempty(roigrp)
     msgbox('You need at least one ROI in order to proceed, please Click ROI tool first','warning!')
     return
 end
 %roi=roigrp.roi;
 
pks=getappdata(handles.figure1,'pks');
%corref=pks.corref;
dt=pks.data;
%pkid=pks.pkid;
% ind=gui_select(pks);

ind=1:size(dt,1);

for i=1:length(ind)
  ev.Indices=[ind(i),1]; %event data in uitable selected row#
  uitable1_CellSelectionCallback(hObject, ev, handles); %click uitable
 
%   handles.popup_M.Value=2;
%   popup_M_Callback(hObject, eventdata, handles);
  
  drawnow()
  msi=getappdata(handles.figure1,'msi');
  pk=getappdata(handles.figure1,'pk');
  info(i).imgdata=msi.imgdata;
  info(i).CLim=handles.axes1.CLim;
  info(i).name=pk.name;
  info(i).mz=pk.mz_;
  info(i).errscore=msi.errscore;
  
  for j=1:length(roigrp)           
         sig(i,j)=roigrp(j).get_signal(msi.imgdata); %update roi signal           
  end
end
t1=[pks.header(1:3),{roigrp.tag}];
t2=[pks.data(:,1:3),num2cell(sig)];
T=cell2table([t1;t2]);

%---------save excel
if strcmp(questdlg('Export excel file?','ROI intensities?','Yes','No','Yes'),'Yes')
 [file, path]=uiputfile('*.xlsx');
 filename=fullfile(path,file);
 if isequal(file,0)
    disp('User selected Cancel');
 else
     if isfile(filename)
         delete(filename)
     else
     end
    writetable(T,fullfile(path,file),'WriteVariableNames',false,'Sheet',1);    
 end
end
n=floor(sqrt(i));
m=ceil(i/n);

%------------------save images

if strcmp(questdlg('Export group images?','','Yes','No','Yes'),'Yes')
    definput = {'20','hsv'};
    answer = inputdlg({'Enter #Row:','Enter #Column:'},'Input',[1,35],{num2str(n),num2str(m)});
  %idata2pic(idata,A,[str2num(answer{1}),str2num(answer{2})]);
  M=str2num(answer{1});N=str2num(answer{2});
  fig=0;
handles.text_status1.String='exporting figures ...';
handles.text_status1.BackgroundColor=[1,0,0];
drawnow();
  for i=1:length(ind)
   md=mod(i,M*N);
     if md==1        
        f=figure('units','normalized','outerposition',[0 0 1 1]);
        fig=fig+1;        
     elseif md==0
         md=M*N;
     end
     ax=subplot(M,N,md,'parent',f);         
     
     msi_ini_draw(ax,info(i).imgdata,msi.ref,msi.alphadata,handles.axes1.Colormap,info(i).CLim,'k',handles.axes1.XLim,handles.axes1.YLim);
     title(ax,{info(i).name,['m/z = ',num2str(info(i).mz)],['score=',num2str(info(i).errscore)]});
     %drawnow();
     if md==M*N
         print(f,['outputfigure',num2str(fig)],'-dpng')
     end    
  end
  
handles.text_status1.String='Ready';
handles.text_status1.BackgroundColor=[0,1,0];   
drawnow();
end 
  
function bt_batch2_Callback(hObject, eventdata, handles)
roigrp=getappdata(handles.figure1,'roigrp');
if isempty(roigrp)
     msgbox('You need at least one ROI in order to proceed, please Click ROI tool first','warning!')
     return
end
handles.text_status1.String='Batch Enrichment...';
handles.text_status1.BackgroundColor=[1,0,0];

pks=getappdata(handles.figure1,'pks');  %get metabolite peak list
%pk=getappdata(handles.figure1,'pk');
% ind=gui_select(pks);
dt=pks.data;
ind=1:size(dt,1);

item=0; %
for i=1:length(ind)   %loop over peaks
  ev.Indices=[ind(i),1];  %event data in uitable selected row#
  uitable1_CellSelectionCallback(hObject, ev, handles); %click uitable  
  bt_enrich_Callback(hObject, eventdata, handles) %click enrich
  drawnow();
  msi=getappdata(handles.figure1,'msi');
  pk=msi.pk;
    for j=1:size(msi.isoidata.idata,2)
     item=item+1;
     pk.M_=j;
        pks_{item,1}=[pks.sdata(i).Name,'_M',pk.MList_{j}];
        pks_{item,2}=pks.sdata(i).Formula;
        pks_{item,3}=num2str(pk.mz_);
          
     msi=msi_select_idata(msi,j,1); %1: intensity
       for k=1:length(roigrp)
         sig1(item,k)=roigrp(k).get_signal(msi.imgdata); %update roi signal  
       end
     msi=msi_select_idata(msi,j,2); %2: enrichment
       for k=1:length(roigrp)
         sig2(item,k)=roigrp(k).get_signal(msi.imgdata); %update roi signal  
       end       
    end    
    msi=msi_select_idata(msi,j,3); %3. fraction
       for k=1:length(roigrp)
         imgdata=msi.imgdata./msi.wdata; %weight added.
         sig3(i,k)=roigrp(k).get_signal(imgdata); %update roi signal  
       end 
end

% t1=[pks.header(1:3),{roigrp.tag}];
% t2=[pks.data(:,1:3),num2cell(sig)];
% T=cell2table([t1;t2]);
sheet1=[pks_,num2cell(sig1)];
sheet2=[pks_,num2cell(sig2)];
sheet3=[pks.data(:,1:3),num2cell(sig3)];
head=[pks.header(1:3),{roigrp.tag}];
T1=cell2table([head;sheet1]);
T2=cell2table([head;sheet2]);
T3=cell2table([head;sheet3]);
handles.text_status1.String='Ready...';
handles.text_status1.BackgroundColor=[0,1,0];drawnow();

if strcmp(questdlg('Export excel file?','ROI enrichment?','Yes','No','Yes'),'Yes')
 [file, path]=uiputfile('*.xlsx');
filename=fullfile(path,file);
 if isequal(file,0)
    disp('User selected Cancel');
 else
     if isfile(filename)
         delete(filename)
     else
     end
        writetable(T1,filename,'WriteVariableNames',false,'Sheet',1);
        writetable(T2,filename,'WriteVariableNames',false,'Sheet',2);
        writetable(T3,filename,'WriteVariableNames',false,'Sheet',3);
 end
end



function bt_msview_Callback(hObject, eventdata, handles)
msi=getappdata(handles.figure1,'msi');
dt=[msi.ms.XData,msi.ms.YData];
gui_msview(dt); 

function bt_savefig_Callback(hObject, eventdata, handles)
f=figure;
ax1=axes(f, 'units','normalized');
copyaxes(ax1,handles.axes1);
msi=getappdata(handles.figure1,'msi');

imgdata=msi.imgdata;
alphadata=msi.alphadata;
cmap=handles.axes1.Colormap;
cscale=[handles.slider1.Value,handles.slider2.Value];
[imgC,ab]=msi2rgb(imgdata,alphadata,cmap,cscale,handles.axes1.Color);
[filename,filepath]=uiputfile('*.png;*.jpg;*.tif','Save RGB image');
fname=fullfile(filepath,filename);
if isequal(filename,0)
   disp('User selected Cancel');
else  
    [~,~,ext]=fileparts(fname);
    if strcmp(ext,'.png')||strcmp(ext,'.jpg')
      imwrite(imgC,fname);
    elseif strcmp(ext,'.tif')
       imwrite(imgdata,fname)        
    end
end



% f=figure;
% ax1=axes(f, 'units','normalized');
% ax1.YDir = 'reverse';
% new_handle = copyobj(handles.axes1.Children,ax1);
% xlim(ax1,xlim(handles.axes1));
% ylim(ax1,ylim(handles.axes1));
% set(ax1,'DataAspectRatio',[1 1 1],...
%         'PlotBoxAspectRatio',[1 1 1],...
%         'XTickLabel',[],...
%         'YTickLabel',[]);


function bt_fun1_Callback(hObject, eventdata, handles)
msi=getappdata(handles.figure1,'msi');
pks=getappdata(handles.figure1,'pks');
assignin('base','msi',msi);
assignin('base','pks',pks);

dt=pks.data;
ind=1:size(dt,1);

for i=1:length(ind)
  ev.Indices=[ind(i),1]; %event data in uitable selected row#
  uitable1_CellSelectionCallback(hObject, ev, handles); %click uitable
  drawnow()
  msi=getappdata(handles.figure1,'msi');
  msi.pk.M=0;  %M0
  msi=msi_get_idata(msi,msi.pk);
  M0(:,i)=msi.idata;
  cc0=msi.coverage;
  msi.pk.M=1; %M1
  msi=msi_get_idata(msi,msi.pk);
  M1(:,i)=msi.idata;
  cc1=msi.coverage;
  
  ratio(i,1)=msi.pk.maxM_;
  ratio(i,2)= mean(M1(:,i))/mean(M0(:,i))/0.011;
  ratio(i,3)=cc0;
  ratio(i,4)=cc1;
end

T1=[pks.data(:,1)';num2cell(M0)];
T2=[pks.data(:,1)';num2cell(M1)];
T3=[{'C_num','C_num_calculated','coverage_M0','coverage_M1'};num2cell(ratio)];

[filename,filepath]=uiputfile({'*.xlsx';},'Save as');
file=fullfile(filepath,filename);
if isequal(file,0)
   disp('User selected Cancel');
else   
    writetable(cell2table(T1),file,'sheet','M0','WriteVariableNames', 0);
    writetable(cell2table(T2),file,'sheet','M1','WriteVariableNames', 0);
    writetable(cell2table(T3),file,'sheet','ratio','WriteVariableNames', 0);
end

function bt_fun2_Callback(hObject, eventdata, handles)
msi=getappdata(handles.figure1,'msi');
assignin('base','msi',msi);
if isempty(msi.isoidata)
figure,histogram(msi.idata,100);
else
    n=size(msi.isoidata.idata,2);
    figure
    for i=1:n
        subplot(n,1,i)
    histogram(msi.isoidata.idata(:,i),100);
    legend(msi.pk.MList_{i})
    end
end


function bt_fun3_Callback(hObject, eventdata, handles)
msi=getappdata(handles.figure1,'msi');
assignin('base','msi',msi);
ppm=msi.pk.ppm;
if isempty(msi.isoidata)
figure,histogram(msi.errdata(msi.errdata>-99));
xlim([-ppm,ppm]);
else
    n=size(msi.isoidata.idata,2);
    figure
    msi.pk.MList_
    for i=1:n
        subplot(n,1,i)
        dt=msi.isoidata.idata_err(:,i);
    histogram(dt(dt>-99));
    xlim([-ppm,ppm]);
    legend(msi.pk.MList_{i})
    end
end

function bt_fun4_Callback(hObject, eventdata, handles)
msi=getappdata(handles.figure1,'msi');
assignin('base','msi',msi);
pks=getappdata(handles.figure1,'pks');
for i=1:length(pks.sdata)
    i
 pk=Mzpk(pks.sdata(i));
 msi=msi_get_idata(msi,pk);
 a(:,i)=msi.idata;
end
aa=pca(a');
k=7;p=6;
idx=kmeans(aa(:,1:p),k);
msi.idata=idx;
msi=msi_update_imgdata(msi);
img=msi.imgdata;
figure,imshow(label2rgb(img))

% --- Executes on slider movement.
function slider1_Callback(hObject, eventdata, handles)

function slider1_CreateFcn(hObject, eventdata, handles)
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

function slider2_Callback(hObject, eventdata, handles)

function slider2_CreateFcn(hObject, eventdata, handles)

if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end




function edit_clim1_Callback(hObject, eventdata, handles)
% hObject    handle to edit_clim1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_clim1 as text
%        str2double(get(hObject,'String')) returns contents of edit_clim1 as a double


% --- Executes during object creation, after setting all properties.
function edit_clim1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_clim1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_clim2_Callback(hObject, eventdata, handles)
% hObject    handle to edit_clim2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_clim2 as text
%        str2double(get(hObject,'String')) returns contents of edit_clim2 as a double


% --- Executes during object creation, after setting all properties.
function edit_clim2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_clim2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in radiobutton1.
function radiobutton1_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton1


% --------------------------------------------------------------------
function pb_convert_ibd_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to pb_convert_ibd (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
gui_convert();


% --------------------------------------------------------------------
function pb_convert_plate_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to pb_convert_plate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
convert_plate(handles);


% --- Executes on button press in checkbox_log.
function checkbox_log_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_log (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_log
if hObject.Value
    handles.axes1.ColorScale='log';
else
    handles.axes1.ColorScale='linear';
end


% --------------------------------------------------------------------
function uipushtool5_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to uipushtool5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
msi=getappdata(handles.figure1,'msi');

msi=dispatchGUI('gui_scalebar',msi,handles);


% --------------------------------------------------------------------


% --------------------------------------------------------------------


% --------------------------------------------------------------------



% --------------------------------------------------------------------