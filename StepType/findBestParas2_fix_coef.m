%ʹ���������������ٷֲ�������ʽ�Ĺ�ʽ�����Ӧ���ֲ�
% �������������Ѿ��Ա����ʽ���룬����Ϊ data
% ��������
clear;
dname = uigetdir;

load([dname, '\data.mat']);

Da = data(:,1);
pis = data(:, 2:5);
tau = data(:,6);
zp = data(:, 7);

Coef = 0.002;
% ����Ŀ�꺯���������Ż� exps �� coef
objectiveFunction = @(parameters) optimizeRelativeShear(parameters, Da, pis, tau, zp, Coef);

% ��ʼ�����²�
exps_ini = [-1.295, 0.026, 0.221, -1.062];
aofx_ini = 1;
initialGuess = [exps_ini, aofx_ini];
A = [-1, 0, 0, 0,  0; 1, 0, 0, 0, 0; 0, 1, 0, 0, 0; 0, -1, 0, 0, 0; 0, 0, 1, 0, 0; 0, 0, -1, 0, 0; 0, 0, 0, 1, 0; 0, 0, 0, 0, -1];      %���Ʋ�����������Χ
b = [3; 0; 0.1; 0; 1; 0; -0.2; 0];        %�����Ʋ������������ֵ

% �����Ż���ʹ�� MATLAB �Ż��������еĺ������� fmincon��
optimizedParameters = fmincon(objectiveFunction, initialGuess, A, b);

% �Ż���� exps �� Aofx
optimizedExps = optimizedParameters(1:4);
optimizedAofx = optimizedParameters(5);

% ʹ���Ż���Ĳ������� tauRel
tauRelOptimized = RelativeShear(Da, pis, tau, optimizedExps, Coef);

% ģ������
% ���� R? ������ͳ��ָ��
y = linspace(0.001, max(zp), 200);
y = y.';
yp = y.^optimizedAofx./(y.^optimizedAofx+1);

zpp = zp.^optimizedAofx./(zp.^optimizedAofx+1);
options = optimoptions('lsqcurvefit','Algorithm','trust-region-reflective');
[a,~,~,exitflag,output] = lsqcurvefit(@tau_distribution, [2.2; 0.6], zpp, tauRelOptimized, [0;0], [Inf;Inf], options);
x=tau_distribution(a, yp);


plot(tauRelOptimized,zp,'ro');
hold on;
plot(x, y);

ym=mean(tauRelOptimized);
tauRelPredicted=tau_distribution(a, zpp);
SS_res=sum((tauRelOptimized-tauRelPredicted).^2);
SS_tot=sum((tauRelOptimized-ym).^2);
R2=1-SS_res/SS_tot;
    
% ��������
function cost = optimizeRelativeShear(parameters, Da, pis, tau, zp, Coef)
    exps = parameters(1:4);
    aofx = parameters(5);
    tauRelCalculated = RelativeShear(Da, pis, tau, exps, Coef);
    
    % ������Ҫ����һ�����ʵ�Ԥ��ģ��
    
    zpp = zp.^aofx./(zp.^aofx+1);       %��zpӳ�䵽(0, 1)����
    options = optimoptions('lsqcurvefit','Algorithm','trust-region-reflective');
    [a,~,~,exitflag,output] = lsqcurvefit(@tau_distribution, [2.2; 0.6], zpp, tauRelCalculated, [0;0], [Inf;Inf], options);
    
    tauRelPredicted=tau_distribution(a, zpp);

    % ����ɱ�
    %cost = mean((tauRelCalculated - tauRelPredicted).^2);  
    ym=mean(tauRelCalculated);
    SS_res=sum((tauRelCalculated-tauRelPredicted).^2);
    SS_tot=sum((tauRelCalculated-ym).^2);
    cost=SS_res/SS_tot;          %R2 is 1-cost
end


function [tau_tauMax]=tau_distribution(a, eta)

m = a(1);
n = a(2);
sigma=(m+n)^(m+n)/m^m/n^n;

tau_tauMax=sigma*eta.^m.*(1-eta).^n;
end