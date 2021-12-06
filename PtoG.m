function [g,t] = PtoG(xi,psi,t1,t2,tid)

T=length(tid);
a=exp(xi);
c1=t1(end);
c2=t2(end);
c2new=c2/a;
b=min([c1,c2new]);
gamma=cumtrapz(tid,psi.^2);
gamma=gamma/gamma(end);
t2new=t2/a;
g=a*b*gamma; % for t<=b
t=t2new;
if b==c1
    tb=t1;
    trest=linspace(c1,c2new,T);
    trest=trest(2:end);
    grest=a*trest; % for t>b
    g=[g grest];
    g=spline([tb trest],g,t);
end
