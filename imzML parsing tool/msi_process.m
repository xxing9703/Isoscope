function msi=msi_process(fname,option)
nn=nargin;
%fname='..\Kidney DMAN.ibd';
%   option.peakwidth=0.0001;
%    option.threshold=1e4;

[path,name,~] = fileparts(fname);
  f1=fullfile(path,[name '.imzML']);
  f2=fullfile(path,[name '.ibd']);
  
msi=parse_imzXML(f1);
fid=fopen (f2);

for i=1:length(msi.data)
    fprintf([num2str(i),'/',num2str(length(msi.data)),'\n']);
  spec=read_ims(fid,msi,i);
  if nn==1
      stick=spec2stick(spec);
  else
      stick=spec2stick(spec,option);
  end
  msi.data(i).peak_mz=stick.peak_mz;
  msi.data(i).peak_sig=stick.peak_sig;
end

