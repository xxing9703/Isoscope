%convert msi imgdata from 2d intensity to 3d rgb image data
function img_out=msi2mono(imgdata,cscale)
for i=1:2
    
    dt=imgdata{i};
    scale=cscale{i};
    maxdt=max(max(dt));
    dt=dt/maxdt;
    dt_norm=min(max(dt,scale(1)),scale(2)); %thresholding to cscale
    b=min(min(dt_norm));
    dt_norm=(dt_norm-b); %zero offset
    a2=max(max(dt_norm));
    dt_norm=dt_norm/a2;%renormalize
    imgdata_norm{i}=dt_norm;

end
img_out=zeros(size(dt_norm,1),size(dt_norm,2),3);
for i=1:size(dt_norm,1)
    for j=1:size(dt_norm,2)     
       img_out(i,j,1)=imgdata_norm{1}(i,j);
       img_out(i,j,2)=imgdata_norm{2}(i,j);
    end
end
