function assign_info=msi_find_dbase(dbase,pks,ppm,mode)
%fprintf('find dbase...');
H=1.007276;
[~,A]=sort([pks.mz]);
pks_sorted=pks(A);

[~,A]=sort([dbase.mz]);
dbase=dbase(A);

j=1;
for i=1:length(pks_sorted)
    assign_info(i).id=pks_sorted(i).id;
    %assign_info(i).Index=pks_sorted(i).Index;  
    assign_info(i).mz=pks_sorted(i).mz;
    
    mz=pks_sorted(i).mz-mode*H;
    
  while dbase(j).mz-mz<-ppm*mz
    j=j+1;
  end
  last_j=j;
  ct=0;
   while dbase(j).mz-mz<ppm*mz
       ct=ct+1;  
         tp=dbase(j);
         tp.ppm=round((dbase(j).mz-mz)/mz*1e6*10)/10;
       assign_info(i).assign(ct)=tp;          
       j=j+1;
   end
   j=last_j;
end

for i=1:length(pks_sorted)
   if isfield(assign_info(i),'assign') 
    if ~isempty(assign_info(i).assign)
    [~,A]=min(abs([assign_info(i).assign.ppm]));
    assign_info(i).formula=assign_info(i).assign(A).Formula;
    assign_info(i).ppm=assign_info(i).assign(A).ppm;
    else
      assign_info(i).formula='';  
    end
   end
end

[~,A]=sort([assign_info.id]);
assign_info=assign_info(A);
fprintf('Done\n');


