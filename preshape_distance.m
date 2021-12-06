function D = preshape_distance(q1,q2,t1,t2,lambda)

c1=t1(end);
c2=t2(end);
T=length(q1);

if c1>c2
%     Tnew=ceil(c1/c2*T);
%     t=linspace(0,c1,Tnew);
%     q1=spline(t1,q1,t);
%     q2=spline(t2,q2,t);
%     q2(t>c2)=0;
    t_firstpart=t2;
    t_secondpart=linspace(c2,c1,T);
    q1_firstpart=spline(t1,q1,t_firstpart);
    q1_secondpart=spline(t1,q1,t_secondpart);
    D1=trapz(t_firstpart,(q1_firstpart-q2).^2);
    D2=trapz(t_secondpart,q1_secondpart.^2);
    
else
%     Tnew=ceil(c2/c1*T);
%     t=linspace(0,c2,Tnew);
%     q1=spline(t1,q1,t);
%     q2=spline(t2,q2,t);
%     q1(t>c1)=0;
    t_firstpart=t1;
    t_secondpart=linspace(c1,c2,T);
    q2_firstpart=spline(t2,q2,t_firstpart);
    q2_secondpart=spline(t2,q2,t_secondpart);
    D1=trapz(t_firstpart,(q1-q2_firstpart).^2);
    D2=trapz(t_secondpart,q2_secondpart.^2);

end

% L2 distance before alignment
D=sqrt(D1+lambda*D2);