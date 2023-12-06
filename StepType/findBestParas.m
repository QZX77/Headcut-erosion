% 假设您的数据已经以表格形式导入，命名为 data
% 分离数据
load('data_smaller_than_Bw.mat');
Da = data(:,1);
pis = data(:, 2:5);
tau = data(:,6);
zp = data(:, 7);

% 定义目标函数，用于优化 exps 和 coef
objectiveFunction = @(parameters) optimizeRelativeShear(parameters, Da, pis, tau, zp);

% 初始参数猜测
exps_ini = [-1.295, 0.026, 0.221, -1.062];
coef_ini = 0.025;
initialGuess = [exps_ini, coef_ini];

% 进行优化（使用 MATLAB 优化工具箱中的函数，如 fmincon）
optimizedParameters = fmincon(objectiveFunction, initialGuess, [ ], [ ]);

% 优化后的 exps 和 coef
optimizedExps = optimizedParameters(1:4);
optimizedCoef = optimizedParameters(5);

% 使用优化后的参数计算 tauRel
tauRelOptimized = RelativeShear(Da, pis, tau, optimizedExps, optimizedCoef);

% 模型评估
% 计算 R? 或其他统计指标
curvefit = fit(zp, tauRelOptimized, 'poly3');
y = linspace(0.01, max(zp), 100);
y = y.';
x = curvefit( y );

plot(tauRelOptimized,zp,'ro');
hold on;
plot(x, y);

% 函数定义
function cost = optimizeRelativeShear(parameters, Da, pis, tau, zp)
    exps = parameters(1:4);
    coef = parameters(5);
    tauRelCalculated = RelativeShear(Da, pis, tau, exps, coef);
    
    % 假设我们使用 comb1 来预测 tauRelCalculated
    % 这里需要定义一个合适的预测模型
    curvefit = fit(zp, tauRelCalculated, 'poly2');
    tauRelPredicted = curvefit( zp ); % 依据 comb1, comb2, comb3 等

    % 计算成本（比如均方误差）
    cost = mean((tauRelCalculated - tauRelPredicted).^2);
end
