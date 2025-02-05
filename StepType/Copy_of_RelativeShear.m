function [tauRel] = RelativeShear(Da, pis, tau, exps, coef)
%compute tau/tau_max. Da, pis and tau can be vector, they must have the
%same number of row.
%ref: equation (12) from "Prediting stress and pressure at an overfall" by
%Robinson.
%exps is a 4*1 matrix containing each exponential of pi

if nargin == 3
    coef = 0.025;
end
tau_max = 1000*9.8*Da*coef.*pis(:,1).^exps(1).*pis(:,2).^exps(2).*pis(:,3).^exps(3);
tauRel = tau./tau_max;