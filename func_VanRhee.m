function f=func_VanRhee(d, niu, theta, theta_cr, kl, n0, nl, delta, A, fai, beta, cb, ws, ve)
%calculate the value of Van Rhee's function with a given erosion velosity

dstar=d*(delta*9.81/niu/niu)^(1/3);
temp=sind(fai-beta)/sind(fai)+ve*(nl-n0)*A/kl/(1-nl)/delta;
f1=0.00033*dstar^0.3*sqrt(9.81*delta*d)*(theta/theta_cr/temp-1)^1.5;
f2=cb*ws+(1-n0-cb)*ve/cosd(beta);
f=f1-f2;

end