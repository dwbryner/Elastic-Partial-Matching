function ginv = invert_g(g,t)


T=length(g);
x=linspace(1/T,t(end),T);
ginv=spline(g,x,x);
ginv=(ginv-ginv(1))/(ginv(T)-ginv(1));
ginv=ginv*t(end);