function D = compute_distMat_L2(fk,t)

[K,~]=size(fk);
D=zeros(K);
for i=1:K-1
    for j=i+1:K
        disp([num2str(i) ',' num2str(j)])
        
        % Compute preshape distance
        D(i,j)=sqrt(trapz(t,(fk(i,:)-fk(j,:)).^2));
        D(j,i)=D(i,j);
        
    end
end