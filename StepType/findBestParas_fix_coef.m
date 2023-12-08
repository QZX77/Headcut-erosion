%ʹ�ö���ʽ���
% �������������Ѿ��Ա����ʽ���룬����Ϊ data
% ��������
clear;
dname = uigetdir;

load([dname, '\data.mat']);

Da = data(:,1);
pis = data(:, 2:5);
tau = data(:,6);
zp = data(:, 7);

Coef = 0.003*80;

% ����Ŀ�꺯���������Ż� exps �� coef
objectiveFunction = @(parameters) optimizeRelativeShear(parameters, Da, pis, tau, zp, Coef);

% ��ʼ�����²�
exps_ini = [-1.295, 0.026, 0.221, -1.062];
initialGuess = [exps_ini];
A = [-1, 0, 0, 0; 1, 0, 0, 0; 0, 1, 0, 0; 0, -1, 0, 0; 0, 0, 1, 0; 0, 0, -1, 0; 0, 0, 0, 1; 0, 0, 0, -1];
b = [3; 0; 0.1; 0; 1; 0; -0.1; 1.5];

% �����Ż���ʹ�� MATLAB �Ż��������еĺ������� fmincon��
optimizedParameters = fmincon(objectiveFunction, initialGuess, A, b);

% �Ż���� exps 
optimizedExps = optimizedParameters(1:4);

% ʹ���Ż���Ĳ������� tauRel
tauRelOptimized = RelativeShear(Da, pis, tau, optimizedExps, Coef);

% ģ������
% ���� R? ������ͳ��ָ��
curvefit = fit(zp, tauRelOptimized, 'poly3');
y = linspace(0.01, max(zp), 100);
y = y.';
x = curvefit( y );

plot(tauRelOptimized,zp,'ro');
hold on;
plot(x, y);

ym=mean(tauRelOptimized);
tauRelPredicted=curvefit( zp );
SS_res=sum((tauRelOptimized-tauRelPredicted).^2);
SS_tot=sum((tauRelOptimized-ym).^2);
R2=1-SS_res/SS_tot;

% ��������
function cost = optimizeRelativeShear(parameters, Da, pis, tau, zp, Coef)
    exps = parameters(1:4);
    tauRelCalculated = RelativeShear(Da, pis, tau, exps, Coef);
    
    % ��������ʹ�� comb1 ��Ԥ�� tauRelCalculated
    % ������Ҫ����һ�����ʵ�Ԥ��ģ��
    curvefit = fit(zp, tauRelCalculated, 'poly3');
    tauRelPredicted = curvefit( zp ); % ���� comb1, comb2, comb3 ��

    % ����ɱ������������
    %cost = mean((tauRelCalculated - tauRelPredicted).^2);

    ym=mean(tauRelCalculated);
    SS_res=sum((tauRelCalculated-tauRelPredicted).^2);
    SS_tot=sum((tauRelCalculated-ym).^2);
    cost=SS_res/SS_tot;          %R2 is 1-cost
end