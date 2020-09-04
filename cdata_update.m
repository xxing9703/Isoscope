function out=cdata_update(filename,cl)
img = imread(filename);
img = double(img)/255;
index1 = img(:,:,1) == cl;
index2 = img(:,:,2) == cl;
index3 = img(:,:,3) == cl;
indexWhite = index1+index2+index3==3;
for idx = 1 : 3
   rgb = img(:,:,idx);     % extract part of the image
   rgb(indexWhite) = NaN;  % set the white portion of the image to NaN
   img(:,:,idx) = rgb;     % substitute the update values
end
out=img;