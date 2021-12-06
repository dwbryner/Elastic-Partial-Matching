function D = compute_distMat_preshape(qk,tk,lambda)

[K,~]=size(qk);
D=zeros(K);
for i=1:K-1
    for j=i+1:K
        disp([num2str(i) ',' num2str(j)])
        
        t1=tk(i,:);
        t2=tk(j,:);
        q1=qk(i,:);
        q2=qk(j,:);
        
        % Compute preshape distance
        D(i,j)=preshape_distance(q1,q2,t1,t2,lambda);
        D(j,i)=D(i,j);
        
    end
end