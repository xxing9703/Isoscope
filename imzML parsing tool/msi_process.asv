function msi=msi_process(fname,option,norm)
%example use:
% fname='..\Kidney DMAN.ibd';
%  option.peakwidth=0.0001;
%  option.threshold=1e4;
%  norm='no','RMS','TIC','median'

if isstruct(fname) % if first input is msi, already parsed
    msi=fname;  
    fname=msi.fname;
    [path,name,~] = fileparts(fname);
    f2=fullfile(path,[name '.ibd']);
else % if first input is fname, do the imzML parsed
    [path,name,~] = fileparts(fname);
    f1=fullfile(path,[name '.imzML']);
    f2=fullfile(path,[name '.ibd']);
    msi=parse_imzML(f1); % use the modified version 10/06/2021
end 
fid=fopen (f2);
for i=1:length(msi.data)
    fprintf(['processing data :',num2str(i),'/',num2str(length(msi.data)),'\n']);
  spec=read_ims(fid,msi,i);
  % ------- input 2 for peak picking and threshoding
  if ~isempty(option)
      stick=spec2stick(spec,option);
  end
  % -------- input 3 for normalization
  if ~isempty(norm)  % do normalization
     spec=spec_norm(spec,norm);
     stick=spec2stick(spec,option);
  end  
  msi.data(i).peak_mz=stick.peak_mz;
  msi.data(i).peak_sig=stick.peak_sig;
end

