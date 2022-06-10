%this function autocrop the data area and add padding 
function msi=msi_get_metadata(msi,padding)
msi.padding=padding;
metadata=[double([msi.data.x])',double([msi.data.y])'];
 %padding pixels (left, up, right,bottom)
metadata(:,1)=metadata(:,1)-min(metadata(:,1))+1 +padding(1);
metadata(:,2)=metadata(:,2)-min(metadata(:,2))+1 +padding(2);
xmax=max(metadata(:,1)+padding(3));
ymax=max(metadata(:,2)+padding(4));

ims=nan(ymax,xmax); % rows->y, columns->x
alphadata=zeros(ymax,xmax);
% fill in random data;
for i=1:size(metadata,1)
   ims(metadata(i,2),metadata(i,1))= rand;
   alphadata(metadata(i,2),metadata(i,1))=1;
end
 msi.metadata=metadata; % added metadata
 msi.imgdata=ims; % added the initialized imgdata with desired size
 msi.imgScanIDdata=ims;
 msi.alphadata=alphadata; %added alphadata
 msi.res=double(msi.res);
 msi.ref=imref2d(size(msi.imgdata),msi.res/1000,msi.res/1000); %added imreference