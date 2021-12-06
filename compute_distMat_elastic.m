function D = compute_distMat_elastic(qk,tk)

[K,T]=size(qk);
D=zeros(K);
t=linspace(0,1,T);
for i=1:K-1
    for j=i+1:K
        disp([num2str(i) ',' num2str(j)])
        
        t1=tk(i,:);
        t2=tk(j,:);
        q1=qk(i,:);
        q2=qk(j,:);
        c1=t1(end);
        c2=t2(end);
        
        % Rescale and compute elastic shape distance
        q10=q1*sqrt(c1);
        q20=q2*sqrt(c2);
        gam=DynamicProgrammingQ(q20,q10,0,1);
        q20new=spline(t,q20,gam).*sqrt(gradient(gam,t));
        D(i,j)=sqrt(trapz(t,(q10-q20new).^2));
        D(j,i)=D(i,j);

    end
end