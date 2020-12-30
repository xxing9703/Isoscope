% this file is obsolete, replaced by msi_update_imgdata
function msi=msi_get_imgdata(msi)
 xx=msi.xx;yy=msi.yy;
 col_max=max(yy);
 row_max=max(xx);
 n=length(xx);
 alphadata= zeros(col_max,row_max);
 for i=1:n                                   
      alphadata(yy(i),xx(i))= 1;        %exclude background
 end
 
 imgdata= nan(col_max,row_max); 
    for i=1:n                
        imgdata(yy(i),xx(i))= msi.idata(i);  %1d ->2d                      
    end 
 msi.imgdata=imgdata;
 msi.alphadata=alphadata;
 
 
 