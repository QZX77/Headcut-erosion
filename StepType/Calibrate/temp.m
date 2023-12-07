% ...

% ����Ŀ�꺯���������Ż� exps �� coef
objectiveFunction = @(parameters) optimizeRelativeShear(parameters, Da, pis, tau, zp);

% ��ʼ�����²�
exps_ini = [-1.295, 0.026, 0.221, -1.062];
coef_ini = 0.025;
aofx_ini = 1;
initialGuess = [exps_ini, coef_ini, aofx_ini];

% �������޺�����
lb = [zeros(1, 4), 0, 0];  % ȷ�����в������ǷǸ���
ub = [ones(1, 4) * Inf, Inf, Inf];  % ��������Ϊ�����

% �����Ż���ʹ�� lsqcurvefit ���з�����������ϣ�
options = optimoptions('lsqcurvefit','Algorithm','trust-region-reflective');
[optimizedParameters,~,residual,~,~,~,J] = lsqcurvefit(@tau_distribution, initialGuess, zp, tauRelOptimized, lb, ub, options);

% �Ż���� exps �� coef
optimizedExps = optimizedParameters(1:4);
optimizedCoef = optimizedParameters(5);
optimizedAofx = optimizedParameters(6);

% ...

% ��������
function cost = optimizeRelativeShear(parameters, Da, pis, tau, zp)
    exps = parameters(1:4);
    coef = parameters(5);
    aofx = parameters(6);
    tauRelCalculated = RelativeShear(Da, pis, tau, exps, coef);
    
    % ������Ҫ����һ�����ʵ�Ԥ��ģ��
    zpp = zp.^aofx./(zp.^aofx+1);       %��zpӳ�䵽(0, 1)����
    options = optimoptions('lsqcurvefit','Algorithm','trust-region-reflective');
    [a,~,~,exitflag,output] = lsqcurvefit(@tau_distribution, [0.6; 2.2], zpp, tauRelCalculated, [0;0], [Inf;Inf], options);
    
    tauRelPredicted=tau_distribution(a, zpp);

    % ����ɱ������������
    cost = mean((tauRelCalculated - tauRelPredicted).^2);
end

% ...

