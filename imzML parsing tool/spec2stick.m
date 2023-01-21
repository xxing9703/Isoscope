% Copyright 2018, Princeton University
% Written by Xi Xing
% convert ms spectrum to sticks
function  stick = spec2stick(spec, option)
if nargin==1
  option.peakwidth=0.0001;
  option.threshold=0;
  option.profile=0;
end

if option.profile==1
    for id=1:length(spec)
    %[aa,bb]=findpeaks(spec(id).peak_sig,spec(id).peak_mz,'MinPeakWidth',option.peakwidth,'MinPeakProminence',option.threshold);
    sig=spec(id).peak_sig;
    mz=spec(id).peak_mz;
    a=diff(sig);
    b = a > 0;
    ii = strfind(b(:)',[1,0]) + 1;
    aa0=sig(ii);
    bb0=mz(ii);
    index=find(aa0>option.threshold);
    aa=aa0(index);
    bb=bb0(index);
    
    stick(id).peak_mz=bb;
    stick(id).peak_sig=aa;
    end
else
    stick=spec;
end
