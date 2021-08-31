%Class definition for an MS peak
classdef Mzpk
   properties 
      name %compound name
      formula %chemical formula
      mass %neutral monoisotopic mass of the parent
      T
      z = -1 % charge
      isoName={'13C','15N','2D','13C15N'};
      isoMass=[1.00335,0.997,1.00628];
      isoType=1; %1=13C; 2=15N, 3=2D, 4=13C15N     
      addType=1
      M=0; 
      offset = 0 %mz offset in ppm      
      ppm = 5 %mz tolerance in ppm
   end
   properties (Dependent)      
      mz_    % m/z peak location 
      addList_ %full adductlist at current z
      MList_
      M_
      addName_ %adduct name
      range_ % mz range      
      atomcount_ % #CNHOSP if formula exists
      maxM_     
   end
   methods
      function obj = Mzpk(pk)                 
          if isnumeric(pk) % m/z input
              obj.mass=pk;
          elseif ischar(pk)
              obj.name=pk;
              obj.formula=pk;
              obj.mass=formula2mass(pk);
          else    %pk structure input
              obj.mass=pk.m_z; 
              obj.name=pk.Name;
              obj.formula=pk.Formula;
          end
            O=load('adduct_tb');
            obj.T=O.T;
      end      
      function obj=set.mz_(obj,value)%           
          mz = value*(1 - obj.offset/1e6);
          if obj.isoType==4
           MM=obj.M';MM(3)=0;
           mz = mz-(obj.isoMass*MM(:)/max(abs(obj.z),1)); %03/10/2020 modified M for multi tracer 
          else
           mz = mz-(obj.isoMass(obj.isoType)*obj.M/max(abs(obj.z),1));
          end
          
          obj.mass = mz*abs(obj.z)-obj.T{obj.z+3}{obj.addType,'diff'};
      end
      function mz_= get.mz_(obj)          
          mz_=(obj.mass+obj.T{obj.z+3}{obj.addType,'diff'})/max(abs(obj.z),1);
         
          if obj.isoType==4     
             MM=obj.M';MM(3)=0;
            mz_= mz_ + (obj.isoMass*MM(:)/max(abs(obj.z),1));  %03/10/2020 for multi tracer            
          else
            mz_= mz_ + (obj.isoMass(obj.isoType)*obj.M/max(abs(obj.z),1));   
          end 
          
          mz_=mz_*(1 + obj.offset/1e6);
      end          
      function addName_= get.addName_(obj)
          addName_=obj.T{obj.z+3}{obj.addType,'name'};
      end
      function addList_= get.addList_(obj)
          addList_=obj.T{obj.z+3}{:,'name'};
      end
      
      function MList_= get.MList_(obj) 
          if obj.isoType<4
            MList_=cellfun(@num2str,num2cell(0:obj.maxM_),'un',0);
          elseif obj.isoType==4
            MList_=[];%----2020-03-26 
            tp=obj.maxM_;
            ct=0;
            for i=1:tp(2)+1
                for j=1:tp(1)+1
                  ct=ct+1;
                  MList_{ct}=[num2str(j-1),'-',num2str(i-1)];
                end
            end
          end
      end
      function maxM_= get.maxM_(obj)          
          maxM_=obj.atomcount_(obj.isoType);
          if obj.isoType==4   %----2020-03-26 
            maxM_=[obj.atomcount_(1),obj.atomcount_(2)];  %----2020-03-26 
          end   %----2020-03-26 
      end
      function obj= set.maxM_(obj,value)      
          items={'C','N','H'};
          obj.formula=['*',items{obj.isoType},num2str(value)];
      end
      
      function range_= get.range_(obj)          
          range_=obj.mz_*[1-obj.ppm*1e-6,1+obj.ppm*1e-6];
      end 
      
      function M_= get.M_(obj)
          MM=obj.M;
          if obj.isoType<=3
             M_=MM(1)+1;
          else
             if length(MM)==1
                 MM(2)=0;
             end
             M_=MM(1) + 1 + MM(2)*(obj.maxM_(1)+1); 
          end
      end
      
      function obj= set.M_(obj,value)          
          if obj.isoType<=3
             obj.M=value-1;
          else
             obj.M(1)=mod(value-1,obj.maxM_(1)+1);
             obj.M(2)=floor((value-1)/(obj.maxM_(1)+1));
          end
      end
      function atomcount_= get.atomcount_(obj)
          if ~isempty(obj.formula)&&~sum(isnan(obj.formula))
            [~,~,ct]=formula2mass(obj.formula);
            atomcount_=ct;
          else
            atomcount_=[0,0,0,0,0,0];  
          end          
      end
   end
end