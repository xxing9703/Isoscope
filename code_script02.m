% this is an exmple script, updated 10/24/2020

load ('C:\Users\xxing\Documents\Github\Imaging Data\HD01.mat');
padding=[20,20,20,20];
msi=msi_get_metadata(msi,padding); %initialize, get metadata,ref and alphadata
%% define an m/z peak (load from pks table)
fname='list00.xlsx'; %load metabolite known list
pks=table2struct(readtable(fname));
pkid=7; %pick a peak
mypk=Mzpk(pks(pkid));
mypk.ppm=5;
mypk.offset=0;
%%
msi=msi_get_idata(msi,mypk); % get intensity data from mypk
msi=msi_update_imgdata(msi); % update imgdata
 %%  
 figure
 imobj=imshow(msi.imgdata,msi.ref);
  %%
    imobj.AlphaData=msi.alphadata;
    ax=gca;
    ax.Colormap=jet;  %set colormap    
    colorbar(ax);
    %colorscale=[0,1];  %adjust color brightness
    ax.CLim=[0,max(max(msi.imgdata))];
    ax.Color='k'; %background color
    
    %%
       
[filename,filepath]=uigetfile('*.png;*.jpg;*.tif','Load Microscopy image');
fname=fullfile(filepath,filename);
if isequal(fname,0)
   disp('User selected Cancel');
else   
    fixed=imread(fname);   % HE data
    %figure,imshow(fixed);
end

moving=msi.imgdata/max(max(msi.imgdata)); %ims data
%%
[mp,fp] = cpselect(moving,fixed,'Wait',true);
t = fitgeotrans(mp,fp,'affine');
tform=cp2tform(mp,fp,'affine');
Rfixed = imref2d(size(fixed));
movingR = imwarp(moving,t,'nearest','OutputView',Rfixed);
%figure,aa=imshowpair(fixed,registered,'blend');
R.moving=moving;
R.fixed=fixed;
R.movingR=movingR;
R.Rfixed=Rfixed;
R.t=t;

%%
f1=figure;
ax(1) = axes('Parent',f1);
ax(2) = axes('Parent',f1);
set(ax(1),'Visible','off');
set(ax(2),'Visible','off');

I1 = imshow(movingR,'Parent',ax(1));
I2 = imshow(fixed,'Parent',ax(2));
set(I2,'AlphaData',0.1);
linkaxes(ax)


myroi=drawpolygon(ax(2));
mymask=poly2mask(myroi.Position(1),myroi.Position(2),size(fixed,1),size(fixed,2));


