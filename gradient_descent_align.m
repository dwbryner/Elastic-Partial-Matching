function [q2best,t2best,c2best,gammabest,E,normgrad] = gradient_descent_align(q1,...
    t1,q2,t2,lambda,stepsize,tol,maxit,plotevol)

T=length(q1);
tid=linspace(0,1,T);
q2k=q2;
t2k=t2;
psi_id=ones(1,T);
psik=psi_id;
xik=0;

E=zeros(maxit,1);
E(1)=preshape_distance(q1,q2k,t1,t2k,lambda)^2;
[gradxi,gradpsi]=align_gradient_id(q1,t1,q2k,t2k,lambda,tid);
normgrad=zeros(maxit,1);
normgrad(1)=sqrt(gradxi^2+trapz(tid,gradpsi.^2));
k=1;
% keyboard;

delta=stepsize;
deltamin=1e-8;
while normgrad(k)>tol && k<maxit;
    
    % Generate candidate update
    xi=-delta*gradxi;
    psi=expmapping_sphere(psi_id,-delta*gradpsi,tid);
    [Ektry,t2ktry,q2ktry]=align_cost_update(xi,psi,q1,t1,q2k,t2k,lambda,tid);
    
    % Update parameters
    gamma=cumtrapz(tid,psi.^2);
    gamma=gamma/gamma(end);
    psiktry=spline(tid,psik,gamma).*psi;
    xiktry=xi+xik;
    
    % Backtracking. Comment while loop if no backtracking.
    while (E(k)-Ektry<0.1*delta*normgrad(k) && delta>deltamin) || ...
            sum(psi<0)>0 || sum(psiktry<0)>0
        
        % Reduce step size
        delta=0.5*delta;
        
        % Generate candidate update
        xi=-delta*gradxi;
        psi=expmapping_sphere(psi_id,-delta*gradpsi,tid);
        [Ektry,t2ktry,q2ktry]=align_cost_update(xi,psi,q1,t1,q2k,t2k,lambda,tid);
        
        % Update parameters
        gamma=cumtrapz(tid,psi.^2);
        gamma=gamma/gamma(end);
        psiktry=spline(tid,psik,gamma).*psi;
        xiktry=xi+xik;
    
    end
%     disp(['delta = ' num2str(delta)])
    
    % Accept updates
    k=k+1;
    E(k)=Ektry;
    t2k=t2ktry;
    q2k=q2ktry;
    psik=psiktry;
    xik=xiktry;
    
    if plotevol
        figure(10); plot(t1,q1,t2k,q2k,'LineWidth',2);
    end
    
    % Compute new gradient and norm of gradient
    [gradxi,gradpsi]=align_gradient_id(q1,t1,q2k,t2k,lambda,tid);   
    normgrad(k)=sqrt(gradxi^2+trapz(tid,gradpsi.^2));
    
    if delta<deltamin
        break
    else
        delta=stepsize;
    end
    
end

% Return optimal items
E=E(1:k);
normgrad=normgrad(1:k);
q2best=q2k;
t2best=t2k;
c2best=t2best(end);
gammabest=cumtrapz(tid,psik.^2);
gammabest=gammabest/gammabest(end);


