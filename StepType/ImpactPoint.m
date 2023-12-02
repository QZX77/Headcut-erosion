function [x, y, An, Ds]=ImpactPoint(H, Bw, Da, F)
%compute variables related to the impact (plunge) point
%H is the overfall height, Bw is the backwater level
%An is upper nappe entry angle
%x, y is the plunge point coordinate

y=-(H-Bw);

if nargin==3
    %assume critical flow at the brink
    F=1;
end

K=-0.483;
A=-0.546;
B=1.6;
C=0.823;

%equation 1 in "predicting stress and pressure at an overfall" by Robinson
%(1992)
x=Da*((y/Da-C)/K/F^A)^(1/B);

dydx=K*F^A*B*(x/Da)^(B-1);
An=-atan(dydx);        %in radians
Ds=x+Bw/tan(An);