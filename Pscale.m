%class for generate scalebars on the plot. note: plot ref. units must be in mm
classdef Pscale
   properties
    ax %axes object
    ln %line object
    txt %text object
    %res = 50; %resolution
    xsp = 0.05; %scalebar x preallocated space percentage
    ysp = 0.05; %scalebar x preallocated space percentage
    lnp = 0.15; %scalebar length percentage estimate
    xpos = 'left'; %'left' or 'right'
    ypos = 'bottom'; % 'top' or 'bottom'
    color = 'g'; %display color
    %linewidth = 3;
    xtp = 0.01; % txt shift x percentage
    ytp = 0.03; % txt shift y percentage
    visible = 'on';%visibility
   end
   properties(Dependent)
    
    
   end
   methods
       function obj = Pscale(ax,varargin) %constructive function
         obj.ax=ax;
         if isempty(obj.ln)||isempty(obj.txt)
           hold(obj.ax,'on')
           obj.ln=plot(ax,[1,1],[1,1],'g','LineWidth',3);
           hold(obj.ax,'on');
           obj.txt=text(ax,1,1,'','Color','g','FontSize',10);
           
         else           
           %obj.ln=varargin{1};
           %obj.txt=varargin{2};
         end
         obj=obj.update();
       end  

       function obj=update(obj)  %update the size and location of the obj
        str={'5mm','2mm','1mm','500um','200um','100um','50um','20um','10um','<5um'};
        scales=[5000,2000,1000,500,200,100,50,20,10,2]/1000;
       %ss=obj.res*diff(obj.ax.XLim)*obj.lnp;
        ss=diff(obj.ax.XLim)*obj.lnp;
        [~,pos]=min(abs(scales-ss)); %find the nearest scale to the 10% of image width
        %width=scales(pos)/obj.res;
        width=scales(pos);
        
        arrayX=[obj.ax.XLim,obj.xsp*diff(obj.ax.XLim),width];
        arrayY=[obj.ax.YLim,obj.ysp*diff(obj.ax.YLim)];

        xloc=[1,0,1,0;1,0,1,1;0,1,-1,-1;0,1,-1,0];
        yloc=[0,1,-1;1,0,1];

        if strcmpi(obj.xpos,'left')||strcmpi(obj.xpos,'l')
           obj.ln.XData=[arrayX*xloc(1,:)',arrayX*xloc(2,:)'];
        else
           obj.ln.XData=[arrayX*xloc(3,:)',arrayX*xloc(4,:)'];
        end
        if strcmpi(obj.ypos,'bottom')||strcmpi(obj.ypos,'b')
           obj.ln.YData=[arrayY*yloc(1,:)',arrayY*yloc(1,:)'];
        else
           obj.ln.YData=[arrayY*yloc(2,:)',arrayY*yloc(2,:)'];
        end
        
        obj.txt.String=str(pos);
        obj.txt.Color=obj.color;
        obj.ln.Color=obj.color;
        obj.txt.Position=[obj.ln.XData(1)+obj.xtp*diff(obj.ax.XLim),obj.ln.YData(1)-obj.ytp*diff(obj.ax.YLim)];
        set(obj.ln,'visible',obj.visible);
        set(obj.txt,'visible',obj.visible);
       end
       
       function obj=delete(obj)  %destructive function
           delete(obj.ln);
           delete(obj.txt);
           obj.ln=[];
           obj.txt=[];
       end
   end
end