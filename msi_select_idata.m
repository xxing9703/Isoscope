%use this function to select the type of idata stored in
%msi.isoidata; requires running of msi_get_isoidata beforehand. M_ is the
%isotopmer item number (1,2...), mode is for 1->intensity, 2->ratio,
%3->fraction 4->weight data
function msi=msi_select_idata(msi,M_,type)
msi.select_idata_type=type;
if type==1   
  msi.idata=msi.isoidata.idata(:,M_); 
elseif type==2
  msi.idata=msi.isoidata.idata_cor(:,M_);  
elseif type==3
  msi.idata=msi.isoidata.idata_fra(:,1);  
  if size(msi.isoidata.idata_fra,2)==2
    msi.idata=msi.isoidata.idata_fra(:,2-mod(M_,2));  
  end
elseif type==4
  msi.idata=msi.wdata;
elseif type==5
  msi.idata=msi.isoidata.idata_cor_original(:,M_);  
elseif type==6
  msi.idata=msi.isoidata.idata_norm(:,M_);  
elseif type==7
     msi.idata=msi.isoidata.idata_fra_nocor(:,1);  
  if size(msi.isoidata.idata_fra_nocor,2)==2
    msi.idata=msi.isoidata.idata_fra_nocor(:,2-mod(M_,2));  
  end 
end
%msi=msi_get_imgdata(msi);
msi.errdata=msi.isoidata.idata_err(:,M_);
msi=msi_update_imgdata(msi);