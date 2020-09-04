function [arr3,ind]=mergeTwoSorted(arr1,arr2)
i=1;j=1;k=1;
len1=size(arr1,1);
len2=size(arr2,1);
dim=max(size(arr1,2),size(arr2,2));
ind=ones(len1+len2,1);
arr3=ones(len1+len2,dim);
s=len1+1:len1+len2;

while(i<=len1 && j<=len2)
    if arr1(i)<arr2(j)
        arr3(k,:)=arr1(i,:);
       % ind(k)=i;
        i=i+1;        
    else
        arr3(k,:)=arr2(j,:);
      %  ind(k)=s(j);
        j=j+1;
    end
    k=k+1; 
end
  if i<=len1 && k<=len1+len2
    arr3(k:end,:)=arr1(i:end,:);
 %   ind(k:end)=i:len1;
  end
  
  if j<=len2 && k<=len1+len2
    arr3(k:end,:)=arr2(j:end,:);
 %   ind(k:end)=s(j:end);
  end