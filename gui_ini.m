function handles=gui_ini(handles)

handles.figure1.Resize='on';
handles.figure1.WindowState='maximized';


H1 = uix.HBoxFlex( 'Parent', handles.figure1 );   %V1-top layer
p{1} = uix.Panel('Parent',H1);
p{2} = uix.Panel('Parent',H1 );
p{3} = uix.Panel('Parent',H1 );
set( H1, 'Width', [handles.uipanel1.Position(3), -1, 100], 'Spacing', 2);

V1 = uix.VBox( 'Parent',p{1});
set(handles.uipanel1,'Parent', V1);
bgroup{3} = uix.HButtonBox( 'Parent', V1 );
   handles.bt_loadpks=uicontrol( 'Parent', bgroup{3},'String','Load','Callback',@(hObject,eventdata)isoScope('bt_loadpks_Callback',hObject,eventdata,guidata(hObject)) );
   handles.bt_savepks=uicontrol( 'Parent', bgroup{3},'String','Save','Callback',@(hObject,eventdata)isoScope('bt_savepks_Callback',hObject,eventdata,guidata(hObject)) );
   handles.bt_restorepks=uicontrol( 'Parent', bgroup{3},'String','<-','Callback',@(hObject,eventdata)isoScope('bt_restorepks_Callback',hObject,eventdata,guidata(hObject)) );
   handles.popup_sort=uicontrol( 'Parent', bgroup{3},'style','popupmenu','Callback',@(hObject,eventdata)isoScope('popup_sort_Callback',hObject,eventdata,guidata(hObject)) );
   set(handles.popup_sort,'string',{'Name','Formula','m_z'});
   set(bgroup{3},'ButtonSize', [60 30],'HorizontalAlignment','left')
%     set(handles.pb_loadpks,'parent',bgroup{3},'TooltipString','Load targeted pks');
%     set(handles.pb_savepks,'parent',bgroup{3},'TooltipString','save targeted pks');
%     set(handles.popup_sort,'parent',bgroup{3});
%     set(bgroup{3},'ButtonSize', [60 30],'HorizontalAlignment','left')
%pn0=uipanel('Parent',V1,'Units', 'normalized'); 
handles.uitable1=uitable('Parent',V1,'Units', 'normalized','CellSelectionCallback',@(hObject,eventdata)isoScope('uitable1_CellSelectionCallback',hObject,eventdata,guidata(hObject)) );
handles.text_status1=uicontrol('style','text','Parent', V1,'Units', 'normalized','FontWeight','bold');
    
    handles.text_status1.String='Ready...';
    handles.text_status1.FontSize=12;
    handles.text_status1.BackgroundColor=[0,1,0];
    
set(V1, 'Height', [300,30,-1,25], 'Spacing', 2 );


V2 = uix.VBoxFlex( 'Parent',p{2});
handles.uipanel_toolbar=uipanel('Parent',V2,'Units', 'normalized'); %-----central top toolbar
  bgroup{1} = uix.HButtonBox( 'Parent', handles.uipanel_toolbar);
  handles.bt_addroi=uicontrol( 'Parent', bgroup{1},'TooltipString','ROI','CDATA',cdata_update('icons\roi_32x32.png',1),'Callback',@(hObject,eventdata)isoScope('bt_addroi_Callback',hObject,eventdata,guidata(hObject)) );
  handles.bt_loadroi=uicontrol( 'Parent', bgroup{1},'TooltipString','load ROI','String','Load','Callback',@(hObject,eventdata)isoScope('bt_loadroi_Callback',hObject,eventdata,guidata(hObject)) );
  handles.bt_saveroi=uicontrol( 'Parent', bgroup{1},'TooltipString','save ROI','String','Save','Callback',@(hObject,eventdata)isoScope('bt_saveroi_Callback',hObject,eventdata,guidata(hObject)) );
  
  uicontrol('Parent', bgroup{1},'Style','text')
  
  handles.bt_rainbow=uicontrol( 'Parent', bgroup{1},'TooltipString','Customize Colormap','CDATA',cdata_update('icons\rainbow_32x32.png',1),'Callback',@(hObject,eventdata)isoScope('bt_rainbow_Callback',hObject,eventdata,guidata(hObject)) );
  handles.bt_bcolor=uicontrol( 'Parent', bgroup{1},'TooltipString','Background Color','BackgroundColor','k','Callback',@(hObject,eventdata)isoScope('bt_bcolor_Callback',hObject,eventdata,guidata(hObject)) );
  handles.bt_roionoff=uicontrol( 'Parent', bgroup{1},'Style','togglebutton','String', 'roi','TooltipString','show rois','Callback',@(hObject,eventdata)isoScope('bt_roionoff_Callback',hObject,eventdata,guidata(hObject)) );
  handles.bt_scalebar=uicontrol( 'Parent', bgroup{1}, 'Style','togglebutton','CDATA',cdata_update('icons\scalebar_32x32.png',1),'Callback',@(hObject,eventdata)isoScope('bt_scalebar_Callback',hObject,eventdata,guidata(hObject)) );
  
  uicontrol('Parent', bgroup{1},'Style','text')
  
  handles.bt_enrich=uicontrol( 'Parent', bgroup{1},'String', '13C','FontWeight','bold','ForegroundColor','r','enable','off','TooltipString','enrichment','CDATA',cdata_update('icons\enrich0_32x32.png',1),'Callback',@(hObject,eventdata)isoScope('bt_enrich_Callback',hObject,eventdata,guidata(hObject)) );
  handles.bt_abs=uicontrol( 'Parent', bgroup{1},'Style','togglebutton','enable','off','String', 'abs','TooltipString','absolute abundance','Callback',@(hObject,eventdata)isoScope('bt_toggle_Callback',hObject,eventdata,guidata(hObject)) );
  handles.bt_ratio=uicontrol( 'Parent', bgroup{1},'Style','togglebutton','enable','off','String', 'ratio','TooltipString','enrichment ratio','Callback',@(hObject,eventdata)isoScope('bt_toggle_Callback',hObject,eventdata,guidata(hObject)) );
  %handles.bt_fraction=uicontrol( 'Parent', bgroup{1},'Style','togglebutton','enable','off', 'CDATA',cdata_update('icons\fraction_32x32.png',1),'TooltipString','toggle','Callback',@(hObject,eventdata)isoScope('bt_toggle_Callback',hObject,eventdata,guidata(hObject)) );
  handles.bt_fraction=uicontrol( 'Parent', bgroup{1},'Style','togglebutton','enable','off','String', 'frac','TooltipString','labeling fraction','Callback',@(hObject,eventdata)isoScope('bt_toggle_Callback',hObject,eventdata,guidata(hObject)) );
  handles.bt_addweight=uicontrol( 'Parent', bgroup{1},'TooltipString','Update Weight','CDATA',cdata_update('icons\weight_32x32.png',1),'Callback',@(hObject,eventdata)isoScope('bt_addweight_Callback',hObject,eventdata,guidata(hObject)) );
  
  %handles.bt_isobar=uicontrol( 'Parent', bgroup{1}, 'enable','off','CDATA',cdata_update('icons\isobar_32x32.png',1),'Callback',@(hObject,eventdata)isoScope('bt_isobar_Callback',hObject,eventdata,guidata(hObject)) );
  
  uicontrol('Parent', bgroup{1},'Style','text')
    
  handles.bt_targeted=uicontrol( 'Parent', bgroup{1}, 'String', '','TooltipString','targeted','CDATA',cdata_update('icons\targeted_32x32.png',1),'Callback',@(hObject,eventdata)isoScope('bt_targeted_Callback',hObject,eventdata,guidata(hObject)) );
  handles.bt_untargeted=uicontrol( 'Parent', bgroup{1}, 'String', 'Un','TooltipString','Untargeted','CDATA',cdata_update('icons\untargeted_32x32.png',1),'Callback',@(hObject,eventdata)isoScope('bt_untargeted_Callback',hObject,eventdata,guidata(hObject)) );
  handles.bt_select=uicontrol( 'Parent', bgroup{1}, 'TooltipString','Select peaks','CDATA',cdata_update('icons\select_32x32.png',1),'Callback',@(hObject,eventdata)isoScope('bt_select_Callback',hObject,eventdata,guidata(hObject)) );
  handles.bt_batch1=uicontrol( 'Parent', bgroup{1}, 'String', '| >','TooltipString','batch_intensity','Callback',@(hObject,eventdata)isoScope('bt_batch1_Callback',hObject,eventdata,guidata(hObject))  );
  handles.bt_batch2=uicontrol( 'Parent', bgroup{1}, 'String', '| >>','TooltipString','batch_enrichment','Callback',@(hObject,eventdata)isoScope('bt_batch2_Callback',hObject,eventdata,guidata(hObject))  );

  uicontrol('Parent', bgroup{1},'Style','text')
  
  handles.bt_msview=uicontrol( 'Parent', bgroup{1},'String','  ms','TooltipString','msviewer','CDATA',cdata_update('icons\ms_32x32.png',1),'Callback',@(hObject,eventdata)isoScope('bt_msview_Callback',hObject,eventdata,guidata(hObject)) );
  handles.bt_savefig=uicontrol( 'Parent', bgroup{1}, 'TooltipString','Save figure','CDATA',cdata_update('icons\Save_32x32.png',1),'Callback',@(hObject,eventdata)isoScope('bt_savefig_Callback',hObject,eventdata,guidata(hObject)) );

  uicontrol('Parent', bgroup{1},'Style','text')
  
  handles.bt_fun1=uicontrol( 'Parent', bgroup{1},'String','F1','TooltipString','myfunction 1','Callback',@(hObject,eventdata)isoScope('bt_fun1_Callback',hObject,eventdata,guidata(hObject)) );
  handles.bt_fun2=uicontrol( 'Parent', bgroup{1},'String','F2','TooltipString','myfunction 2','Callback',@(hObject,eventdata)isoScope('bt_fun2_Callback',hObject,eventdata,guidata(hObject)) );
  handles.bt_fun3=uicontrol( 'Parent', bgroup{1},'String','F3','TooltipString','myfunction 3','Callback',@(hObject,eventdata)isoScope('bt_fun3_Callback',hObject,eventdata,guidata(hObject)) );
  handles.bt_fun4=uicontrol( 'Parent', bgroup{1},'String','F4','TooltipString','myfunction 4','Callback',@(hObject,eventdata)isoScope('bt_fun4_Callback',hObject,eventdata,guidata(hObject)) );
  
  
  set( bgroup{1}, 'ButtonSize', [36 36], 'HorizontalAlignment','left' );
  
  
pn1 = uiextras.TabPanel( 'Parent', V2, 'Padding', 2 );  % central, image pannel
 pn1_1 = uipanel('Parent',pn1);   
  handles.axes1 = axes('Units', 'normalized', 'Parent', pn1_1);
 pn1_2 = uipanel('Parent',pn1);  
  handles.axes2 = axes('Units', 'normalized', 'Parent', pn1_2);
%    V_sub1 = uix.VBoxFlex( 'Parent',pn1_2);
%       pf=uipanel('Parent',V_sub1);
%     %  handles.axes2 = axes('Units', 'normalized','Parent', pf);
%     uit=uitable('parent',pn_roi,'CellSelectionCallback',@(hObject,eventdata)isoScope('uitable2_CellSelectionCallback',hObject,eventdata,guidata(hObject)) );
%    vars={'Name','PenType','Size','Signal','Weight'};
%   uit.ColumnName=vars;
%   handles.uitable2=uit;
%   set(V_sub1, 'Height', [-2,-1], 'Spacing', 2 );
 pn1_3 = uipanel('Parent',pn1);   
  V_sheet = uix.VBoxFlex( 'Parent', pn1_3 );
  handles.uitable_sheet1 = uitable('Units', 'normalized', 'Parent', V_sheet);
  handles.uitable_sheet2 = uitable('Units', 'normalized', 'Parent', V_sheet);
  handles.uitable_sheet3 = uitable('Units', 'normalized', 'Parent', V_sheet);
  set( V_sheet, 'Height', [-4, -4, -1], 'Spacing', 1);
  
  pn1.TabNames = {'Image', 'Weight', 'Sheets'};
  pn1.TabSize=100;
 pn1.SelectedChild = 1;
 handles.pn1=pn1;

 % central, ROI table
%pn_roi=uipanel('Parent',V2); 
vars={'Name','PenType','Size','Signal','Notes','delete'};

uit=uitable('parent',V2,'CellSelectionCallback',@(hObject,eventdata)isoScope('uitable2_CellSelectionCallback',hObject,eventdata,guidata(hObject)) );
uit.ColumnName=vars;
handles.uitable2=uit;
pn2 = uiextras.TabPanel( 'Parent', V2, 'Padding', 2 ); % central, image pannel
  handles.ax1 = axes('Units', 'normalized', 'Parent', pn2);
  handles.ax2 = axes('Units', 'normalized', 'Parent', pn2);
    H2 = uix.HBoxFlex( 'Parent', pn2 ); 
  handles.ax3 = axes('Units', 'normalized', 'Parent', H2);   
  handles.ax4 = axes('Units', 'normalized', 'Parent', pn2);
  pn2.TabNames = {'mass spectrum', 'Error distribution', '1-D intensity','%Coverage'};
  pn2.TabSize=100;
 pn2.SelectedChild = 1;
 handles.pn2=pn2;

set(handles.text_status2,'Parent', V2); % central, status bar
set(V2, 'Height', [42,-2,-0.5,-1,25], 'Spacing', 2 );
% 

