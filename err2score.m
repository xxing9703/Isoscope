% given the image errdata, calculate the score, a matric to evaluate how
% reliable the image is.
function [score,s]=err2score(errdata,ppm)
ed=errdata(errdata>-99);
s1=length(ed)/length(errdata); %image coverage
s2=abs(mean(ed))/ppm; % mz off center
s3=std(ed)/ppm; %mz distribution narrow

score1=min(1,s1*2)^2;
score2=max(0,1-s2);
score3=max(0,1-s3);

s=[score1,score2,score3];
score=min(s);




