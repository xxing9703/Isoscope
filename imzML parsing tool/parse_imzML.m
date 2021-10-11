% modified version of parse_imzXML.m after looked into Thermo's imzML file
% generalized 'name, value' retrieving method to get offset/length values
% subroutine getAttribute.m is created to get cvParam in a structure
function msi=parse_imzML(filename)
    msi.fname=filename;
    [path,name,~] = fileparts(filename);
    f1=fullfile(path,[name '.imzML']);
    f2=fullfile(path,[name '.ibd']);
    if ~exist(f1, 'file') 
         msgbox( '.imzML file not found','Error');
        return
    elseif ~exist(f2, 'file')
         msgbox( '.ibd file not found','warning');
    end

DOMnode = xmlread(f1);
allSpec=DOMnode.getElementsByTagName('spectrum'); 
n=allSpec.getLength;  %total number of spectrum

% get resolution info
allSettings = DOMnode.getElementsByTagName('scanSettings');
allPara=allSettings.item(0).getElementsByTagName('cvParam');
cc0=getAttribute(allPara);
if sum(strcmp({cc0.name},'pixel size x'))
    msi.res=str2double(cc0(strcmp({cc0.name},'pixel size x')).value);
elseif sum(strcmp({cc0.name},'pixel size'))
    msi.res=sqrt(str2double(cc0(strcmp({cc0.name},'pixel size')).value));
else
    msi.res=50;
end

% get XY and data address info
for i = 1:n
    fprintf(['parsing imzML ',num2str(i),'/',num2str(n),'\n']);
    allScan = allSpec.item(i-1).getElementsByTagName('scan');
    allPara = allScan.item(0).getElementsByTagName('cvParam');  
    
    cc1=getAttribute(allPara);  % get XY
    
    allBinary = allSpec.item(i-1).getElementsByTagName('binaryDataArray');
    
    allPara_mz = allBinary.item(0).getElementsByTagName('cvParam');
    cc2=getAttribute(allPara_mz);   %get mz pointer
    allPara_int = allBinary.item(1).getElementsByTagName('cvParam');
    cc3=getAttribute(allPara_int);  %get intensity pointer
    
    msi.data(i).id = i;    
    msi.data(i).x = str2double(cc1(strcmp({cc1.name},'position x')).value);
    msi.data(i).y = str2double(cc1(strcmp({cc1.name},'position y')).value);
    msi.data(i).length = str2double(cc2(strcmp({cc2.name},'external array length')).value);
    msi.data(i).offset = str2double(cc2(strcmp({cc2.name},'external offset')).value);
    msi.data(i).offset2 = str2double(cc3(strcmp({cc3.name},'external offset')).value);
end

   