function S = dist2sim(D)

% K=length(D);
% d=D(triu(true(K),1));
% d2=d.^2;
% rhohat=fzero(@(rho) mean(exp(-rho*d2))-0.5,0.01);
% S=exp(-rhohat*D.^2);
% % keyboard;
% % mean(S(triu(true(K),1)))

S=1-D/max(max(D));