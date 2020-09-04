% Copyright 2018, Princeton University
% Written by Xi Xing
% This function parses imzXML into a matlab structure containing:
% .fname,.res, .data(i) (x, y, offset, length, [peak_mz,peak_sig,peak_width] )
function [msi,f2]=parse_imzXML(varargin)
if nargin==1
    filename=varargin{1};
    flag=1;
else
    filename=varargin{1};
    flag=varargin{2};
end

msi.fname=filename;

    [path,name,~] = fileparts(filename);

    f1=fullfile(path,[name '.imzML']);
    f2=fullfile(path,[name '.ibd']);
    if ~exist(f1, 'file') 
         msgbox( '.imzML file not found','Error');
        return
    elseif ~exist(f2, 'file')
         msgbox( '.ibd file not found','Error');
        return
    else        
    end
   

fprintf('parsing XY positions......\n')
DOMnode = xmlread(f1);
allListitems = DOMnode.getElementsByTagName('scan');
n=allListitems.getLength;
for i=1:n
    msi.data(i).id=i;
    thisListitem = allListitems.item(i-1);  %idex starts from 0
    thisList = thisListitem.getElementsByTagName('cvParam');
    
    thisElement = thisList.item(0);  %0-position X
    theAttributes = thisElement.getAttributes;
    attrib = theAttributes.item(3);
    st=string(attrib.getValue);
    msi.data(i).x=str2double(st); %store X
    
    thisElement = thisList.item(1); %1-position Y
    theAttributes = thisElement.getAttributes;
    attrib = theAttributes.item(3);
    st=string(attrib.getValue);
    msi.data(i).y=str2double(st); %store Y
end

if flag==1  
fprintf('parsing address......\n')
allListitems = DOMnode.getElementsByTagName('binaryDataArray');

for i=1:n
    thisListitem = allListitems.item((i-1)*2); % every other 2
    thisList = thisListitem.getElementsByTagName('cvParam');
    
    thisElement = thisList.item(0);  %0-data size
    %thisElement = thisList.item(1); %1-data bytes
    theAttributes = thisElement.getAttributes;
    attrib = theAttributes.item(3);
    st=string(attrib.getValue); 
    msi.data(i).length=str2double(st);
    
    thisElement = thisList.item(2);  %2-offset
    theAttributes = thisElement.getAttributes;
    attrib = theAttributes.item(3);
    st=string(attrib.getValue);
    msi.data(i).offset=str2double(st);  
    
    thisListitem = allListitems.item((i-1)*2+1); % every other 2
    thisList = thisListitem.getElementsByTagName('cvParam');
    thisElement = thisList.item(2);  %2-offset2
    theAttributes = thisElement.getAttributes;
    attrib = theAttributes.item(3);
    st=string(attrib.getValue);
    msi.data(i).offset2=str2double(st);  
    
end
try
allListitems = DOMnode.getElementsByTagName('scanSettings');
thisList=allListitems.item(0).getElementsByTagName('cvParam');
thisElement = thisList.item(10);
thisElement.getAttributes.item(4);
attrib=thisElement.getAttributes.item(3);
st=string(attrib.getValue);
msi.res=sqrt(str2num(st));
catch 
 msi.res=50;
end

else
    %reserved for other data structure flag=2...
end
fprintf('Done\n')