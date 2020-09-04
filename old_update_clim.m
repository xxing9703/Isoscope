function update_clim(handles)
msi=getappdata(handles.figure1,'msi');
idata=msi.idata;
if handles.radiobutton1.Value   %auto mode
    lb=0;
    ub=prctile(idata,99);
elseif handles.radiobutton2.Value %manual mode
    lb=max(idata)*handles.slider1.Value;
    ub=max(idata)*handles.slider2.Value;    
elseif handles.radiobutton3.Value  % fixed mode
    lb=str2num(handles.edit_clim1.String);
    ub=str2num(handles.edit_clim2.String);    
end
handles.axes1.CLim=[lb,ub];
