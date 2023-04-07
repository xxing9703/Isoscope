function varargout = gui_seg(varargin)
% GUI_SEG MATLAB code for gui_seg.fig
%      GUI_SEG, by itself, creates a new GUI_SEG or raises the existing
%      singleton*.
%
%      H = GUI_SEG returns the handle to a new GUI_SEG or the handle to
%      the existing singleton*.
%
%      GUI_SEG('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUI_SEG.M with the given input arguments.
%
%      GUI_SEG('Property','Value',...) creates a new GUI_SEG or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before gui_seg_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to gui_seg_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help gui_seg

% Last Modified by GUIDE v2.5 06-Apr-2023 14:48:42

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @gui_seg_OpeningFcn, ...
                   'gui_OutputFcn',  @gui_seg_OutputFcn, ...
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


% --- Executes just before gui_seg is made visible.
function gui_seg_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to gui_seg (see VARARGIN)

% Choose default command line output for gui_seg
handles.output = hObject;
msi=varargin{1};
handles.msi=msi;
cl1=[1,0,0;0,1,0;0,0,1;1,1,0;1,0,1;0,1,1;1,1,1];
cl2=[[0 0.4470 0.7410];[0.8500 0.3250 0.0980];[0.9290 0.6940 0.1250];[0.4940 0.1840 0.5560];[0.4660 0.6740 0.1880];[0.3010 0.7450 0.9330];[0.6350 0.0780 0.1840]];
cl=[cl2;cl1];
handles.figure1.UserData.seg=zeros(size(msi.metadata,1),1);
handles.figure1.UserData.cl=cl;
handles.figure1.UserData.rois=[];
handles.figure1.Resize='on';
handles.figure1.Units="normalized";
handles.figure1.OuterPosition=[0.2 0.2 0.7 0.7];
V{1} = uix.VBoxFlex( 'Parent',handles.figure1 );   %V1-top layer
p{1} = uix.Panel('Parent',V{1});  % top
p{2} = uix.Panel('Parent',V{1} ); % mid 
p{3} = uix.Panel('Parent',V{1});  % bottom
handles.text_status1 =uicontrol(p{3},'Style', 'text','string','User the color buttons (at least 2) to draw ROIs for supervised learning, Click leftside buttons to train ML models. Clicking Save button will pass the segmentation result to IsoScope','FontSize',10);

set( V{1}, 'Height', [32, -1, 38], 'Spacing', 1);

H{1} = uix.HBoxFlex( 'Parent',p{2});
p{4} = uix.Panel('Parent',H{1});  % left: ROI adding
p{5} = uix.Panel('Parent',H{1});  % middle: ax
p{6} = uix.Panel('Parent',H{1});  % right: uitable & output
set( H{1}, 'Width', [100, -2, -1], 'Spacing', 1);
handles.bgroup{1}=uix.HButtonBox( 'Parent', p{1});
handles.ax1 = axes('Units', 'normalized', 'parent',p{5}); 
H{3} = uix.VBoxFlex( 'Parent',p{6});
handles.uitable1 = uitable('Units', 'normalized', 'Parent', H{3});
handles.bgroup{2}=uix.HButtonBox( 'Parent', H{3});
   handles.bt_move = uicontrol(handles.bgroup{2},'Style', 'pushbutton','string','move','enable','off');
   handles.bt_delete = uicontrol(handles.bgroup{2},'Style', 'pushbutton','string','delete','enable','off');
   handles.bt_clear = uicontrol(handles.bgroup{2},'Style', 'pushbutton','string','reset');
handles.ax2 = axes('Units', 'normalized', 'parent',H{3});
set( H{3}, 'Height', [-1,40,-2], 'Spacing', 1);

H{2} = uix.VBoxFlex( 'Parent',p{4});
handles.pop_pentype = uicontrol(H{2},'Style','popupmenu','string',{'freehand';'polygon';'rectangle';'ellipse'});

handles.text_score  =uicontrol(H{2},'Style', 'text','string','score:','FontSize',10);

handles.bt_ML_ANN = uicontrol(H{2},'Style', 'pushbutton','string','ANN');
handles.bt_ML_SVM = uicontrol(H{2},'Style', 'pushbutton','string','SVM');
handles.bt_ML_TREE = uicontrol(H{2},'Style', 'pushbutton','string','TREE');
handles.bt_ML_cKNN = uicontrol(H{2},'Style', 'pushbutton','string','cKNN'); %cosine
handles.bt_ML_Bayes = uicontrol(H{2},'Style', 'pushbutton','string','Bayes');


p{7}=uix.Panel('Parent',H{2});
set( H{2}, 'Height', [28,36,40,40,40,40,40,-1], 'Spacing', 1);

handles.uitable1.ColumnName={'Color','Pentype','area','label'};
for i=1:14
    handles.bt_add{i} = uicontrol(handles.bgroup{1},'Style', 'pushbutton','string',num2str(i));
    handles.bt_add{i}.BackgroundColor=cl(i,:);
    handles.bt_add{i}.UserData.label=i;
    handles.bt_add{i}.UserData.rois=[];
end
set(handles.bgroup{1},'ButtonSize', [32 32],'HorizontalAlignment','left')
set(handles.bgroup{2},'ButtonSize', [32 32],'HorizontalAlignment','left')
handles.imobj=imshow(msi.imgC,msi.ref,'parent',handles.ax1);
    handles.imobj.AlphaData=msi.alphadata;
    handles.ax1.Colormap=msi.cmap;  %set colormap 
    
    handles.ax1.Color='k';
    handles.ax2.Color='k';
    ini_ax(handles.ax1)
    ini_ax(handles.ax2)
handles.p=p;
handles.H=H;
handles.V=V;
handles.bt_clear.Callback={@bt_callback_clear,handles};
handles.bt_ML_ANN.Callback={@bt_callback_ML,handles};
handles.bt_ML_SVM.Callback={@bt_callback_ML,handles};
handles.bt_ML_TREE.Callback={@bt_callback_ML,handles};
handles.bt_ML_cKNN.Callback={@bt_callback_ML,handles};
handles.bt_ML_Bayes.Callback={@bt_callback_ML,handles};

handles.bt_move.Callback={@bt_callback_move,handles};
handles.bt_delete.Callback={@bt_callback_delete,handles};
handles.uitable1.CellSelectionCallback={@uitable1_cellselect_callback,handles};
for i=1:14
   handles.bt_add{i}.Callback={@bt_callback_add,handles};
end
guidata(hObject, handles);
%-----------------------------------------------------------------
function ini_ax(ax)
    ax.XTickLabelMode='manual';
    ax.XTickLabel=[];
    ax.XTickMode='manual';
    ax.XTick=[];
    ax.YTickLabelMode='manual';
    ax.YTickLabel=[];
    ax.YTickMode='manual';
    ax.YTick=[];

function update_uitable(handles)
rois=handles.figure1.UserData.rois; % reads rois
dt=handles.uitable1.Data; %get uitable data
msi=handles.msi;

seg=handles.figure1.UserData.seg;  %get seg
for i=1:length(rois)
    tp=rois(i).BW.*msi.imgScanIDdata; tp=tp(tp>0);
    subID=tp;
    dt{i,3}=length(subID);   %update area      
    seg(subID)=dt{i,4}; 
end
handles.figure1.UserData.seg=seg;  %set seg

handles.uitable1.Data=dt;  %set uitable data
for i=1:size(dt,1)
    handles.uitable1.BackgroundColor(i,:)=str2num(dt{i,1});  
end

% --- Outputs from this function are returned to the command line.
function varargout = gui_seg_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.figure1.UserData;

function bt_callback_add(Hobject,eventData,handles)
msi=handles.msi;
pentype=handles.pop_pentype.String{handles.pop_pentype.Value};
cl=Hobject.BackgroundColor;
label=Hobject.UserData.label;
try
roi=ROI(handles.ax1,pentype,msi.ref,[cl;cl]);
handles.figure1.UserData.rois=[handles.figure1.UserData.rois, roi]; %add new roi
item={num2str(cl),pentype,0,label};  %new item
dt=handles.uitable1.Data;
handles.uitable1.Data=[dt;item]; %add new item row to table
update_uitable(handles)
handles.uitable1.UserData=[length(handles.figure1.UserData.rois),1];
handles.bt_move.Enable='on';
handles.bt_delete.Enable='on';
catch
end
guidata(Hobject,handles);

% function for clear all
function bt_callback_clear(Hobject,eventData,handles)
handles.figure1.UserData.seg=zeros(size(handles.msi.metadata,1),1);

handles.uitable1.Data=[];
sz=length(handles.figure1.UserData.rois);
if sz>0
    for i=1:sz
        handles.figure1.UserData.rois(i).delete();
    end
end
handles.figure1.UserData.rois=[];
cla(handles.ax2);
handles.bt_move.Enable='off';
handles.bt_delete.Enable='off';

function uitable1_cellselect_callback(Hobject,event,handles)
if ~isempty(event.Indices)
    id=event.Indices(1);
    col=event.Indices(2);
    handles.uitable1.UserData=event.Indices;
    handles.bt_move.Enable='on';
    handles.bt_delete.Enable='on';
end

function bt_callback_move(Hobject,eventData,handles)
tp=handles.uitable1.UserData;
if ~isempty(tp)
    id=tp(1);
    roi=handles.figure1.UserData.rois(id).move;
    handles.figure1.UserData.rois(id)=roi;
    update_uitable(handles);
end
function bt_callback_delete(Hobject,eventData,handles)
tp=handles.uitable1.UserData;
if ~isempty(tp)
    id=tp(1);
        roi=handles.figure1.UserData.rois(id);
        tp=roi.BW.*handles.msi.imgScanIDdata;
        subID=tp(tp>0);          
        lb=handles.figure1.UserData.seg;
        lb(subID)=0;  %clear labels within deleted ROI
        handles.figure1.UserData.rois(id).delete; %delete ROI;
        handles.figure1.UserData.rois(id)=[];
        handles.figure1.UserData.seg=lb;
        dt=handles.uitable1.Data;
        dt(id,:)=[];
        handles.uitable1.Data=dt;
        update_uitable(handles);
end
handles.uitable1.UserData=[];
handles.bt_move.Enable='off';
handles.bt_delete.Enable='off';

% function for ML classifier
function bt_callback_ML(Hobject,eventData,handles)
cla(handles.ax2);drawnow();
msi=handles.msi;
seg=handles.figure1.UserData.seg;
imax=handles.msi.imax;
Xtrain=imax(seg>0,:);
Ytrain=seg(seg>0,:);
Xtest=imax;
% This code specifies all the classifier options and trains the classifier.
if strcmp(Hobject.String,'ANN')
    classifier = fitcnet(...
        Xtrain, ...
        Ytrain, ...
        'LayerSizes', 10, ...
        'Activations', 'relu', ...
        'Lambda', 0, ...
        'IterationLimit', 1000, ...
        'Standardize', true); 
elseif strcmp(Hobject.String,'SVM')
    template = templateSVM(...
    'KernelFunction', 'polynomial', ...
    'PolynomialOrder', 2, ...
    'KernelScale', 'auto', ...
    'BoxConstraint', 1, ...
    'Standardize', true);
  classifier = fitcecoc(...
    Xtrain, ...
    Ytrain, ...
    'Learners', template, ...
    'Coding', 'onevsone'); 
elseif strcmp(Hobject.String,'TREE')
    classifier = fitctree(...
    Xtrain, ...
    Ytrain, ...
    'SplitCriterion', 'gdi', ...
    'MaxNumSplits', 100, ...
    'Surrogate', 'off');
elseif strcmp(Hobject.String,'cKNN')
    classifier= fitcknn(...
    Xtrain, ...
    Ytrain, ...
    'Distance', 'Cosine', ...
    'Exponent', [], ...
    'NumNeighbors', 10, ...
    'DistanceWeight', 'Equal', ...
    'Standardize', true);
elseif strcmp(Hobject.String,'Bayes')
    classifier = fitcnb(...
    Xtrain, ...
    Ytrain);
end

partitionedModel = crossval(classifier, 'KFold', 5);
% Compute validation predictions
[~, validationScore] = kfoldPredict(partitionedModel);
validationAccuracy = 1 - kfoldLoss(partitionedModel, 'LossFun', 'ClassifError');
Ytest=predict(classifier, Xtest);
 msi.idata=Ytest;
 msi=msi_update_imgdata(msi);
 img=msi.imgdata;

 if strcmp(handles.pb_filter.State,'on')
   img=denoise_seg(msi,2); msi.imgdata=img; 
 end

 img(isnan(img))=0;
 cmp=handles.figure1.UserData.cl;
 cc2=label2rgb(floor(img),cmp);
 imshow(cc2,'parent', handles.ax2)
 handles.text_score.String=['score: ',num2str(validationAccuracy)];

 md.model=classifier;
 md.name=Hobject.String;
 md.Pmodel=partitionedModel;
 md.score=validationAccuracy;
 md.ytest=Ytest;
 handles.figure1.UserData.md=md; 


% --------------------------------------------------------------------
function pb_fetch_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to pb_fetch (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
H = findobj(allchild(groot), 'flat', 'UserData', 2021111);
    if ~isempty(H)
        msi=getappdata(H,'msi');        
        handles.imobj.CData=msi.imgdata/prctile(msi.idata,99)*256;
    end


% --------------------------------------------------------------------
function uipushtool5_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to uipushtool5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
fprintf('load my model')


% --------------------------------------------------------------------
function pb_save_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to pb_save (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
fprintf('save my model')
H = findobj(allchild(groot), 'flat', 'UserData', 2021111);
    if ~isempty(H)
        msi=getappdata(H,'msi');
        msi.seg=handles.figure1.UserData.md.ytest;
        setappdata(H,'msi',msi);
    end