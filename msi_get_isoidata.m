function msi=msi_get_isoidata(msi,pk)
 n=length(pk.MList_);
  for i=1:n
      pk.M_=i;      
      msi=msi_get_idata(msi,pk);           
      isodt_.idata(:,i)=msi.idata;
      isodt_.idata_err(:,i)=msi.errdata;
  end 
  
  if pk.isoType<=3
      isodt_.idata_norm=isodt_.idata./sum(isodt_.idata,2);
      isodt_.idata_cor=isocorr_mat(isodt_.idata_norm,n-1,pk.isoType);
      isodt_.idata_fra=isodt_.idata_cor*(0:n-1)'/(n-1);
  elseif pk.isoType==4
      maxM=pk.maxM_;
      [~,~,tp]=isocorr_CN(isodt_.idata',maxM(1),maxM(2));
      isodt_.idata_cor=tp';
      vec1=repmat(0:maxM(1),1,maxM(2)+1);
      vec2=reshape(repmat(0:maxM(2),maxM(1)+1,1),1,(maxM(1)+1)*(maxM(2)+1));
      isodt_.idata_fra(:,1)= isodt_.idata_cor*vec1'/maxM(1);
      isodt_.idata_fra(:,2)= isodt_.idata_cor*vec2'/maxM(2);      
      
  end
      
  msi.isoidata=isodt_;