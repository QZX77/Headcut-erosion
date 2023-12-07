% ...

% 定义目标函数，用于优化 exps 和 coef
objectiveFunction = @(parameters) optimizeRelativeShear(parameters, Da, pis, tau, zp);

% 初始参数猜测
exps_ini = [-1.295, 0.026, 0.221, -1.062];
coef_ini = 0.025;
aofx_ini = 1;
initialGuess = [exps_ini, coef_ini, aofx_ini];

% 参数下限和上限
lb = [zeros(1, 4), 0, 0];  % 确保所有参数都是非负的
ub = [ones(1, 4) * Inf, Inf, Inf];  % 上限设置为无穷大

% 进行优化（使用 lsqcurvefit 进行非线性曲线拟合）
options = optimoptions('lsqcurvefit','Algorithm','trust-region-reflective');
[optimizedParameters,~,residual,~,~,~,J] = lsqcurvefit(@tau_distribution, initialGuess, zp, tauRelOptimized, lb, ub, options);

% 优化后的 exps 和 coef
optimizedExps = optimizedParameters(1:4);
optimizedCoef = optimizedParameters(5);
optimizedAofx = optimizedParameters(6);

% ...

% 函数定义
function cost = optimizeRelativeShear(parameters, Da, pis, tau, zp)
    exps = parameters(1:4);
    coef = parameters(5);
    aofx = parameters(6);
    tauRelCalculated = RelativeShear(Da, pis, tau, exps, coef);
    
    % 这里需要定义一个合适的预测模型
    zpp = zp.^aofx./(zp.^aofx+1);       %把zp映射到(0, 1)区间
    options = optimoptions('lsqcurvefit','Algorithm','trust-region-reflective');
    [a,~,~,exitflag,output] = lsqcurvefit(@tau_distribution, [0.6; 2.2], zpp, tauRelCalculated, [0;0], [Inf;Inf], options);
    
    tauRelPredicted=tau_distribution(a, zpp);

    % 计算成本（比如均方误差）
    cost = mean((tauRelCalculated - tauRelPredicted).^2);
end

% ...

