function copyaxes(newaxes,oldaxes)
ax1=newaxes;
ax1.Units='normalized';
ax1.YDir = 'reverse';
copyobj(oldaxes.Children,ax1);
ax1.Colormap=oldaxes.Colormap;
ax1.CLim=oldaxes.CLim;
ax1.XLim=oldaxes.XLim;
ax1.YLim=oldaxes.YLim;
ax1.Color=oldaxes.Color;
ax1.XTickLabel=oldaxes.XTickLabel;
ax1.YTickLabel=oldaxes.XTickLabel;
ax1.XTick=oldaxes.XTick;
ax1.YTick=oldaxes.XTick;
ax1.DataAspectRatio=oldaxes.DataAspectRatio;
ax1.PlotBoxAspectRatio=oldaxes.PlotBoxAspectRatio;
colorbar(ax1)