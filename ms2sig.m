%find out the maximum MS signal at specific mz_range
%option=1 is maximum, option=2 is integration
%returns scale value sig, which is either the maximum or sum signal
function [sig,index]=ms2sig(mass_array,sig_array,mz_range,option)
if nargin==3
    option=1;  
end

     sig=0; index=0; 
     [b,c]=findInSorted(mass_array,mz_range);    
     tp=b:c;    
     if ~isempty(tp) && mz_range(1)<mass_array(end) && mz_range(2)> mass_array(1)     
         [sig,idx]=max(sig_array(tp)); %top signal
         index=tp(idx);
         
         if option==2
           sig=sum(sig_array(tp)); %sum signal
         end
         
     end
     
               
               