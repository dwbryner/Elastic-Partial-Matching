function [fknew,qknew,tknew] = align_within_clusters_partialElastic(fk,...
    qk,tk,lambda,tid,maxit_align,agrid,labels,stepsize,tol,maxit)

nlabels=max(labels);
[K,T]=size(fk);

% Mutual alignment within clusters
qknew=zeros(K,T);
fknew=zeros(K,T);
cknew=zeros(K,1);
tknew=zeros(K,T);
% tmax=zeros(nlabels,T);
for i=1:nlabels
    disp(['Class ' num2str(i)]);
    [qknew(labels==i,:),fknew(labels==i,:),tknew(labels==i,:),cknew(labels==i)] =...
        mutual_align(qk(labels==i,:),fk(labels==i,:),tk(labels==i,:),lambda,tid,...
        maxit_align,agrid,stepsize,tol,maxit);
end

% Normalize time domains to have mean end-point of 1 within classes. 
for i=1:nlabels
    idxi=find(labels==i);
    a=1/mean(cknew(idxi));
    cknew(idxi)=a*cknew(idxi);
    tknew(idxi,:)=a*tknew(idxi,:);
    qknew(idxi,:)=qknew(idxi,:)/sqrt(a);
end

