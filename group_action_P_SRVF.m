function [q2new,t2new] = group_action_P_SRVF(xi,psi,q2,t1,t2,tid)

a=exp(xi);
gamma=cumtrapz(tid,psi.^2);
gamma=gamma/gamma(end);
c1=t1(end);
t2a=t2/a;
c2a=t2a(end);
q2a=sqrt(a)*q2;
b=min(c1,c2a);
gammab=gamma*b;


if b==c1

    % Truncate q2 to q1's domain, and resample that piece to q1's sampling 
    q2atrunc=spline(t2a,q2a,t1);

    % Apply group action by gamma to q2
    q2atruncwarp=spline(t1,q2atrunc,gammab).*sqrt(gradient(gammab,t1));

    % Re-attach the rest of q2
    q2awarp=[q2atruncwarp q2a(t2a>c1)];
    tnew=[t1 t2a(t2a>c1)];
    q2new=spline(tnew,q2awarp,t2a);

else

    q2new=spline(t2a,q2a,gammab).*sqrt(gradient(gammab,t2a));

end

t2new=t2a;