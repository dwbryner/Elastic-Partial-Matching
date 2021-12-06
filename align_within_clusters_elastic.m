function [fknew,qknew] = align_within_clusters_elastic(fk,qk,labels)

[K,T]=size(fk);
nlabels=max(labels);
t=linspace(0,1,T);

% Mutual alignment within clusters
qknew=zeros(K,T);
fknew=zeros(K,T);
for i=1:nlabels
    disp(['Class ' num2str(i)]);
    qdata=qk(labels==i,:);
    fdata=fk(labels==i,:);
    [n,~]=size(qdata);
    qref=mean(qdata,1); 
    dref=zeros(n,1);
    for j=1:n
        dref(j)=sqrt(trapz(t,(qref-qdata(j,:).^2)));
    end
    [~,idx]=min(dref);
    qref=qdata(idx,:);
    
    qdatanew=zeros(n,T);
    fdatanew=zeros(n,T);
    for j=1:n
        if j~=idx
            gam=DynamicProgrammingQ(qdata(j,:),qref,0,1);
            qdatanew(j,:)=spline(t,qdata(j,:),gam).*sqrt(gradient(gam,t));
            fdatanew(j,:)=spline(t,fdata(j,:),gam);
        else
            qdatanew(j,:)=qdata(j,:);
            fdatanew(j,:)=fdata(j,:);
        end
    end
    
    qknew(labels==i,:)=qdatanew;
    fknew(labels==i,:)=fdatanew;
        
end
