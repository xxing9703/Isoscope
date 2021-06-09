%from imgdata(2d double type) to rgb color image data
function msi=msi_get_imgC(msi,handles)
imgdata=msi.imgdata;
alphadata=msi.alphadata;
cmap=handles.axes1.Colormap;
cscale=[handles.slider1.Value,handles.slider2.Value];
msi.cscale=cscale;
msi.imgC=msi2rgb(imgdata,alphadata,cmap,cscale,handles.axes1.Color);
