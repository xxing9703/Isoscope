classdef ROI
    properties
        ax    
        pen
        ref
        plt               
        tag=''
        id=1;
        BW   %mask
        edge %roi edge
        sig
        size
        weight=1;
        note='';
        c1='c' %roi drawing color
        c2='r'
    end
    properties(SetAccess=private)
        
    end

    methods
        function obj=ROI(ax,pen,ref,cl)
        obj.ax=ax;
        obj.pen=pen;        
        obj.ref=ref;
        if nargin>3
            if ischar(cl)
                obj.c1=cl(1);
                obj.c2=cl(2);
            else
               obj.c1=cl(1,:);  
               obj.c2=cl(2,:);
            end
        end
        obj=obj.draw;
        l = addlistener(obj.plt,'ROIClicked',@roiclickCallback);       
        uiwait;
        delete(l);
        obj=obj.update;        
        end
        
        function obj=draw(obj)
        pen_=obj.pen;          
        if strcmp(pen_,'polygon')||strcmp(pen_(1:3),'pol')
            obj.plt = drawpolygon(obj.ax,'Color',obj.c1,'StripeColor',obj.c2,'label',obj.tag);            
        elseif strcmp(pen_,'rectangle')||strcmp(pen_(1:3),'rec')            
            obj.plt = drawrectangle(obj.ax,'Color',obj.c1,'StripeColor',obj.c2,'label',obj.tag); 
        elseif strcmp(pen_,'ellipse')||strcmp(pen_(1:3),'ell')
            obj.plt = drawellipse(obj.ax,'Color',obj.c1,'StripeColor',obj.c2,'label',obj.tag);              
        elseif strcmp(pen_,'freehand')||strcmp(pen_(1:3),'fre')
            obj.plt = drawfreehand(obj.ax,'Color',obj.c1,'StripeColor',obj.c2,'label',obj.tag);                    
        elseif strcmp(pen_,'assisted')||strcmp(pen_(1:3),'ass')                 
            obj.plt = drawassisted(obj.ax,'Color',obj.c1,'StripeColor',obj.c2,'label',obj.tag); 
        else
            obj.plt = drawpolygon(obj.ax,'Color',obj.c1,'StripeColor',obj.c2,'label',obj.tag); 
        end
        obj.plt.FaceAlpha=0;
        obj.plt.FaceSelectable=0;  
        end
        
        function obj=update(obj)
        if isprop(obj.plt,'Vertices')
            pos = obj.plt.Vertices;
        else
            pos = obj.plt.Position;
        end
            pos=[pos;pos(1,:)];         
          
        xx=pos(:,1)/obj.ref.PixelExtentInWorldX;
        yy=pos(:,2)/obj.ref.PixelExtentInWorldY;
        obj.edge=[xx,yy];         
        
        BW_ = poly2mask(xx,yy,obj.ref.ImageSize(1),obj.ref.ImageSize(2));
        obj.BW=BW_;
        obj.size=sum(sum(BW_));
        obj.plt.InteractionsAllowed='none';
        end
        
        function [sig,ct]=get_signal(obj,I)
         S=obj.BW.*I;
         %  sig=nansum(nansum(S))/nansum(nansum(obj.BW)); %old, this is wrong
         ct=nnz(~isnan(S(obj.BW==1)));  
         % 
         sig=nansum(nansum(S))/ct;
           
           
        end
        
        function toggle(obj,onoff)
            set(obj.plt,'visible',onoff);
        end

        function delete(obj)
            delete(obj.plt)
        end       
        
        function obj=move(obj)
            obj.plt.InteractionsAllowed='all';
            obj.plt.FaceSelectable=1;
            l = addlistener(obj.plt,'ROIClicked',@roiclickCallback);
            uiwait(gcf);
            delete(l);
            obj=obj.update;            
        end
        
        function obj=reset(obj)
            obj.c1=obj.plt.Color;
            obj.c2=obj.plt.StripeColor;
            delete(obj.plt);            
            obj=obj.draw;
            l = addlistener(obj.plt,'ROIClicked',@roiclickCallback);
            uiwait;
            delete(l);
            obj=obj.update;             
        end
    end
end