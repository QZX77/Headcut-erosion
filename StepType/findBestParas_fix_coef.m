%使用多项式拟合
% 假设您的数据已经以表格形式导入，命名为 data
% 分离数据
clear;
dname = uigetdir;

load([dname, '\data.mat']);

Da = data(:,1);
pis = data(:, 2:5);
tau = data(:,6);
zp = data(:, 7);

Coef = 0.003*80;

% 定义目标函数，用于优化 exps 和 coef
objectiveFunction = @(parameters) optimizeRelativeShear(parameters, Da, pis, tau, zp, Coef);

% 初始参数猜测
exps_ini = [-1.295, 0.026, 0.221, -1.062];
initialGuess = [exps_ini];
A = [-1, 0, 0, 0; 1, 0, 0, 0; 0, 1, 0, 0; 0, -1, 0, 0; 0, 0, 1, 0; 0, 0, -1, 0; 0, 0, 0, 1; 0, 0, 0, -1];
b = [3; 0; 0.1; 0; 1; 0; -0.1; 1.5];

% 进行优化（使用 MATLAB 优化工具箱中的函数，如 fmincon）
optimizedParameters = fmincon(objectiveFunction, initialGuess, A, b);

% 优化后的 exps 
optimizedExps = optimizedParameters(1:4);

% 使用优化后的参数计算 tauRel
tauRelOptimized = RelativeShear(Da, pis, tau, optimizedExps, Coef);

% 模型评估
% 计算 R? 或其他统计指标
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

% 函数定义
function cost = optimizeRelativeShear(parameters, Da, pis, tau, zp, Coef)
    exps = parameters(1:4);
    tauRelCalculated = RelativeShear(Da, pis, tau, exps, Coef);
    
    % 假设我们使用 comb1 来预测 tauRelCalculated
    % 这里需要定义一个合适的预测模型
    curvefit = fit(zp, tauRelCalculated, 'poly3');
    tauRelPredicted = curvefit( zp ); % 依据 comb1, comb2, comb3 等

    % 计算成本（比如均方误差）
    %cost = mean((tauRelCalculated - tauRelPredicted).^2);

    ym=mean(tauRelCalculated);
    SS_res=sum((tauRelCalculated-tauRelPredicted).^2);
    SS_tot=sum((tauRelCalculated-ym).^2);
    cost=SS_res/SS_tot;          %R2 is 1-cost
end