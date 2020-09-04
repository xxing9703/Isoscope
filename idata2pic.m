function idata2pic(idata,A,dim)
%M=3;N=4;
M=dim(1);N=dim(2);
fig=0;
for i=1:length(idata)
   md=mod(i,M*N);
     if md==1
        %h=figure;
        f=figure('units','normalized','outerposition',[0 0 1 1]);
        fig=fig+1;        
     elseif md==0
         md=M*N;
     end
     ax=subplot(M,N,md,'parent',f);
     A.idata=idata(i).idata;
     [r1,r2]=scale_bd(A.idata);
     A.scale=[r1,r2];            
     A.imshow('parent',ax);       
     title(ax,{idata(i).name,['m/z = ',num2str(idata(i).mz)]});
     drawnow();
     if md==M*N
         print(f,['outputfigure',num2str(fig)],'-dpng')
     end
end