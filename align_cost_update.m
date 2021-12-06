function [Eknew,t2knew,q2knew] = align_cost_update(xi,psi,q1,t1,q2k,t2k,lambda,tid)


% SRVF group action by P
[q2knew,t2knew]=group_action_P_SRVF(xi,psi,q2k,t1,t2k,tid);

% Compute energy update
Eknew=preshape_distance(q1,q2knew,t1,t2knew,lambda)^2;


