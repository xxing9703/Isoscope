[fn,path]=uigetfile('*.png','Select multiple Image files for cropping','MultiSelect','on');
fnn=fullfile(path,fn);
if iscell(fnn)
 for i=1:length(fnn)
    fprintf([fn{i},'\n']);
    outputimgcrop(fnn{i},[10,10,20,20]);
 end
else
  outputimgcrop(fnn,[10,10,20,20]);  
end
fprintf('done\n');


function outputimgcrop(fname,pad)
I=imread(fname);
bk=I(1,1,:);
xmin=size(I,1);
xmax=1;
ymin=size(I,2);
ymax=1;

for i=1:size(I,1)
    for j=1:size(I,2)
        if sum(I(i,j,:)==bk)<3
         xmin=min(xmin,i);
         xmax=max(xmax,i);
         ymin=min(ymin,j);
         ymax=max(ymax,j);
        else
           I(i,j,1)=255;
           I(i,j,2)=255;
           I(i,j,3)=255;
        end
    end
end

I2=I(xmin-pad(1):xmax+pad(3),ymin-pad(2):ymax+pad(4),:);
imwrite(I2,fname);
end