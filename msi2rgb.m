%convert msi imgdata from 2d intensity to 3d rgb image data
%msi_int is the original intesity matrix
%msi_alpha defines the region of maldi scan
%cmap: colormap; cscale: [0,1] by default, bgcolor: background color
%msi_rgb: output RGB image, ab: scaling[reducing,shift] (x'=ax-b)
function [msi_rgb,ab]=msi2rgb(msi_int,msi_alpha,cmap,cscale,bgcolor)
if nargin<5
    bgcolor=[0,0,0]; %black by default
elseif nargin<4
    bgcolor=[0,0,0]; %black by default
    cscale=[0,1];
elseif nargin<3
    bgcolor=[0,0,0]; %black by default
    cscale=[0,1];
    cmap=parula;
end
a1=max(max(msi_int));
msi_int_norm=msi_int/a1; %normalize 
msi_int_norm=min(max(msi_int_norm,cscale(1)),cscale(2)); %thresholding to cscale
b=min(min(msi_int_norm));
msi_int_norm=(msi_int_norm-b); %zero offset
a2=max(max(msi_int_norm));
msi_int_norm=msi_int_norm/a2;%renormalize
a=a1*a2; %reducing
b=b/a2; %shift
ab=[a,b];
sz=size(cmap,1);
 msi_rgb=ind2rgb(uint8(msi_int_norm*sz),cmap);
for i=1:size(msi_int,1)
    for j=1:size(msi_int,2)
     if msi_alpha(i,j)==0
       msi_rgb(i,j,1)=bgcolor(1);
       msi_rgb(i,j,2)=bgcolor(2);
       msi_rgb(i,j,3)=bgcolor(3);
     end
    end
end
msi_rgb=uint8(msi_rgb*256);