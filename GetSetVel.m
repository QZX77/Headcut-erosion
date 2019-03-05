function [w0, ws] = GetSetVel(T, D, rou_s, c)
%w0 - settling velocity in clear water; ws - settling velocity in muddy
%water
%calculate the settling velocity of sediment

niu=GetKvisc(T);
a1=(13.95*niu/D)^2.0;
delta=(rou_s-1000)/1000;
a2=1.09*delta*9.81*D;
a3=13.95*niu/D;

w0=sqrt(a1+a2)-a3;

rp=w0*D/niu;
n=(4.7+0.41*rp^0.75)/(1+0.175*rp^0.75);
ws=w0*(1-c)^n;

end