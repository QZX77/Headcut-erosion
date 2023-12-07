%ʹ���������������ٷֲ�������ʽ�Ĺ�ʽ�����Ӧ���ֲ�
% �������������Ѿ��Ա����ʽ���룬����Ϊ data
% ��������
load('data_smaller_than_Bw.mat');
Da = data(:,1);
pis = data(:, 2:5);
tau = data(:,6);
zp = data(:, 7);

% ����Ŀ�꺯���������Ż� exps �� coef
objectiveFunction = @(parameters) optimizeRelativeShear(parameters, Da, pis, tau, zp);

% ��ʼ�����²�
exps_ini = [-1.295, 0.026, 0.221, -1.062];
coef_ini = 0.025;
aofx_ini = 1;
initialGuess = [exps_ini, coef_ini, aofx_ini];

% �����Ż���ʹ�� MATLAB �Ż��������еĺ������� fmincon��
optimizedParameters = fmincon(objectiveFunction, initialGuess, [ ], [ ]);

% �Ż���� exps �� coef
optimizedExps = optimizedParameters(1:4);
optimizedCoef = optimizedParameters(5);
optimizedAofx = optimizedParameters(6);

% ʹ���Ż���Ĳ������� tauRel
tauRelOptimized = RelativeShear(Da, pis, tau, optimizedExps, optimizedCoef);

% ģ������
% ���� R? ������ͳ��ָ��
y = linspace(0.01, max(zp), 100);
y = y.';

p_distri=[0.6; 2.2];     %initial guess
zpp = zp.^optimizedAofx./(zp.^optimizedAofx+1);
[a]=nlinfit(zpp, tauRelOptimized, @tau_distribution, p_distri);
x=tau_distribution(a, zpp);


plot(tauRelOptimized,zp,'ro');
hold on;
plot(x, y);

% ��������
function cost = optimizeRelativeShear(parameters, Da, pis, tau, zp)
    exps = parameters(1:4);
    coef = parameters(5);
    aofx = parameters(6);
    tauRelCalculated = RelativeShear(Da, pis, tau, exps, coef);
    
    % ������Ҫ����һ�����ʵ�Ԥ��ģ��
    
    p_distri=[0.6; 2.2];     %initial guess
    zpp = zp.^aofx./(zp.^aofx+1);       %��zpӳ�䵽(0, 1)����
    [a]=nlinfit(zpp, tauRelCalculated, @tau_distribution, p_distri);
    
    tauRelPredicted=tau_distribution(a, zpp);

    % ����ɱ������������
    cost = mean((tauRelCalculated - tauRelPredicted).^2);
end


function [tau_tauMax]=tau_distribution(a, eta)

m = a(1);
n = a(2);
sigma=(m+n)^(m+n)/m^m/n^n;

tau_tauMax=sigma*eta.^m.*(1-eta).^n;
end