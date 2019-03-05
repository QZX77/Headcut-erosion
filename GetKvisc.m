function niu=GetKvisc(T)
%T-temperature
%calculate kinematic viscosity 

niu=(1.785-0.0584*T+0.00116*T^2.0-0.0000102*T^3.0)*10^-6;
end