function y=swich_theta_U(x, cd, d)
%turn theta into velocity

delta=(2650-1000)/1000;
ustar=sqrt(x*9.81*delta*d);
y=ustar/sqrt(cd);