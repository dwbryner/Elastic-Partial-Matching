function [mu,sig,tmu] = mean_censored_functions(fk,tk,T)

[fknew,tmu]=resample_censored_functions(fk,tk,T);
K=size(fk);
ck=tk(:,end);
nz=zeros(1,T);
sum_f=sum(fknew,1);

% Number of non-zero functions, nz(t)
for k=1:K
    nz=nz+double(tmu<=ck(k));
end

% Cross-sectional mean function
mu=sum_f./nz;

% Cross-sectional standard deviation function
sig=zeros(1,T);
for i=1:T
    data=fknew(ck>=tmu(i),i);
    sig(i)=std(data);
end   
