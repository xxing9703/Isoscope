%this is testing code to build colorselection gui
c=[0,0,0;1,0,0;1,1,0;0,1,0;0,1,1;0,0,1;1,0,1;1,1,1];
rainbow=c2cmap(c);
c=[0,0,0;1,0,0];
red_blk=c2cmap(c);
c=[0,0,0;0,1,0];
green_blk=c2cmap(c);
c=[0,0,0;0,0,1];
blue_blk=c2cmap(c);


df_colormap={'rainbow','parula','red_blk','green_blk','blue_blk','jet','hsv','hot','cool','spring','summer','autumn','winter','gray','bone','copper','pink'};
sz=0.05;
figure
bg = uibuttongroup('Units', 'Normalized','Position',[0.04 0.04 0.95 0.9]);
for i=1:length(df_colormap)
ax{i} = axes('Position',[0.05 0.05+i*sz 0.7 0],'parent',bg);
r{i} = uicontrol('Style', 'radiobutton','string',df_colormap{i},'parent',bg,'Units', 'Normalized', 'Position',[0.8,0.05+i*sz,0.15,sz]);
set(gca,'Visible','off')
c=eval(df_colormap{i});
colormap(ax{i},c);
 colorbar(ax{i},'Northoutside','ticks',[],'ticklabels',[])
end
