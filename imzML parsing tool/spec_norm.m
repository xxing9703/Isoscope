% method: 1: no norm, 2: TIC, 3:RMS  4: median
function spec=spec_norm(spec,method)
  switch method
      case 1  
            f=1;
      case 2
            f=mean(spec.peak_sig);
      case 3
            f=sqrt(mean((spec.peak_sig).^2));
      case 4
            f=median(spec.peak_sig);
  end
  spec.peak_sig=spec.peak_sig/f;