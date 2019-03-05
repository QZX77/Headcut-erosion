function ve=SolveVanRheeEro(theta, d50, d15, rou_s, T, fai, beta, cb, n0, nl, A)
%solve the erosion equation of Van Rhee (2010) using bisection method

theta_cr=Crit_Shields( d50, rou_s, T );
[w0, ws] = GetSetVel(T, d50, rou_s, cb);
niu=GetKvisc(T);
kl=GetPermeab(niu, d15, nl);
flag_theta=CheckTheta(theta, theta_cr, fai, beta, cb, ws, n0, nl, kl, rou_s, A);
if flag_theta==0
    disp('use original Van Rijn pickup function to solve the erosion equation');
    exit;
else
    delta=(rou_s-1000)/1000;
    b=kl*(1-nl)*delta/(nl-n0)/A*(theta/theta_cr-sind(fai-beta)/sind(fai));
    a=-sind(fai-beta)/sind(fai)*kl*(1-nl)*delta/(nl-n0)/A;
    a=a+0.005*(b-a);
    f=func_VanRhee(d50, niu, theta, theta_cr, kl, n0, nl, delta, A, fai, beta, cb, ws, a);
    if f<0
        ve=a;
        exit;
    else
        while (b-a)>1.0e-05
            mid=(a+b)/2;
            f=func_VanRhee(d50, niu, theta, theta_cr, kl, n0, nl, delta, A, fai, beta, cb, ws, mid);
            if f<0 
                b=mid;
            else
                a=mid;
            end
        end
        ve=(a+b)/2;
    end
end

end