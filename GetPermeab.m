function k=GetPermeab(niu, d15, n)
%n-porosity of bed
%calculate the permeability

k=9.81/160/niu*d15^2.0*n^3.0/(1-n)^2.0;

end