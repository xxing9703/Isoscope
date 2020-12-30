% this function is replaced by --- imobj=msi_create_imobj(ax,msi)

%initialize the image drawing on ax and return an imobj
%ref: reference object
%alphadata: transparency
%cmap: colormap
%CLim: color limit
%Color: background color of ax
%XLim,YLim: cropped region
%example: imobj=msi_ini_draw(handles.axes1,imgdata,ref,alphadata,cmap,CLim,Color,XLim,YLim)
function imobj=msi_ini_draw(ax,imgdata,ref,alphadata,cmap,CLim,Color,XLim,YLim)
    
    imobj=imshow(imgdata,ref,'parent',ax);
    imobj.AlphaData=alphadata;
    ax.Colormap=cmap;  %set colormap    
    colorbar(ax);
    %colorscale=[0,1];  %adjust color brightness
    ax.CLim=CLim;
    ax.Color=Color; %background color
    
    %pad=[1,1,1,1]; %padding
    ax.XLim=XLim;  %crop,padding, change XY limits
    ax.YLim=YLim;
    
    ax.XTickLabelMode='manual';
    ax.XTickLabel=[];
    ax.XTickMode='manual';
    ax.XTick=[];
    ax.YTickLabelMode='manual';
    ax.YTickLabel=[];
    ax.YTickMode='manual';
    ax.YTick=[];