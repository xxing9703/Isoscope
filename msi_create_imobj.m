%initialize the image drawing on ax and return an imobj
function imobj=msi_create_imobj(ax,msi)
    
    imobj=imshow(msi.imgdata,msi.ref,'parent',ax);
    imobj.AlphaData=msi.alphadata;
    ax.Colormap=msi.cmap;  %set colormap    
    colorbar(ax);
    %colorscale=[0,1];  %adjust color brightness
    ax.CLim=msi.CLim;
    ax.Color=msi.bgColor; %background color

    ax.XTickLabelMode='manual';
    ax.XTickLabel=[];
    ax.XTickMode='manual';
    ax.XTick=[];
    ax.YTickLabelMode='manual';
    ax.YTickLabel=[];
    ax.YTickMode='manual';
    ax.YTick=[];