function Da=DepthApproach1(q, P, m)
% compute approaching depth

%这个函数 DepthApproach1 根据单位宽度的流量 q 和堰高 P，利用宽缘堰的方程
% 来计算接近深度（Da），并求解其根来确定接近深度。

%method1: use equation of wide crest weir
%q is discharge per unit width, P is weir height
if nargin==1
    P=0;
    m=0.385;
end

H0=(q/m/sqrt(2*9.8))^(2/3);  %total head

p=[1, (2*P-H0), (P^2-2*H0*P),-P^2*H0+q^2/2/9.8];
Da=roots(p);

