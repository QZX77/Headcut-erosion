%使用类似异重流流速分布曲线形式的公式拟合切应力分布
% 假设您的数据已经以表格形式导入，命名为 data
% 分离数据
clear;
dname = uigetdir;

load([dname, '\data.mat']);

Da = data(:,1);
pis = data(:, 2:5);
tau = data(:,6);
zp = data(:, 7);

Coef_ini = 0.0045;

% 定义目标函数，用于优化 exps 和 coef
objectiveFunction = @(parameters) optimizeRelativeShear(parameters, Da, pis, tau, zp, Coef);

% 初始参数猜测
exps_ini = [-1.295, 0.026, 0.221, -1.062];
aofx_ini = 0.008;
initialGuess = [exps_ini, aofx_ini, Coef_ini];

lb = [-3, 0.001, 0.001,-5,0, 0.002];
ub = [0.001,2,0.9,-0.1,2, 1];
optimizedParameters = fmincon(@(parameters) optimizeRelativeShear(parameters, Da, pis, tau, zp), initialGuess, [], [], [], [], lb, ub);

% 进行优化（使用 MATLAB 优化工具箱中的函数，如 fmincon）
% 优化后的 exps 和 Aofx
optimizedExps = optimizedParameters(1:4);
optimizedAofx = optimizedParameters(5);
optimizedCoef = optimizedParameters(6);
% 使用优化后的参数计算 tauRel
tauRelOptimized = RelativeShear(Da, pis, tau, optimizedExps, optimizedCoef);
% 模型评估
% 计算 R? 或其他统计指标
y = linspace(0.001, max(zp), 200);
y = y.';
yp = y.^optimizedAofx./(y.^optimizedAofx+1);

zpp = zp.^optimizedAofx./(zp.^optimizedAofx+1);
options = optimoptions('lsqcurvefit','Algorithm','trust-region-reflective');
[a,~,~,exitflag,output] = lsqcurvefit(@tau_distribution, [2.2; 0.6], zpp, tauRelOptimized, [0;0], [Inf;Inf], options);
x=tau_distribution(a, yp);

m = a(1);
n = a(2);
sigma = (m+n)^(m+n)/m^m/n^n;
disp(['Final sigma value: ' num2str(sigma)]);

% plot(tauRelOptimized,zp,'ro');
% hold on;
% plot(x, y);

ym=mean(tauRelOptimized);
tauRelPredicted=tau_distribution(a, zpp);
SS_res=sum((tauRelOptimized-tauRelPredicted).^2);
SS_tot=sum((tauRelOptimized-ym).^2);
R2=1-SS_res/SS_tot;

% 绘制拟合曲线和实际数据
figure;
plot(tauRelOptimized, zp, 'ro', 'DisplayName', '实测数据');
hold on;
plot(x, y, 'b-', 'DisplayName', '拟合曲线');
xlabel('相对切应力值 (\tau / \tau_{max})');
ylabel('相对高度 (z / D)');
%title('Fitted Curve and Actual Data');
legend('Location', 'Best');

% 计算残差
residuals = tauRelOptimized - tauRelPredicted;
% 绘制散点图
figure;
scatter(tauRelOptimized, tauRelPredicted, 'ro', 'DisplayName', '预测值');
hold on;
% 绘制对角线
plot([min(tauRelOptimized), max(tauRelOptimized)], [min(tauRelOptimized), max(tauRelOptimized)], 'b-', 'DisplayName', '预测线');
xlabel('实测相对切应力值(\tau / \tau_{max})');
ylabel('计算相对切应力值(\tau / \tau_{max})');
%title('Comparison of Optimized and Predicted Relative Shear Stress');
legend('Location', 'Best');


% __________________________________________________________
% 函数定义
function cost = optimizeRelativeShear(parameters, Da, pis, tau, zp)
    exps = parameters(1:4);
    aofx = parameters(5);
    Coef = parameters(6);  % 确保正确获取 Coef 参数
    % Coef 参数作为优化的参数，也作为函数参数传递给 RelativeShear 函数
    tauRelCalculated = RelativeShear(Da, pis, tau, exps, Coef);
    % 这里需要定义一个合适的预测模型
    
    zpp = zp.^aofx./(zp.^aofx+1);       %把zp映射到(0, 1)区间
    options = optimoptions('lsqcurvefit','Algorithm','trust-region-reflective');
    [a,~,~,exitflag,output] = lsqcurvefit(@tau_distribution, [2.2; 0.6], zpp, tauRelCalculated, [0;0], [Inf;Inf], options);
    
    tauRelPredicted = tau_distribution(a, zpp);

    % 计算成本
    ym = mean(tauRelCalculated);
    SS_res = sum((tauRelCalculated - tauRelPredicted).^2);
    SS_tot = sum((tauRelCalculated - ym).^2);
    cost = SS_res / SS_tot;  % R2 is 1-cost
end

function [tau_tauMax]=tau_distribution(a, eta)

m = a(1);
n = a(2);
sigma=(m+n)^(m+n)/m^m/n^n;
tau_tauMax=sigma*eta.^m.*(1-eta).^n;
end
