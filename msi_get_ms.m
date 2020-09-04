function msi=msi_get_ms(msi)
    id=msi.currentID;
    x=msi.data(id).peak_mz;
    y=msi.data(id).peak_sig;
    msi.ms.XData=double(x(:));
    msi.ms.YData=double(y(:));