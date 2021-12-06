function n = gamma_to_n(gamma,c1,c2)

b=min(c1,c2);
T=length(gamma);
if b==c2
    n=gamma*b;
else
    t=linspace(0,c2,T);
    gam_firstpart=gamma*b;
    t_firstpart=linspace(0,b,T);
    t_secondpart=linspace(b,c2,T);
    t_secondpart=t_secondpart(2:end);
    gam_secondpart=t_secondpart;
    n=spline([t_firstpart t_secondpart],[gam_firstpart gam_secondpart],t);
end
