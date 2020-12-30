function img=imgdata2gray(msi)
img=msi.imgdata(min(msi.yy):max(msi.yy),min(msi.xx):max(msi.xx));
img=padarray(img,[floor(1/msi.res) floor(1/msi.res)],0,'both');
img=img/max(max(img));