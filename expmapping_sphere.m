function f2 = expmapping_sphere(f1,v,t)
  
nrm_v=sqrt(trapz(t,v.^2));
if nrm_v > 0
    f2 = f1*cos(nrm_v)+v*(sin(nrm_v)/nrm_v);
else
    f2 = f1;
end
