function [ theta_cr ] = Crit_Shields( D, rou_s, T )
%UNTITLED 此处显示有关此函数的摘要
%  calculate critical Shields parameter

niu=GetKvisc(T);
delta=(rou_s-1000)/1000;
rp=D*sqrt(delta*9.81*D)/niu;    %Reynolds number for particles
theta_cr=0.22*rp^-0.6+0.06*exp(-17.77*rp^-0.6);
end

