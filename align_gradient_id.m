function [gradxi,gradpsi] = align_gradient_id(q1,t1,q2k,t2k,lambda,tid)



c1=t1(end);
c2k=t2k(end);
T=length(q1);
b=min([c1,c2k]);

if c1>c2k
    
    % Compute gradient of xi
    t_firstpart=t2k;
    q1_firstpart=spline(t1,q1,t_firstpart);
    q2kdot=gradient(q2k,t2k);
    gradxi=-2*trapz(t_firstpart,(q1_firstpart-q2k).*(t_firstpart.*q2kdot+1/2*q2k));

    % Compute gradient of psi
    t=t2k;
    q1trunc=spline(t1,q1,t);
    q2kdot=gradient(q2k,t);
    dqk=q1trunc-q2k;
    w=4*b*cumtrapz(t,dqk.*q2kdot)-2*b*dqk.*q2k;
%     w=4*b^2*cumtrapz(tid,dqk.*q2kdot)-2*b*dqk.*q2k; %%% This is the same
    gradpsi=w-trapz(tid,w);
    
else
    
    % Compute gradient of xi
    t_firstpart=t1;
    t_secondpart=linspace(c1,c2k,T);
    q2k_firstpart=spline(t2k,q2k,t_firstpart);
    q2k_secondpart=spline(t2k,q2k,t_secondpart);
    q2kdot_firstpart=gradient(q2k_firstpart,t_firstpart);
    q2kdot_secondpart=gradient(q2k_secondpart,t_secondpart);
    gradxi=-2*trapz(t_firstpart,(q1-q2k_firstpart).*...
        (t_firstpart.*q2kdot_firstpart+1/2*q2k_firstpart))...
        -2*lambda*trapz(t_secondpart,-q2k_firstpart.*(t_secondpart.*...
        q2kdot_secondpart+1/2*q2k_secondpart));
    
    % Compute gradient of psi
    t=t1;
    q2ktrunc=spline(t2k,q2k,t);
    q2ktruncdot=gradient(q2ktrunc,t);
    dqk=q1-q2ktrunc;
    w=4*b*cumtrapz(t,dqk.*q2ktruncdot)-2*b*dqk.*q2ktrunc;
    gradpsi=w-trapz(tid,w);
    
end











    