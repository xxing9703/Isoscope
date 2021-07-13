% use imcrop.m to remove the margins of each image first (run, multiselect files to be cropped and overwitten)

% folders containing cropped image files to be concatenated ho ²»Í¬ rizontally.  Must be in the same ordering and numbering
folders={'bc07_glucose_50um_to_stitch/*.png',...
    'bc08_glutamine_50um_to_stitch/*.png',...
    'bc13_glucose_50um_to_stitch/*.png',...
    'bc13_glutamine_50um_to_stitch/*.png'};
for i=1:length(folders)
    lists(:,i)=dir(folders{i});
end
s1=size(lists,1);
s2=size(lists,2);
for i=1:s1
    for j=1:s2
        I{i,j}=imread(fullfile(lists(i,j).folder,lists(i,j).name));
        xdim{i,j}=size(I{i,j},1);
        ydim{i,j}=size(I{i,j},2);
    end
end
 xmax=max(max((cell2mat(xdim))));
 ymax=max(max((cell2mat(ydim)))); 
 myout=zeros(xmax*s1,ymax*s2,3);
 for i=1:s1
    for j=1:s2
        xx=xmax*(i-1)+1;
        yy=ymax*(j-1)+1;
        sz=size(I{i,j});
        myout(xx:xx+sz(1)-1,yy:yy+sz(2)-1,:)=I{i,j};
    end
 end

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
