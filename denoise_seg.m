function out= denoise_seg(msi,n)
out=msi.imgdata;
for i=1+n:size(msi.imgdata,1)-n
    for j=1+n:size(msi.imgdata,2)-n
       xx=i-n:i+n;
       yy=j-n:j+n;
       tp=msi.imgdata(xx,yy);
       tp=mode(tp(:)); %the most abundant
            idx1=find((msi.imgdata(xx,yy)==msi.imgdata(i,j)));
            idx2=find(msi.imgdata(xx,yy)==tp);
           if length(idx1)==1||(length(idx1)<=(2*n+1)^2*0.2 && length(idx2)>=(2*n+1)^2*0.6)              
            out(i,j)=tp;           
           end
    end

end