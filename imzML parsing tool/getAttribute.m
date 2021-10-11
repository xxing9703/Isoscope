function cc=getAttribute(allPara)
    for j = 1:allPara.getLength 
        thisAtt = allPara.item(j-1).getAttributes;        
        for k = 1:thisAtt.getLength
            att = thisAtt.item(k-1);
            st=string(att.getValue);
            nm=string(att.getName);
            cc(j).(nm) = char(st); 
        end
    end