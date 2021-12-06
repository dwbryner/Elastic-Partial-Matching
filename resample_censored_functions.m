function [fknew,tnew] = resample_censored_functions(fk,tk,T)

[K,~]=size(fk);
ck=tk(:,end);
tnew=linspace(0,max(ck),T);
fknew=zeros(K,T);
for k=1:K
    f=spline(tk(k,:),fk(k,:),tnew);
    f(tnew>ck(k))=0;
    fknew(k,:)=f;
end
