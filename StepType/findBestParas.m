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
initialGuess = [exps_ini, coef_ini];

% �����Ż���ʹ�� MATLAB �Ż��������еĺ������� fmincon��
optimizedParameters = fmincon(objectiveFunction, initialGuess, [ ], [ ]);

% �Ż���� exps �� coef
optimizedExps = optimizedParameters(1:4);
optimizedCoef = optimizedParameters(5);

% ʹ���Ż���Ĳ������� tauRel
tauRelOptimized = RelativeShear(Da, pis, tau, optimizedExps, optimizedCoef);

% ģ������
% ���� R? ������ͳ��ָ��
curvefit = fit(zp, tauRelOptimized, 'poly3');
y = linspace(0.01, max(zp), 100);
y = y.';
x = curvefit( y );

plot(tauRelOptimized,zp,'ro');
hold on;
plot(x, y);

% ��������
function cost = optimizeRelativeShear(parameters, Da, pis, tau, zp)
    exps = parameters(1:4);
    coef = parameters(5);
    tauRelCalculated = RelativeShear(Da, pis, tau, exps, coef);
    
    % ��������ʹ�� comb1 ��Ԥ�� tauRelCalculated
    % ������Ҫ����һ�����ʵ�Ԥ��ģ��
    curvefit = fit(zp, tauRelCalculated, 'poly2');
    tauRelPredicted = curvefit( zp ); % ���� comb1, comb2, comb3 ��

    % ����ɱ������������
    cost = mean((tauRelCalculated - tauRelPredicted).^2);
end
