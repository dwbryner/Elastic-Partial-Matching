function q = f_to_q(f,t)

fdot=gradient(f,t);
q=sign(fdot).*sqrt(abs(fdot));