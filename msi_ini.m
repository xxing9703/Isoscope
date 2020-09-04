function msi=msi_ini(msi)
 msi.xx=double([msi.data.x]);
 msi.yy=double([msi.data.y]);
 msi.res=double(msi.res)/1000; %in mm