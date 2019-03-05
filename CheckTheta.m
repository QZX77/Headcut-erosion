function flag_theta=CheckTheta(theta, theta_cr, fai, beta, cb, ws, n0, nl, kl, rou_s, A)
%check if the Van Rhee equation will have a root with the given Shields parameter
%fai - angle of internal friction, beta - bed slope
%van Rhee (2010) suggested A=3/4 for single particles and A=1/(1-n0)¡Ö1.7
%for a continuum

delta=(rou_s-1000)/1000;
aaa=sind(fai-beta)/sind(fai)-cb*ws*cosd(beta)*(nl-n0)*A/(1-n0-cb)/kl/(1-nl)/delta;
if theta/theta_cr>aaa
    flag_theta=1;
else
    flag_theta=0;
end

end