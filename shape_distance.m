function [Ds,f2new,q2new,t2new,g] = shape_distance(q1,t1,q2,t2,f2,lambda,...
    tid,agrid,stepsize,tol,maxit,plotevol)


% Compute alignment via grid search over H
[Dgrid,q2best0,t2best0,~,gammabest0]=grid_search_align(q1,q2,t1,t2,lambda,agrid);

% Update alignment via gradient descent
[q2best,t2best,c2best,gammabest,E,~]=gradient_descent_align(q1,t1,q2best0,...
    t2best0,lambda,stepsize,tol,maxit,plotevol);
% [q2best,t2best,c2best,gammabest,E,~]=gradient_descent_align(q1,t1,q2,...
%     t2,lambda,stepsize,tol,maxit,plotevol);
% q2best=q2best0;
% t2best=t2best0;
% c2best=t2best(end);
% gammabest=gammabest0;
% Ds=Dgrid;

% figure(11); plot(E);
% keyboard;

% Compute shape distance
Ds=sqrt(E(end));

% keyboard;

% Compute f2new 
gamma=spline(tid,gammabest0,gammabest);
n=gamma_to_n(gamma,t1(end),c2best);
a=t2(end)/c2best;
f2new=spline(t2best,f2,n);
t2new=t2best;
q2new=q2best;

% Compute g up to c2best
g=n*a;

% % Compute phase distance 
% alpha=0.5;
% kappa=5;
% xi=log(a);
% psi=f_to_q(gamma,tid);
% Dp=(1-alpha)*atan(kappa*abs(xi))+alpha*real(acos(trapz(tid,psi)));

