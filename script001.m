load 13C-15N  %load msi data (.mat) 
fname='list00.xlsx'; %load metabolite known list
pks=table2struct(readtable(fname));
%%
pkid=7; %pick a peak

mypk=Mzpk(pks(pkid));
mypk.ppm=5;
mypk.offset=0;

    msi=msi_ini(msi);
    msi=msi_get_idata(msi,mypk);
    msi=msi_get_imgdata(msi);
    
    msi.currentID=1;    
    msi=msi_get_ms(msi);
    
    
    
   msi.ref=imref2d(size(msi.imgdata),msi.res,msi.res);  %create axis reference
   pad=[1,1,1,1]; %padding
   XLim=[min(msi.xx)*msi.res-pad(1),max(msi.xx)*msi.res+pad(3)];  %crop,padding, change XY limits
   YLim=[min(msi.yy)*msi.res-pad(2),max(msi.yy)*msi.res+pad(4)];
   colorscale=[0,1];  %adjust color brightness
   CLim=(max(msi.idata)+1e-9)*colorscale;
    
   % axes1 ----------initial drawing of image
   figure
   imobj=msi_ini_draw(gca,msi.imgdata,msi.ref,msi.alphadata,parula,CLim,'k',XLim,YLim); %%%%%%%initialize
   
   
%imobj.ButtonDownFcn = @axes1_ButtonDownFcn;% ----for ButtonDown action on the image
%%
mypk.M=[0,1,0]
msi=msi_get_idata(msi,mypk);
msi=msi_get_imgdata(msi);  %get imgdata from idata
imobj.CData=msi.imgdata; %update image object CData;




