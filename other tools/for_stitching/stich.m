% use imcrop.m to remove the margins of each image first (run, multiselect files to be cropped and overwitten)

% folders containing cropped image files to be concatenated horizontally.  Must be in the same ordering and numbering
list1 = dir('bc07_glucose_50um_to_stitch/*.png');
list2 = dir('bc08_glutamine_50um_to_stitch/*.png');
list3 = dir('bc13_glucose_50um_to_stitch/*.png');
list4 = dir('bc13_glutamine_50um_to_stitch/*.png');

for i=1:length(list1)
I1=imread(fullfile(list1(i).folder,list1(i).name));
I2=imread(fullfile(list2(i).folder,list2(i).name));
I3=imread(fullfile(list3(i).folder,list3(i).name));
I4=imread(fullfile(list4(i).folder,list4(i).name));
s1=max([size(I1,1),size(I2,1),size(I3,1),size(I4,1)]); %max size in dim1
s2=max([size(I1,2),size(I2,2),size(I3,2),size(I4,2)]); %max size in dim2
% images must be of the same height, resize each image to the maximum dim1
I{1}= imresize(I1,s1/size(I1,1));
I{2}= imresize(I2,s1/size(I2,1));
I{3}= imresize(I3,s1/size(I3,1));
I{4}= imresize(I4,s1/size(I4,1));
img=uint8([I{1},I{2},I{3},I{4}]); % horizontal concatenate
imwrite(img,['out',num2str(i,'%.3d'),'.png']); %output
end
