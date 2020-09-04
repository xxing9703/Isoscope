% Copyright 2018, Princeton University
% Written by Xi Xing
% convert ms spectrum to sticks
function  stick = spec2stick(spec, option)
if nargin==1
  option.peakwidth=0.0001;
  option.threshold=0;
end

for id=1:length(spec)
%[aa,bb]=findpeaks(spec(id).peak_sig,spec(id).peak_mz,'MinPeakWidth',option.peakwidth,'MinPeakProminence',option.threshold);
sig=spec(id).peak_sig;
mz=spec(id).peak_mz;
a=diff(sig);
b = a > 0;
ii = strfind(b(:)',[1,0]) + 1;
aa0=sig(ii);
bb0=mz(ii);
idex=find(aa0>option.threshold);
aa=aa0(idex);
bb=bb0(idex);

stick(id).peak_mz=bb;
stick(id).peak_sig=aa;
end
