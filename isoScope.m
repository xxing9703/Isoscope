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

% Last Modified by GUIDE v2.5 22-Jun-2022 14:49:12

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

h.datacursor = datacursormode(handles.figure1);
h.datacursor.UpdateFcn={@myupdatefcn,handles};


pks=msi_loadpks(handles,'list00.xlsx');  %load peaks from defaul peak list
pk=Mzpk(pks.sdata(pks.pkid)); %define an arbitrary peak from the peak list.
pks_h{1}=pks;
update_pk(handles,pk);  %update ui
setappdata(handles.figure1,'pk',pk);
setappdata(handles.figure1,'pks',pks);
setappdata(handles.figure1,'pks_h',pks_h);
handles.bt_restorepks.Enable='off';
assignin('base','handles',handles);
% Update handles structure
guidata(hObject, handles);

% UIWAIT makes isoScope wait for user response (see UIRESUME)
% uiwait(handles.figure1);

function mypostcallback(obj,evd)
msi=getappdata(obj,'msi');
msi.scaleobj=msi.scaleobj.update;

function txt = myupdatefcn(~,event_obj,handles)
% Customizes text of data tips
pos = get(event_obj,'Position');
if strcmp(class(event_obj.Target),'matlab.graphics.primitive.Image')
    msi=getappdata(handles.figure1,'msi');
    min_x=min(msi.metadata(:,1));
    min_y=min(msi.metadata(:,2));  
    X=round(pos(1)/msi.res*1000);
    Y=round(pos(2)/msi.res*1000);
    id=find(msi.metadata(:,1)==X & msi.metadata(:,2)==Y);  %find id 
          if ~isempty(id)               
            msi.currentID=id;
            sig_max=max(msi.idata);
            sig_current=msi.idata(id);
          end    
 txt = {['X=',num2str(X),',Y=',num2str(Y)],...
       ['Sig = ',num2str(sig_current,'%.2g')],...
       [num2str(sig_current/sig_max*100,'%.1f'),'%']};
   
 if isfield(msi.data,'name')
        name=msi.data(id).name;
      txt = {[name],...
       ['Sig = ',num2str(sig_current,'%.3g')],...
       [num2str(sig_current/sig_max*100,'%.1f'),'%']};   
  end
   drawnow();   

elseif strcmp(class(event_obj.Target),'matlab.graphics.chart.primitive.Stem')    
  txt = {['X: ',num2str(pos(1))],...
       ['Y: ',num2str(pos(2),'%.2g')]};
end
txt=strrep( txt , '_' , '-' ) ; %disable underscore in txt

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
           mkdir tmp_
           for i=1:length(fname)
            copyfile(fname{i},'tmp_');
            [~,name,ext]=fileparts(fname{i});
            fn{i}=fullfile(pwd,'tmp_',[name,ext]);
           end
           fname=fn;
        %   msgbox('A copy of the data is made in the tmp folder, please manually delete it afterwards','Note!')
       end
       
      %-----------
    handles.text_status1.String='Loading...';
    handles.text_status1.BackgroundColor=[1,0,0];
    drawnow();
        [O,~]=msi_merge(fname);
    handles.figure1.Name=O.msi.fname;
        
     if exist('tmp_','dir')  %delete the temp folder including files if exist
          handles.text_status1.String='deleting tmp_...';drawnow();
          rmdir tmp_ s      
     end
    
    cla(handles.axes1);
    cla(handles.axes2);
    handles.axes1.XLimMode='auto';
    handles.axes1.YLimMode='auto';
    cla(handles.ax1);
    cla(handles.ax2);
    cla(handles.ax3);
    pk=getappdata(handles.figure1,'pk'); %pk can exist without msi
    msi=O.msi;    
    if max([msi.data.x])>100
        padding=[10,10,10,10]; % set padding
    elseif max([msi.data.x])>20
        padding=[2,2,2,2]; 
    else      
         padding=[1,1,1,1];
    end
    msi.padding=padding;
    msi.pk=pk;
    msi.cmap=parula;      
    msi=msi_get_metadata(msi,padding); %initialize, get metadata,ref and alphadata
    msi=msi_get_idata(msi,pk); % get 1d intensity data from mypk
    msi=msi_update_imgdata(msi); % update to get 2d imgdata

    msi.wdata=ones(size(msi.imgdata));%initialize weight=1 for each pixel
    msi.seg=ones(length(msi.idata),1);
    msi.select_idata_type=0; 
    msi.isoidata=[];
    msi.currentID=1;  
    msi=msi_get_ms(msi); 
    
    dt=msi.data;
    for i=1:length(dt)
        TIC(i)= double(sum(dt(i).peak_sig));
    end
    msi.TIC=TIC';
    msi.imax=[];

   colorscale=[0,1];  %adjust color brightness
   msi.CLim=(max(msi.idata)+1e-9)*colorscale;
   msi.bgColor=get(handles.bt_bcolor,'BackgroundColor');
    
   % axes1 ----------initial drawing of image
    handles.imobj=msi_create_imobj(handles.axes1,msi);
    handles.imobj.ButtonDownFcn = @axes1_ButtonDownFcn;% ----for ButtonDown action on the image
    handles.axes1.Toolbar.Visible='on';  

   % ax1   
   handles.msobj=stem(handles.ax1,msi.ms.XData,msi.ms.YData,'.'); %-------------MS object
        xlabel(handles.ax1,'m/z');
        ylabel(handles.ax1,'signal');
   handles.ax1.Toolbar.Visible='on'; 
   
   handles.msobj_zoom=stem(handles.ax1_zoom,msi.ms.XData,msi.ms.YData,'.'); %-------------MS object
        xlabel(handles.ax1_zoom,'m/z');
        ylabel(handles.ax1_zoom,'signal');
        xlim(handles.ax1_zoom,[msi.pk.mz_-2,msi.pk.mz_+2]);
   handles.ax1_zoom.Toolbar.Visible='on'; 

   %ax2
   handles.errobj=histogram(handles.ax2,msi.errdata(msi.errdata>-99));%-----------err object
        xlim(handles.ax2,[-pk.ppm,pk.ppm]);
        xlabel(handles.ax2,'ppm');
        ylabel(handles.ax2,'frequency');
   handles.ax2.Toolbar.Visible='on'; 
   handles.errDistobj=plot(handles.ax2_dist,msi.errdata,'.');
        xlim(handles.ax2_dist,[0,size(msi.idata,1)]);

   %ax3     
   handles.sigobj=plot(handles.ax3,msi.idata,'.');
        xlim(handles.ax3,[0,size(msi.idata,1)]); 
        xlabel(handles.ax3,'scan ID(time)');
        ylabel(handles.ax3,'signal') 
   handles.ax3.Toolbar.Visible='on';
   handles.sigHistobj= histogram(handles.ax3_hist,msi.idata,'Orientation','horizontal');
   xlabel(handles.ax3_hist,'frequency');

   cm = uicontextmenu(handles.figure1); %right click contextmenu
     m1 = uimenu(cm,"Text","Save data as csv","MenuSelectedFcn",{@saveData,handles.figure1});
   handles.ax3.UIContextMenu=cm;

   %ax4
   sig=msi.idata;         
   handles.pieobj=pie(handles.ax4,[length(find(sig==0)),length(find(sig>0))]);   
   msi.cursorobj=Pcursor(handles.axes1,msi);   
   msi.scaleobj=Pscale(handles.axes1);  %draw the scalebar on axes1
   msi.scaleobj.visible='Off';   
   msi.scaleobj.update;
   msi.handles=handles;
   setappdata(handles.figure1,'msi',msi);
    handles.text_status1.String='Ready...';
    handles.text_status1.BackgroundColor=[0,1,0];
    
   handles.bt_enrich.Enable='on';
   handles.bt_addweight.Enable='on';
   handles.bt_customized.Enable='on';
   handles.bt_TIC.Enable='on';
  
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
  handles.pb_master.Enable=true;
  handles.pb_seg.Enable=true;

  %initialize roi
  myroi=ROI(handles.axes1,'rectangle',msi.ref,'yb','nodraw');
  myroi.plt=images.roi.Rectangle(handles.axes1);
  myroi.plt.FaceAlpha=0;
  myroi.tag='ALL';
      xx=handles.axes1.XLim;
      yy=handles.axes1.YLim;
  myroi.plt.Position=[xx(1),yy(1),xx(2)-xx(1),yy(2)-yy(1)];
  myroi.plt.Visible='off';                 
  myroi=myroi.update();
  [myroi.sig,myroi.coverage]=myroi.get_signal(msi.imgdata);
  roigrp(1)=myroi;
  update_roitable(handles.uitable2,roigrp);
  setappdata(handles.figure1,'roigrp',roigrp);
  update_roigrp(handles);
end
    
function saveData(src,event,f)
obj=f.CurrentObject.Children;
msi=getappdata(f,'msi');
meta=msi.metadata(obj.XData,:);
output=[meta,obj.XData',obj.YData'];


[filename,path]=uiputfile('*.csv');
fname=fullfile(path,filename);
if isequal(filename,0)
    disp('User selected Cancel');
else
    xlswrite(fname,output);
    writematrix(output,fname)
end


% --------------------------------------------------------------------
function pb_plot_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to pb_plot (see GCBO)dd
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.text_status1.String='Ready';
handles.text_status1.BackgroundColor='g';

msi=getappdata(handles.figure1,'msi');
roigrp=getappdata(handles.figure1,'roigrp');
pk=getappdata(handles.figure1,'pk');
if ~isfield(msi,'idata') 
    return
end
if msi.select_idata_type==10       
       msi.idata=msi.TIC;
       
elseif msi.select_idata_type==-1 %customized, use the current idata
      
else
  if ~isempty(msi.isoidata) 
    if handles.bt_abs.Value && ~handles.bt_isocor.Value
        msi=msi_select_idata(msi,pk.M_,1);
    elseif handles.bt_ratio.Value && handles.bt_isocor.Value
      msi=msi_select_idata(msi,pk.M_,2);
    elseif handles.bt_fraction.Value && handles.bt_isocor.Value
      msi=msi_select_idata(msi,pk.M_,3);
    elseif handles.bt_abs.Value && handles.bt_isocor.Value
      msi=msi_select_idata(msi,pk.M_,5);  
    elseif handles.bt_ratio.Value && ~handles.bt_isocor.Value
      msi=msi_select_idata(msi,pk.M_,6);
    elseif handles.bt_fraction.Value && ~handles.bt_isocor.Value
      msi=msi_select_idata(msi,pk.M_,7);
    end
  else
    msi=msi_get_idata(msi,pk); %get idata from pk
  end
end
    msi=msi_update_imgdata(msi); %get imgdata
    msi=msi_get_imgC(msi,handles); %get color image
    imgdata=msi.imgdata;

    if msi.select_idata_type==3 || msi.select_idata_type==7
      imgdata=msi.imgdata./msi.wdata;  %apply weight to fraction image or customized ONLY!!
    end 
    handles.imobj.CData=imgdata; %update image object CData;
    handles.pn1.SelectedChild = 1;
    %ax1 update
    handles.msobj.XData=msi.ms.XData; %update ms
    handles.msobj.YData=msi.ms.YData;

    handles.msobj_zoom.XData=msi.ms.XData; %update ms
    handles.msobj_zoom.YData=msi.ms.YData;
    xlim(handles.ax1_zoom,[msi.pk.mz_-2,msi.pk.mz_+2]);  
    
    %ax2 update
    ind1=roigrp(handles.list2.Value).BW.*msi.imgScanIDdata; % idata(index) subset
    ids=ind1(:);ids=ids(ids>0);
    errdata=msi.errdata(ids);
    handles.errobj.Data=errdata(errdata>-99); %update errdata
    handles.errobj.BinMethod='auto';      %update histogram
           xlim(handles.ax2,[-pk.ppm,pk.ppm]);
    handles.errDistobj.XData=ids;
    handles.errDistobj.YData=errdata;
           ylim(handles.ax2_dist,[-pk.ppm,pk.ppm]);

    %ax3 update
    ind1=roigrp(handles.list3.Value).BW.*msi.imgScanIDdata; % idata(index) subset
    ids=ind1(:);ids=ids(ids>0);
    handles.sigobj.XData=ids;
    handles.sigobj.YData=msi.idata(ids); %update 1-D signal
    handles.sigHistobj.Data=msi.idata(ids);  %update sigHistobj
                       

    cla(handles.ax4,'reset')
    pie(handles.ax4,[length(find(msi.idata==0)),length(find(msi.idata>0))]); %update pie plot
    
    roigrp=getappdata(handles.figure1,'roigrp');
   if ~isempty(roigrp)
       for i=1:length(roigrp)           
        [roigrp(i).sig,roigrp(i).coverage]=roigrp(i).get_signal(msi.imgdata); %update roi signal
       end
       setappdata(handles.figure1,'roigrp',roigrp);
       update_roitable(handles.uitable2,roigrp) %update roi table
   end
msi.errscore=err2score(msi.errdata,pk.ppm);
setappdata(handles.figure1,'msi',msi);
update_clim(hObject, eventdata, handles);  %update clim of the image plot
assignin('base','handles',handles);

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
Msi.res=msi.res;
msi=Msi;
[filename,filepath]=uiputfile('*.mat','save to file');
fname=fullfile(filepath,filename);
if isequal(filename,0)
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
gui_savedialog(handles);

function pb_overlay_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to pb_overlay (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
gui_rroi;
% [filename,filepath]=uigetfile('*.png;*.jpg;*.tif','Load Microscopy image');
% fname=fullfile(filepath,filename);
% if isequal(fname,0)
%    disp('User selected Cancel');
% else   
%     fixed=imread(fname);
% end
% msi=getappdata(handles.figure1,'msi');
% moving=msi2rgb(msi.imgdata,msi.alphadata,msi.cmap,[handles.slider1.Value,handles.slider2.Value],handles.axes1.Color);
% [mp,fp] = cpselect(moving,fixed,'Wait',true);
% 
% t = fitgeotrans(mp,fp,'affine');
% Rfixed = imref2d(size(fixed));
% movingR = imwarp(moving,t,'nearest','OutputView',Rfixed);
% R.moving=moving;
% R.fixed=fixed;
% R.movingR=movingR;
% R.Rfixed=Rfixed;
% R.t=t;
% handles.imobj.CData=R.movingR;
% handles.imobj.AlphaData=0.5;
% I2 = imagesc(handles.axes1,'CData',R.fixed);
% I2.AlphaData=0.5;
% I2.XData=handles.imgobj.XData;
% I2.YData=handles.imobj.YData;
% handles.axes1.DataAspectRatioMode='auto'£»
% handles.R=R;
% guidata(hObject, handles);

function pb_seg_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to pb_seg (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
msg='Clustering will be based on the peak list as shown in the table, and it will update the itensity matrix. would you like to proceed?'; 
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

handles.text_status1.String='Clustering in process...';
drawnow();  
if size(msi.imax,2)~=n  % calculate imax
    msi=msi_get_imax(msi,pks.sdata); %update imax.
    msi=msi_get_local_stat(msi,1); % updates local stat for ROIs
end

if p>0
 imax_pc=pca(msi.imax'); %pca reduced 
 imax_pc=imax_pc(:,1:p); %top p 
else
 imax_pc=msi.imax;
end

idx=kmeans(imax_pc,k);
msi.idata=idx;
msi.seg=idx;
msi=msi_update_imgdata(msi);
img=msi.imgdata;
img(isnan(img))=0; %replace nan with 0 
figure,imshow(label2rgb(img))
disp_segment(msi,handles.axes3);

msi=msi_get_local_stat(msi,2); toc %update R and S

handles.text_status1.String='Ready';
handles.text_status1.BackgroundColor='g';
handles.pn1.SelectedChild = 5;

%assign cluster to each peak;---testing
% for i=1:size(a,2)
%     tbl=table(a(:,i),idx);
%     tblstats = grpstats(tbl,"idx");
%     [~,lb(i)]=max(tblstats{:,3}); 
% end
setappdata(handles.figure1,'msi',msi);
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
msi=msi_get_imgC(msi,handles); %get color image
setappdata(handles.figure1,'msi',msi);

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
     msi.select_idata_type=0;
     setappdata(handles.figure1,'msi',msi); 
     handles.bt_TIC.Value=0;
     bt_toggle_Callback(handles.bt_abs, eventdata, handles); 
     set(handles.bt_isocor,'Enable','off','Value',0,'BackgroundColor',[.94,.94,.94]);
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
x=round(coordinates(1,1)/msi.res*1000);
y=round(coordinates(1,2)/msi.res*1000);
id=find(msi.metadata(:,1)==x & msi.metadata(:,2)==y);
sig=msi.idata(id);
if isempty(sig)
    sig=nan;
    msi.handles.text_status2.String=['N/A'];
else
msi.handles.text_status2.String=['X = ',num2str(x), ';  Y = ',num2str(y),'; ',' scan ID = ',num2str(id),...
    ' [',num2str(msi.data(id).x),', ',num2str(msi.data(id).y),'] ;  Sig = ', num2str(sig,'%.3g')];
msi.handles.text_status2.FontSize=12;
end
if ~isempty(id)
msi.cursorobj.Visible='on';
msi.currentID=id;%setappdata(gcf,'msi',msi);
%update ax1
msi=msi_get_ms(msi); %update ms
msi.handles.msobj.XData=msi.ms.XData;
msi.handles.msobj.YData=msi.ms.YData;

msi.handles.msobj_zoom.XData=msi.ms.XData; %update ms
msi.handles.msobj_zoom.YData=msi.ms.YData;
xlim(msi.handles.ax1_zoom,[msi.pk.mz_-2,msi.pk.mz_+2]); 

else
msi.cursorobj.Visible='off'; 
end
msi.cursorobj.update(msi);
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
        [myroi.sig,myroi.coverage]=myroi.get_signal(msi.imgdata);  
        %myroi.plt.Color='c';myroi.plt.StripeColor='r';
    elseif id(1,2)==1 %change ROI name
        prompt = {'Enter new roi name:'};
        answer = inputdlg(prompt,'Input',[1 45],{myroi.tag});
        myroi.tag=answer{1};
    elseif id(1,2)==6  %update ROI notes
        prompt = {'update roi notes:'};
        answer = inputdlg(prompt,'Input',[1 45],{myroi.note});
        myroi.weight=answer{1};
        %myroi.sig=myroi.get_signal(msi.imgdata);  
    elseif id(1,2)==7   %delete ROI   
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
    pks_h=getappdata(handles.figure1,'pks_h'); %push pks into pks_h
    pks_h=[pks_h,pks];
    setappdata(handles.figure1,'pks_h',pks_h);
    handles.bt_restorepks.Enable='on';
    dt=pks.data;
    set_uitable_color(handles,dt,0);    
    ev.Indices=[1,1]; %click on the first peak
    uitable1_CellSelectionCallback(hObject, ev, handles);    
end

function bt_savepks_Callback(hObject, eventdata, handles)
[filename,filepath]=uiputfile('*.xlsx','Save pks file');
file=fullfile(filepath,filename);
if isequal(filename,0)
   disp('User selected Cancel');
else
   pks=getappdata(handles.figure1,'pks');
   writetable( struct2table(pks.sdata),file); %save pks to excel file
 
end

function bt_restorepks_Callback(hObject, eventdata, handles)
% pks=getappdata(handles.figure1,'pks');
% pks=msi_loadpks(handles,pks.filename);  %pks is a struct
pks_h=getappdata(handles.figure1,'pks_h');
if length(pks_h)>1
    pks=pks_h{end-1};
    pks_h(end)=[];
    setappdata(handles.figure1,'pks_h',pks_h);
    setappdata(handles.figure1,'pks',pks);
    if length(pks_h)==1
        handles.bt_restorepks.Enable='off';
    end
    dt=pks.data;
    handles.uitable1.Data=dt;
    handles.uitable1.ColumnName=pks.header;
    set_uitable_color(handles,dt,0);    
    ev.Indices=[1,1]; %click on the first peak
    uitable1_CellSelectionCallback(hObject, ev, handles); 
end    

    


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
[myroi.sig,myroi.coverage]=myroi.get_signal(msi.imgdata);
roigrp=[roigrp;myroi];
setappdata(handles.figure1,'roigrp',roigrp);

update_roitable(handles.uitable2,roigrp);
update_roigrp(handles);
drawnow();
if ~isempty(msi.imax)
 tic;msi=msi_get_local_stat(msi,1);toc
 setappdata(handles.figure1,'msi',msi); 
end
handles.text_status1.String='Ready...';
handles.text_status1.BackgroundColor=[0,1,0];


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

function bt_customized_Callback(hObject, eventdata, handles)
msi=getappdata(handles.figure1,'msi');
prompt = {'Enter customized expression(supports +, -, /). For each item, use p followed by # in the peaklist, and optionally, add m and isotope rank (m0, by default, can be omitted), for example: (p1m1+p2m1)/(p3+p4).If 13C is selected, p1m1 means metabolite peak1 with one 13C labeled.  Use p0 to represent TIC. p1/p0 means the image of metabolite peak1 normalized by TIC '};
dlgtitle = 'Customized image output request';
dims = [1 70];
definput = {''};
exp = inputdlg(prompt,dlgtitle,dims,definput);
if ~isempty(exp)
 if ~isempty(exp{1})
    dt=exp2idata(exp{1},handles);
    if isempty(dt)
      handles.text_status1.String=['error:',exp{1}];
      handles.text_status1.BackgroundColor=[1,0,0];
    else
 msi.idata=dt;
 msi.select_idata_type=-1; %put a flag
%  msi=msi_update_imgdata(msi);
%  handles.imobj.CData=msi.imgdata./msi.wdata;
 setappdata(handles.figure1,'msi',msi);
% update_clim(hObject, eventdata, handles);
pb_plot_ClickedCallback(hObject, eventdata, handles);
 handles.text_status1.String=['Custom: ',exp{1}];
 handles.text_status1.BackgroundColor=[0,1,1];
    end
 end
end

function bt_TIC_Callback(hObject, eventdata, handles)
msi=getappdata(handles.figure1,'msi');
msi.select_idata_type=10; %idata type for TIC
setappdata(handles.figure1,'msi',msi);
pb_plot_ClickedCallback(hObject, eventdata, handles);
handles.text_status1.String='TIC';
handles.text_status1.BackgroundColor=[0,1,1];

function bt_loadroi_Callback(hObject, eventdata, handles)
[filename,filepath]=uigetfile({'*.ROI; *.rroi','open roi files (*.roi, *.rroi)'});
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

if isfield(O,'roigrp') %ROI created directly in isoscope
    roigrp=O.roigrp;
  for i=1:length(roigrp)
    roigrp(i).plt.Parent=handles.axes1;
    roigrp(i).ax=handles.axes1;
  end
  update_roitable(handles.uitable2,roigrp);
  setappdata(handles.figure1,'roigrp',roigrp);
elseif isfield(O,'roigrpR') %ROI created with overlay
    roigrp=roimapping(O.roigrpR,O.R);
    msi=getappdata(handles.figure1,'msi');
  for i=1:length(roigrp)
    [x,y]=intrinsicToWorld(msi.ref,roigrp(i).plt.Position(:,1),roigrp(i).plt.Position(:,2));
    roigrp(i).plt.Position=[x,y];
    roigrp(i).ref=msi.ref;
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
if isequal(filename,0)
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
msi=getappdata(handles.figure1,'msi');
msi=msi_get_imgC(msi,handles); %get color image
setappdata(handles.figure1,'msi',msi);


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
 handles.bt_TIC.Value=0;
 drawnow();          
msi=getappdata(handles.figure1,'msi');
pk=getappdata(handles.figure1,'pk');
msi=msi_get_isoidata(msi,pk);  %calcualte isodata
%------------------ show isoView,quality control histogram
  n=size(msi.isoidata.idata,2);
  p = handles.isoView;  
  for i=1:n
    h{i,1}=subplot(n,2,i*2-1,'Parent', p);
    histogram(h{i,1},msi.isoidata.idata(:,i),100);
    legend(h{i,1},msi.pk.MList_{i})
    
    h{i,2}=subplot(n,2,i*2,'Parent', p);
    dt=msi.isoidata.idata_err(:,i);
    histogram(h{i,2},dt(dt>-99));
    ppm=msi.pk.ppm;
    xlim(h{i,2},[-ppm,ppm]);
    legend(h{i,2},msi.pk.MList_{i})
  end    
    title(h{1,1},'signal distribution');
    title(h{1,2},'error distribution');
%------------------------------------ isoview end   
  item=0;
  for j=1:size(msi.isoidata.idata,2)
     item=item+1;
     pk.M_=j;
        pks_{item,1}=[pk.name,'_M',pk.MList_{j}];
        pks_{item,2}=pk.formula;
        pks_{item,3}=num2str(pk.mz_);          
     msi=msi_select_idata(msi,j,1); %1: intensity
handles.bt_isocor.Enable='on';
handles.bt_isocor.Value=1;
handles.bt_isocor.BackgroundColor='y';

handles.bt_abs.Enable='on';
handles.bt_abs.Value=1;
handles.bt_ratio.Enable='on';
handles.bt_fraction.Enable='on';
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


function bt_toggle_Callback(hObject, eventdata, handles)
msi=getappdata(handles.figure1,'msi');
pk=getappdata(handles.figure1,'pk');
msi.select_idata_type=0;
setappdata(handles.figure1,'msi',msi);
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
elseif strcmp(hObject.String,'isocor')
    if handles.bt_isocor.Value == 1
      set(handles.bt_isocor,'BackgroundColor','y'); 
    else
      set(handles.bt_isocor,'BackgroundColor',[.94,.94,.94]); 
    end
        pb_plot_ClickedCallback(hObject, eventdata, handles);
else
    set(h1,'Enable','off');
    set(h2,'Enable','off');
    set(h3,'Enable','off');
end


function bt_targeted_Callback(hObject, eventdata, handles)
handles.text_status1.String='Targeted ...';
handles.text_status1.BackgroundColor=[1,0,0];
drawnow();

% msi=getappdata(handles.figure1,'msi');
% sz=length([msi.data]);
% mz_out=[];
% sampling=min(500,size(msi.idata,1));
% ppm=str2num(handles.edit_ppm.String);
% answer = inputdlg({'Enter #of samplings:'},'Input',[1,35],{num2str(sampling)});
% n=str2num(answer{1});
% ids=randperm(sz,n);
% 
% pks=getappdata(handles.figure1,'pks');
% dt=pks.data;
% matrix=zeros(size(dt,1),n);
% H=1.00727646677;
% pk=getappdata(handles.figure1,'pk');
% for i=1:n  % loop over sampling points
%   ms1=msi.data(ids(i)).peak_mz(:);
%   ms2=msi.data(ids(i)).peak_sig(:);
%   for j=1:size(dt,1) %loop over peak list
%      mz= dt{j,3}+H*pk.z;     
%      [matrix(j,i),~,err(j,i)] = ms2sig(ms1,ms2,[mz-mz*ppm*1e-6,mz+mz*ppm*1e-6]);      
%   end
% end
% corref=corr(matrix', matrix');
% for i=1:size(dt,1)
%  dt{i,4}=nnz(matrix(i,:))/n;
% end
% 
% header=handles.uitable1.ColumnName;
% header(4)={'coverage%'};
% handles.uitable1.Data=dt;
% handles.uitable1.ColumnName=header;
% handles.popup_sort.String=['none';header(:)];
% set_uitable_color(handles,dt,4);
% pks.data=dt;
% pks.ordering=1:size(dt,1);
% pks.corref=corref;
% setappdata(handles.figure1,'pks',pks);
%------ calculate intensity matrix;
 msi=getappdata(handles.figure1,'msi');
 pks=getappdata(handles.figure1,'pks');
 dt=pks.data;
 [msi,err]=msi_get_imax(msi,pks.sdata);  %  get intensity matrix ------
 msi=msi_get_local_stat(msi);  %  get local statistics ---------
 
 for i=1:size(dt,1)
  dt{i,4}=nnz(msi.imax(:,i))/size(msi.imax,1);
 end

header=handles.uitable1.ColumnName;
header(4)={'coverage'};
handles.uitable1.Data=dt;
handles.uitable1.ColumnName=header;
handles.popup_sort.String=['none';header(:)];
set_uitable_color(handles,dt,4);

pks.data=dt;
T=cell2table(dt);
T.Properties.VariableNames = header;
pks.header=header';
pks.sdata=table2struct(T);
pks.ordering=1:size(dt,1);
pks.corref=corr(msi.imax, msi.imax);
setappdata(handles.figure1,'msi',msi);
setappdata(handles.figure1,'pks',pks);
pks_h=getappdata(handles.figure1,'pks_h');
pks_h{end}=pks;
setappdata(handles.figure1,'pks_h',pks_h);

 %----------done
handles.text_status1.String='Ready';
handles.text_status1.BackgroundColor=[0,1,0];

figure,boxplot(err,'Notch','on')
title('mass error (ppm)')
xticklabels(pks.data(:,1))
ylabel('ppm error')



function bt_untargeted_Callback(hObject, eventdata, handles)
handles.text_status1.String='Untargeted ...';
handles.text_status1.BackgroundColor=[1,0,0];
drawnow();

pk=getappdata(handles.figure1,'pk'); 
pk.z=handles.popup_z.Value-3; %z pass over
pk.addType=1;
setappdata(handles.figure1,'pk',pk);     
update_pk(handles,pk); 

msi=getappdata(handles.figure1,'msi');
roigrp=getappdata(handles.figure1,'roigrp');
sz=length([msi.data]);
mz_out=[];
sampling=min(500,size(msi.idata,1)); %default subsampling size
ppm=str2num(handles.edit_ppm.String);

answer = inputdlg({'Enter #of subsamplings:','noise level cutoff (n fold of baseline sig)'},'Input',[1,55],{num2str(sampling),'3'});
if isempty(answer)
    handles.text_status1.String='Ready';
    handles.text_status1.BackgroundColor=[0,1,0];
    return
end
subsampling=str2num(answer{1});
fold=str2num(answer{2});
handles.text_status1.String='Untargeted...MS merge';drawnow();
mz_out=ms_merge_bat(msi,1:sz,min(sz,subsampling),fold); %MS merge
msi.mz_out=mz_out;


H=1.00727646677;
mz_nt=mz_out(:,1)-H*pk.z;
for i=1:length(mz_nt)
     pks.sdata(i).m_z=mz_nt(i);
     pks.sdata(i).Name=num2str(i,['Un','-%04d']);
     pks.sdata(i).Formula=[];
     pks.sdata(i).coverage=[];
end
 %--------calculate imax & local stat
 handles.text_status1.String='Untargeted...Calculate I matrix';drawnow();
 msi=msi_get_imax(msi,pks.sdata);  %  get intensity matrix ------
 handles.text_status1.String='Untargeted...get local stat';drawnow();
 msi=msi_get_local_stat(msi);  %  get local statistics ---------
 for i=1:length(pks.sdata)
    pks.sdata(i).coverage=nnz(msi.imax(:,i))/size(msi.imax,1);
    pks_(i).mz= pks.sdata(i).m_z;
    pks_(i).id=i;
 end

data=cell(length(mz_nt),5);
data(:,1)=cellstr({pks.sdata.Name});
data(:,3)=num2cell([pks.sdata.m_z]);
data(:,4)=num2cell([pks.sdata.coverage]);

%set(handles.uipanel2,'Title', ['#pks : ',num2str(size(data,1))]);

% matrix=zeros(length(mz_nt),length(msdata));
% for i=1:length(mz_nt)
%     pks_(i).mz=mz_nt(i);
%     pks_(i).id=i;
%     %calculate the intensity matrix for filtered good peaks    
%     for j=1:length(msdata)
%        mz_=mz_out_short(i,1);
%        dm=ppm*1e-6*mz_out_short(i,1);
%       mz_range=[mz_-dm,mz_+dm];  
%     [b,c]=findInSorted(msdata(j).mz,mz_range);
%     tp=b:c;
%       if ~isempty(tp)
%          matrix(i,j)=max(msdata(j).sig(tp));
%       end
%     end
% end

corref=corr(msi.imax, msi.imax);
% db search
handles.text_status1.String='dbase searching';drawnow();
dbase=readtable('db_master.xlsx');
dbase=table2struct(dbase);
info=msi_find_dbase(dbase,pks_,ppm*1e-6,0);  %dbase formula matching
data(:,2)={info.formula};

% adduct finder
handles.text_status1.String='finding adduct';drawnow();
load adduct
[~,annotation]=msi_find_adduct(pks_,adduct,ppm*1e-6);  %adduct finder
data(:,5)=annotation;

%show table, put color
 header={'Name','Formula','m_z','coverage','annotation'};
 handles.uitable1.ColumnName=header;
 handles.uitable1.Data=data;
 handles.popup_sort.String=['none';header(:)];
 handles.popup_sort.Value=1;
 set_uitable_color(handles,data,4);
 T=cell2table(data);
 T.Properties.VariableNames = header;
 pks.header=header;
 pks.sdata=table2struct(T);
 pks.data=data;
 pks.pkid=1;
 pks.ordering=1:size(data,1);
 pks.corref=corref;
 setappdata(handles.figure1,'pks',pks); %update pks
 pks_h=getappdata(handles.figure1,'pks_h');
 pks_h=[pks_h,pks];
 setappdata(handles.figure1,'pks_h',pks_h);
 handles.bt_restorepks.Enable='on';
 %----------done
handles.text_status1.String='Ready';
handles.text_status1.BackgroundColor=[0,1,0];
%handles.bt_targeted.Enable='off';

  ev.Indices=[1,1]; %event data in uitable selected row#
  uitable1_CellSelectionCallback(hObject, ev, handles); %click uitable
setappdata(handles.figure1,'msi',msi);

function bt_select_Callback(hObject, eventdata, handles)
pks=gui_select(handles); % call peak selection gui **********
pks_h=getappdata(handles.figure1,'pks_h');
pks_h=[pks_h,pks];
setappdata(handles.figure1,'pks',pks);
setappdata(handles.figure1,'pks_h',pks_h);
set(handles.uitable1,'ColumnName',pks.header);
set(handles.uitable1,'data',pks.data);
set_uitable_color(handles,pks.data,4);
handles.popup_sort.Value=1;
handles.popup_sort.UserData=1;
ev.Indices=[1,1];
uitable1_CellSelectionCallback(hObject, ev, handles);

function bt_batch1_Callback(hObject, eventdata, handles)
handles.bt_TIC.Value=0;
 roigrp=getappdata(handles.figure1,'roigrp');
 if isempty(roigrp)
     msgbox('You need at least one ROI in order to proceed, please Click ROI tool first','warning!')
     return
 end

pks=getappdata(handles.figure1,'pks');
dt=pks.data;
ind=1:size(dt,1);

folder=fullfile('output',datestr(now,'yyyy-mm-dd HH_MM')); %create a folder
mkdir(folder);
f=figure('units','normalized','InvertHardcopy', 'off','visible','off'); %create a figure
ax=axes(f);
msi=getappdata(handles.figure1,'msi');
img_out=msi_create_imobj(ax,msi);

f.OuterPosition=[0 0 1 1];
for i=1:length(ind)
  ev.Indices=[ind(i),1]; %event data in uitable selected row#
  uitable1_CellSelectionCallback(hObject, ev, handles); %click uitable
  drawnow()
  msi=getappdata(handles.figure1,'msi');
  pk=getappdata(handles.figure1,'pk');
  
  img_out.CData=msi.imgC;
  ax.CLim=handles.axes1.CLim;
  ax.Color=handles.axes1.Color;
  title(ax,[pk.name,'-M',num2str(pk.M),' (m/z=',num2str(pk.mz_),')'])
  colorbar
  print(f,fullfile(folder,['abs_','pk',num2str(i),'-',matlab.lang.makeValidName(pk.name),'-M',num2str(pk.M)]),'-dpng')  
  
  iongrp(i).idata=msi.idata;
  iongrp(i).imgdata=msi.imgdata;
  iongrp(i).imgC=msi.imgC;
  iongrp(i).CLim=handles.axes1.CLim;
  iongrp(i).name=pk.name;
  iongrp(i).mz=pk.mz_;
  iongrp(i).errscore=msi.errscore;
  for j=1:length(roigrp)           
         sig(i,j)=roigrp(j).get_signal(msi.imgdata); %update roi signal 
         ind1=roigrp(j).BW.*msi.imgScanIDdata; % idata(index) subset
         ids=ind1(:); ids=ids(ids>0);
         %idx{j}=ids;         
         iongrp(i).roi(j).tag=roigrp(j).tag;
         iongrp(i).roi(j).idx=ids;
         iongrp(i).roi(j).idata=msi.idata(ids);
         iongrp(i).roi(j).ave=sig(i,j);
  end
end

msi.iongrp=iongrp;
save('iongrp.mat','iongrp','-v7.3');

T1=[pks.header(1:3),{roigrp.tag}];
T2=[pks.data(:,1:3),num2cell(sig)];
T=cell2table([T1;T2]);
meta=msi.metadata;
%T_ions=cell2table([pks.data(:,1)';num2cell([iongrp.idata])]);
for j=1:length(roigrp)
    ids=iongrp(i).roi(j).idx;
    mat=meta(ids,:);
    for i=1:length(iongrp)
        mat=[mat,iongrp(i).roi(j).idata];
    end
    Tsub{j}=cell2table(num2cell(mat));
    Tsub{j}.Properties.VariableNames=matlab.lang.makeValidName([{'X','Y'},pks.data(:,1)']);
end
%---------save excel
if strcmp(questdlg('Export excel file?','ROI intensities?','Yes','No','Yes'),'Yes')
 [file, path]=uiputfile('*.xlsx');
 filename=fullfile(path,file);
 if isequal(filename,0)
    disp('User selected Cancel');
 else
     if isfile(filename)
         delete(filename)
     else
     end
    writetable(T,fullfile(path,file),'WriteVariableNames',false,'Sheet',1);
    for i=1:length(roigrp)
     writetable(Tsub{i},fullfile(path,file),'WriteVariableNames',true,'Sheet',roigrp(i).tag);
    end
 end
end
n=floor(sqrt(i));
m=ceil(i/n);
%------------------save images
if strcmp(questdlg('Export group images?','','Yes','No','Yes'),'Yes')
    definput = {'20','hsv'};
    answer = inputdlg({'Enter #Row:','Enter #Column:','title verbose level(0-3)','fontsize'},'Input',[1,35],{num2str(n),num2str(m),'2','8'});
   nRows=str2num(answer{1});
   nCols=str2num(answer{2});
   nTitle=str2num(answer{3});
   fontsize=str2num(answer{4});
  fig=0;
handles.text_status1.String='exporting figures ...';
handles.text_status1.BackgroundColor=[1,0,0];
drawnow();
 
  for i=1:length(ind)
   md=mod(i,nRows*nCols);
     if md==1        
        f=figure('units','normalized','outerposition',[0 0 1 1],'visible','off');
        fig=fig+1;        
     elseif md==0
         md=nRows*nCols;
     end
     ax=subplot(nRows,nCols,md,'parent',f); 
    % msi_ini_draw(ax,info(i).imgdata,msi.ref,msi.alphadata,handles.axes1.Colormap,info(i).CLim,'k',handles.axes1.XLim,handles.axes1.YLim);
    imshow(iongrp(i).imgC,'parent',ax)
    ax.Colormap=handles.axes1.Colormap;
    ax.CLim=iongrp(i).CLim;
    colorbar(ax)
    
    t1=iongrp(i).name;
    t2=['m/z = ',num2str(iongrp(i).mz)];
    t3=['score=',num2str(iongrp(i).errscore)];
    
    if nTitle==1
        title(ax,{t1},'fontsize',fontsize);
    elseif nTitle==2
        title(ax,{t1,t2},'fontsize',fontsize);
    elseif nTitle==3
        title(ax,{t1,t2,t3},'fontsize',fontsize);
    end
     %drawnow();
     if md==nRows*nCols
         print(f,fullfile(folder,['outputfigure',num2str(fig,'%.3d')]),'-dpng')
     end    
  end
  if md<nRows*nCols
   print(f,fullfile(folder,['outputfigure',num2str(fig,'%.3d')]),'-dpng')
  end
handles.text_status1.String='Ready';
handles.text_status1.BackgroundColor=[0,1,0];   
drawnow();
end 
  
function bt_batch2_Callback(hObject, eventdata, handles)
handles.bt_TIC.Value=0;
roigrp=getappdata(handles.figure1,'roigrp');
if isempty(roigrp)
     msgbox('You need at least one ROI in order to proceed, please Click ROI tool first','warning!')
     return
end
folder=fullfile('output',datestr(now,'yyyy-mm-dd HH_MM'));
mkdir(folder);
handles.text_status1.String='Batch Enrichment...';
handles.text_status1.BackgroundColor=[1,0,0];

pks=getappdata(handles.figure1,'pks');  %get metabolite peak list
%pk=getappdata(handles.figure1,'pk');
% ind=gui_select(pks);
dt=pks.data;
ind=1:size(dt,1);

msi=getappdata(handles.figure1,'msi');
f=figure('units','normalized','InvertHardcopy', 'off','visible','off');
ax=axes();
img_out=msi_create_imobj(ax,msi);
f.OuterPosition=[0 0 1 1];
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
     pk.M_=j;  % select M_ 
        pks_{item,1}=[pks.sdata(i).Name,'_M',pk.MList_{j}];
        pks_{item,2}=pks.sdata(i).Formula;
        pks_{item,3}=num2str(pk.mz_);
     handles.popup_M.Value=j;   % select M 
     popup_M_Callback(hObject, eventdata, handles);
     %------------
     bt_toggle_Callback(handles.bt_abs, eventdata, handles) % click abs bt
     msi=getappdata(handles.figure1,'msi');
     img_out.CData=msi.imgC;
     ax.CLim=handles.axes1.CLim;
     ax.Color=handles.axes1.Color;     
     title(ax,[pk.name,'-M',num2str(pk.M),' (m/z=',num2str(pk.mz_),')'])
     colorbar
     print(f,fullfile(folder,['abs_','pk',num2str(i),'-',matlab.lang.makeValidName(pk.name),'-M',num2str(pk.M)]),'-dpng')   
      for k=1:length(roigrp)
        sig1(item,k)=roigrp(k).get_signal(msi.imgdata); %update roi signal  
      end
     %--------------  
     bt_toggle_Callback(handles.bt_ratio, eventdata, handles) % click ratio bt
     msi=getappdata(handles.figure1,'msi');
     img_out.CData=msi.imgC;
     ax.CLim=handles.axes1.CLim;
     title(ax,[pk.name,'-M',num2str(pk.M),' (m/z=',num2str(pk.mz_),')'])
     colorbar      
     print(f,fullfile(folder,['enrich_','pk',num2str(i),'-',matlab.lang.makeValidName(pk.name),'-M',num2str(pk.M)]),'-dpng')
       for k=1:length(roigrp)
         sig2(item,k)=roigrp(k).get_signal(msi.imgdata); %update roi signal  
       end 
       
    end
    
    msi=msi_select_idata(msi,j,3); %3. select fraction
       for k=1:length(roigrp)
         imgdata=msi.imgdata./msi.wdata; %weight added.
         sig3(i,k)=roigrp(k).get_signal(imgdata); %update roi signal  
       end 
end
sheet1=[pks_,num2cell(sig1)];
sheet2=[pks_,num2cell(sig2)];
sheet3=[pks.data(:,1:3),num2cell(sig3)];
head=[pks.header(1:3),{roigrp.tag}];
T1=cell2table([head;sheet1]);
T2=cell2table([head;sheet2]);
T3=cell2table([head;sheet3]);
handles.text_status1.String='Ready...';
handles.text_status1.BackgroundColor=[0,1,0];drawnow();
delete(f)
if strcmp(questdlg('Export excel file?','ROI enrichment?','Yes','No','Yes'),'Yes')
 [file, path]=uiputfile('*.xlsx');
filename=fullfile(path,file);
 if isequal(filename,0)
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
clipboard('copy',sprintf('%.04f \t %.02f \n',dt'));
questdlg('ms data copied to the clipboard, use [ctrl+v] to paste to excel','Hint','got it!','got it!')
gui_msview(dt); 

function bt_savefig_Callback(hObject, eventdata, handles)
H = findobj(allchild(groot), 'flat', 'UserData', 6140);
if isempty(H)
  f=figure; f.UserData=6140;
  ax1=axes(f, 'units','normalized');
  copyaxes(ax1,handles.axes1);
else
   A=getframe(handles.axes1);
   B=getframe(H.CurrentAxes);
   A=A.cdata;
   B=B.cdata;
   RA = imref2d(size(A));
   RB = imref2d(size(B));
   RB.XWorldLimits = RA.XWorldLimits;
   RB.YWorldLimits = RA.YWorldLimits;
   C=imfuse(A,RA,B,RB,'blend');
   f=figure;f.UserData=6140;
   ax1=axes(f, 'units','normalized');
   imshow(C,'parent',ax1); 
   H.UserData=0;
  
end

msi=getappdata(handles.figure1,'msi');
msi=msi_get_imgC(msi,handles);
setappdata(handles.figure1,'msi',msi);



function bt_fun1_Callback(hObject, eventdata, handles)
% msi=getappdata(handles.figure1,'msi');
% assignin('base','msi',msi);
% pks=getappdata(handles.figure1,'pks');
% msi.saved_idata{1}=msi.idata;
% msi.saved_imgdata{1}=msi.imgdata;
% msi.saved_cscale{1}=msi.cscale;
% setappdata(handles.figure1,'msi',msi);
% handles.text_status1.String='Saved to F1';
msi=getappdata(handles.figure1,'msi');
msi.idata=msi.TIC;
msi=msi_update_imgdata(msi);
handles.imobj.CData=msi.imgdata;
update_clim(hObject, eventdata, handles);
setappdata(handles.figure1,'msi',msi);


function bt_fun2_Callback(hObject, eventdata, handles)
msi=getappdata(handles.figure1,'msi');
msi.saved_idata{2}=msi.idata;
msi.saved_imgdata{2}=msi.imgdata;
msi.saved_cscale{2}=msi.cscale;
setappdata(handles.figure1,'msi',msi);
handles.text_status1.String='Saved to F2';


function bt_fun3_Callback(hObject, eventdata, handles)
% plot ratio image
% image data retrieved from msi.saved_imgdata{n}
err=0.0;
msi=getappdata(handles.figure1,'msi');
msi.idata=msi.saved_idata{1}./(msi.saved_idata{2}+err);
msi.imgdata=(msi.saved_imgdata{1}+0)./(msi.saved_imgdata{2}+err);
handles.imobj.CData=msi.imgdata;
setappdata(handles.figure1,'msi',msi);
update_clim(hObject, eventdata, handles);
handles.text_status1.String='Ratio Image: F1/F2';


function bt_fun4_Callback(hObject, eventdata, handles)
load ('worksp.mat');
%mz_out=O.mz_out;
script_filterline;
% msi=getappdata(handles.figure1,'msi');
% img=msi2mono(msi.saved_imgdata,msi.saved_cscale);
% figure,imshow(img)
% 
% msi=getappdata(handles.figure1,'msi');
% prompt = {'Enter customized expression, use p followed by peak number in the list, m followed by isotopmer rank, m0 can be omitted, for example: (p1m1+p2m1)/(p3+p4)'};
% dlgtitle = 'Customized input';
% dims = [1 50];
% definput = {''};
% exp = inputdlg(prompt,dlgtitle,dims,definput);
% msi.idata=exp2idata(exp{1},handles);
% 
% msi=msi_update_imgdata(msi);
% handles.imobj.CData=msi.imgdata;
% setappdata(handles.figure1,'msi',msi);
% update_clim(hObject, eventdata, handles);


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


% --------------------------------------------------------------------
function pb_color_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to pb_color (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
c=uisetcolor;
handles.axes1.Colormap=c2cmap([0,0,0;c]);
msi=getappdata(handles.figure1,'msi');
msi=msi_get_imgC(msi,handles); %get color image
setappdata(handles.figure1,'msi',msi);


% --------------------------------------------------------------------
function pb_layout_OnCallback(hObject, eventdata, handles)
% hObject    handle to pb_layout (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

set(handles.H1, 'Width', [10, -1, 10], 'Spacing', 2);
set(handles.V2, 'Height', [42,-2,0,0,25], 'Spacing', 2 );


% --------------------------------------------------------------------
function pb_layout_OffCallback(hObject, eventdata, handles)
% hObject    handle to pb_layout (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.H1, 'Width', [350, -1, 100], 'Spacing', 2);
set(handles.V2, 'Height', [42,-2,-0.5,-1,25], 'Spacing', 2 );




% --------------------------------------------------------------------
function pb_master_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to pb_master (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
gui_overlay_master();
