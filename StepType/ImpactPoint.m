function [x, y, An, Ds, Dp] = ImpactPoint(H, Bw, Da, q, varargin)
%compute variables related to the impact (plunge) point
%H is the overfall height, Bw is the backwater level
%An is upper nappe entry angle
%x, y is the plunge point coordinate
%q is discharge per unit width

% Create an input parser instance
p = inputParser;

% Define the optional parameter F and its default value
addOptional(p, 'F', 1);

% Parse the input arguments
parse(p, varargin{:});

% Extract the value of F
F = p.Results.F;

y = -(H - Bw);

K = -0.483;
A = -0.546;
B = 1.6;
C = 0.823;

%equation 1 in "predicting stress and pressure at an overfall" by Robinson
%(1992)
x = Da * ((y / Da - C) / K / F^A)^(1 / B);

dydx = K * F^A * B * (x / Da)^(B - 1);
An = -atan(dydx); % in radians
Ds = x + Bw / tan(An);

Vi = q/Da;        %issuance velocity
Vj = sqrt(Vi^2+2*9.8*(H-Bw));      %impact velocity
% equation (5.46) in "Scour technology: prediction and management of water
% erosion of earth matericals" by Annadale is derived for round jet. In the
% case of flow in retangular, the expression of Dj should be:
Dj = Da*Vi/Vj;     
Dp = Vj^2/2/9.8;     %head of the average dynamic pressure
end