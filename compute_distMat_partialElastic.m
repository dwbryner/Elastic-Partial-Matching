function D = compute_distMat_partialElastic(fk,qk,tk,lambda,tid,agrid,...
    stepsize,tol,maxit)

[K,~]=size(qk);
D=zeros(K);
for i=1:K-1
    for j=i+1:K
        
        disp([num2str(i) ',' num2str(j)])
        
        t1=tk(i,:);
        t2=tk(j,:);
        q1=qk(i,:);
        q2=qk(j,:);
        f2=fk(j,:);
        
        % Compute partial alignment and shape distance
        D(i,j)=shape_distance(q1,t1,q2,t2,f2,lambda,tid,agrid,stepsize,...
            tol,maxit,false);
        D(j,i)=D(i,j);
        
    end
end