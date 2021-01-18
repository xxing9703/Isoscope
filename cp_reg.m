function [movingR,regR]=cp_reg(moving,fixed,type)
movingR=[];regR=[];
[mp,fp] = cpselect(moving,fixed,'Wait',true);
exit=0;
while exit==0  
 if size(mp,1)<3 || size(fp,1)<3 || size(mp,1)-size(fp,1)~=0 %not enougph points 
        uiwait(msgbox('Not enough teaching points! at least 3 pairs','warning'));
        if isempty(mp) || isempty(fp)
            [mp,fp] = cpselect(moving,fixed,'Wait',true);
        else
            [mp,fp] = cpselect(moving,fixed,mp,fp,'Wait',true);
        end
 elseif size(mp,1)>3   
    tform=cp2tform(mp,fp,type); %get tansform
    fp_cal= tformfwd(tform,mp(:,1),mp(:,2)); %validate fp
    dist=zeros(size(mp,1),1);
    for i=1:size(mp,1)
        dist(i)=norm(fp(i,:)-fp_cal(i,:)); %find distance err for each
    end
    [a,b]=max(dist);
    scale=det(tform.tdata.T)^(1/3);  %find scaling
    %err=sqrt(sum(dist.^2)/size(mp,1))/scale; % sqrt error
    err=mean(dist); %mean error
    c=questdlg({['err(fixed) = ',num2str(err,3),' pixel '];...
                ['err(moving) = ',num2str(err/scale,3),' pixel'];...
                ['worst teaching point is # ',num2str(b)];...
                ['scale = ',num2str(scale,3)];...
        },'Question','Accept','Revise','Start Over','Accept');
    switch c
        case 'Accept'
            exit=1;
        case 'Start Over'
            [mp,fp] = cpselect(moving,fixed,'Wait',true);
        case 'Revise'
            [mp,fp] = cpselect(moving,fixed,mp,fp,'Wait',true);            
    end
 else
     err=0;
     tform=cp2tform(mp,fp,type); %get tansform
     scale=det(tform.tdata.T)^(1/3);  %find scaling
     exit=1;
 end
end

t = fitgeotrans(mp,fp,type);
t_inv=invert(t);
ref_fixed = imref2d(size(fixed));
ref_moving=imref2d(size(moving));
movingR = imwarp(moving,t,'nearest','OutputView',ref_fixed);

regR.mp=mp;
regR.fp=fp;
regR.t=t;
regR.t_inv=t_inv;
regR.type=type;
regR.ref_fixed=ref_fixed;
regR.ref_moving=ref_moving;
regR.err=err;
regR.scale=scale;
