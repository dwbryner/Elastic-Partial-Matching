function [Dshape,q2best,t2best,c2best,gammabest] = grid_search_align(q1,...
    q2,t1,t2,lambda,a)

T=length(q1);
c1=t1(end);
num_a=length(a);
D=zeros(num_a,1);
q2hat=zeros(num_a,T);
gam=zeros(num_a,T);
for i=1:num_a
    
%     disp(['Grid point ' num2str(i)])
    
    % Time scale q2
    t2a=t2/a(i);
    q2a=q2*sqrt(a(i));
    c2a=t2a(end);
    
    % Time warp q2a
    if c1<c2a
        
        % Truncate q2 to q1's domain, and resample that piece to q1's sampling 
        q2atrunc=spline(t2a,q2a,t1);
        
        % Register q2atrunc to q1
        gam(i,:)=DynamicProgrammingQ(q2atrunc,q1,0,1); 
        gama=gam(i,:)*c1;
        q2atruncwarp=spline(t1,q2atrunc,gama).*sqrt(gradient(gama,t1));
        
        % Re-attach the rest of q2
        q2awarp=[q2atruncwarp q2a(t2a>c1)];
        tnew=[t1 t2a(t2a>c1)];
        q2awarp=spline(tnew,q2awarp,t2a);
        
    else
        
        % Truncate q1 to q2's domain, and resample that piece to q2's sampling 
        q1trunc=spline(t1,q1,t2a);
        
        % Register q2atrunc to q1trunc
        gam(i,:)=DynamicProgrammingQ(q2a,q1trunc,0,1); 
        gama=gam(i,:)*c2a;
        q2awarp=spline(t2a,q2a,gama).*sqrt(gradient(gama,t2a));
        
    end
    
    % Save q2awarp for this grid point
    q2hat(i,:)=q2awarp;
    
    % Compute L2 distance
    D(i)=preshape_distance(q1,q2hat(i,:),t1,t2a,lambda);

end

[Dshape,idxmin]=min(D);
t2best=t2/a(idxmin);
c2best=t2best(end);
q2best=q2hat(idxmin,:);
gammabest=gam(idxmin,:);



