function ComparePickup(U,cb,h)
%比较Fernandez Luque，Van Rijn和Wu (2008)公式, E是按体积记的

d=790e-6;
rou_s=2650;
T=30;
pFL=0.0854;
pWu=0.0000262;
c_drag=0.01;

delta=(rou_s-1000)/1000;
niu=GetKvisc(T);
dstar=d*(delta*9.81/niu/niu)^(1/3);
theta_cr=Crit_Shields( d, rou_s, T );

if nargin==0
    nx=60;
    thetas=linspace(0.4,1,nx);
elseif nargin==3
    nx=numel(U);
    rou_m=cb*rou_s+(1-cb)*1000;
    thetas=rou_m*c_drag*U.^2/9.81/(rou_s-1000)/d;
    
    [w0, ws] = GetSetVel(T, d, rou_s, cb);
    %alf=0.001/ws^0.8;
    alf=1.0;
else
    disp('error in number of input parameter');
end
E_VR=zeros(nx,1);
E_FL=zeros(nx,1);
E_WU=zeros(nx,1);
for ii=1:1:nx
    theta=thetas(ii);
    if theta<theta_cr
        disp('no erosion');
        return;
    end
    E_VR(ii)=0.00033*dstar^0.3*sqrt(9.81*delta*d)*(theta/theta_cr-1)^1.5;
    E_FL(ii)=Solve_FL_Entr(theta, d, rou_s, T, pFL);
    E_WU(ii)=pWu*sqrt(delta*9.81*d^3)*alf/h*(U(ii)/ws)^0.74*(theta/theta_cr-1)^1.74;
end

plot(thetas,E_VR,'r',thetas,E_FL,'b',thetas,E_WU,'k');
legend('Van Rijn', 'Fernandez Luque', 'Wu');
