%比较Fernandez Luque和Van Rijn公式

d=130e-6;
rou_s=2650;
T=15;
pFL=0.0121;

delta=(rou_s-1000)/1000;
niu=GetKvisc(T);
dstar=d*(delta*9.81/niu/niu)^(1/3);
theta_cr=Crit_Shields( d, rou_s, T );

nx=60;
thetas=linspace(0.4,1,nx);
E_VR=zeros(nx,1);
E_FL=zeros(nx,1);
for ii=1:1:nx
    theta=thetas(ii);
    E_VR(ii)=0.00033*dstar^0.3*sqrt(9.81*delta*d)*(theta/theta_cr-1)^1.5;
    E_FL(ii)=Solve_FL_Entr(theta, d, rou_s, T, pFL);
end

plot(thetas,E_VR,'r',thetas,E_FL,'b');
legend('Van Rijn', 'Fernandez Luque');
