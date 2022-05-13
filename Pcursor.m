%class for cursor tool
classdef Pcursor
   properties
    ax %axes object
    cursor %patch object
    Color = 'r'; %display color
    Visible = 'on';%visibility
  %  Marker = '.';
   end
   properties(Dependent)    
    
   end
   methods
       function obj = Pcursor(ax,msi) %constructive function
         obj.ax=ax;         
         currentID=msi.currentID;
         [x1,y1]=intrinsicToWorld(msi.ref,msi.metadata(currentID,1)-0.4,msi.metadata(currentID,2)-0.4); 
         [x2,y2]=intrinsicToWorld(msi.ref,msi.metadata(currentID,1)-0.5,msi.metadata(currentID,2)+0.4); 
         [x3,y3]=intrinsicToWorld(msi.ref,msi.metadata(currentID,1)+0.4,msi.metadata(currentID,2)+0.4); 
         [x4,y4]=intrinsicToWorld(msi.ref,msi.metadata(currentID,1)+0.4,msi.metadata(currentID,2)-0.4); 
         XData=[x1,x2,x3,x4];
         YData=[y1,y2,y3,y4];
         if isempty(obj.cursor)           
           hold(obj.ax,'on')
           obj.cursor=fill(ax,XData,YData,obj.Color);
           %obj.cursor.FaceColor=obj.Color;
           %obj.cursor.EdgeColor=obj.Color; 
           obj.cursor.Marker='Non';
         end
         obj=obj.update(msi);
       end  

       function obj=update(obj,msi)  %update the size and location of the obj
         currentID=msi.currentID;
         ref=msi.ref;
         metadata=msi.metadata;

         [x1,y1]=intrinsicToWorld(ref,metadata(currentID,1)-0.4,metadata(currentID,2)-0.4); 
         [x2,y2]=intrinsicToWorld(ref,metadata(currentID,1)-0.4,metadata(currentID,2)+0.4); 
         [x3,y3]=intrinsicToWorld(ref,metadata(currentID,1)+0.4,metadata(currentID,2)+0.4); 
         [x4,y4]=intrinsicToWorld(ref,metadata(currentID,1)+0.4,metadata(currentID,2)-0.4); 
        obj.cursor.XData=[x1,x2,x3,x4];
        obj.cursor.YData=[y1,y2,y3,y4];       
        obj.cursor.FaceColor=obj.Color;
        obj.cursor.EdgeColor=obj.Color;        
        set(obj.cursor,'visible',obj.Visible);
        %set(obj.cursor,'marker',obj.Marker);
       end
       
       function obj=delete(obj)  %destructive function
           delete(obj.cursor);           
           obj.cursor=[];
       end
   end
end