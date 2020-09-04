function [msi,err] = dispatchMSiGUI(str,msi,handles)

func = str2func(str);
try
   uiwait(func(handles));
catch ME
   errordlg({sprintf('Error'),ME.message},'GUI Exception');
   err = true; 
end

% Retrieve application data
msi = getappdata(handles.output,'msi');


