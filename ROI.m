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
        sn
        size
        coverage='' %signal coverage [>0, =0, N/A]
        weight=1;
        note='';
        c1='c' %roi drawing color
        c2='r'
    end
    properties(SetAccess=private)
        
    end

    methods
        function obj=ROI(ax,pen,ref,cl,draw)
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
        if nargin<5
        obj=obj.draw;
        l = addlistener(obj.plt,'ROIClicked',@roiclickCallback);       
        uiwait;
        delete(l);
        obj=obj.update;        
        end
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
        obj.plt.Color=obj.c1;
        obj.plt.StripeColor=obj.c2;
        end
        
        function [sig,coverage,S,sn]=get_signal(obj,I)
         S=obj.BW.*I; % I is imgdata, which contains N/A for outoftissue. S elements can be: NA, 0 or nonzero 
         %  sig=nansum(nansum(S))/nansum(nansum(obj.BW)); %old, this is wrong
         ct=nnz(~isnan(S(obj.BW==1)));  % count, within ROI(BW=1), but S is not N/A;
         ct_zero=nnz(S(obj.BW==1)==0);
         ct_nonzero=nnz(S(obj.BW==1)>0); 
         ct_na=nnz(isnan(S(obj.BW==1)));         
         sig=nansum(nansum(S))/ct;  %averaged signal
         A=obj.BW;
         S1=S(A>0);
         sn=sig/std(S1,'omitnan');  %S/N
         coverage=[' ', num2str(sn),' \ ',num2str(ct_nonzero),' \ ',num2str(ct_zero),' \ ',num2str(ct_na)];
           
           
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