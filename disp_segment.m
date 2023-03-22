function disp_segment(msi,axes) 
 seg=msi.seg;
 meta=msi.metadata;

imgdata=nan(max(meta(:,2))+10,max(meta(:,1))+10);
for i=1:size(meta,1)
    imgdata(meta(i,2),meta(i,1))=seg(i);
end

combo=[];
for i=1:max(msi.seg)
img_seg=imgdata;
img_seg(imgdata==i)=1000;
combo=[combo,img_seg];
end
I=imshow(combo,'DisplayRange',[0 1000],'parent',axes);
set(I,'AlphaData',~isnan(combo))
