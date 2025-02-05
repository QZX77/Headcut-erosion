function y=y_trajectory(x, Da, F)
%compute the y coordinate on the nappe trajectory

%use the aerated nappe profile, i.e., equation 1 in "predicting stress
%and pressure at an overfall" by Robinson (1992)
if nargin==2
    %assume critical flow at the brink
    F=1;
end

K=-0.483;
A=-0.546;
B=1.6;
C=0.823;

y=Da*K*F^A*(x/Da)^B+C*Da;