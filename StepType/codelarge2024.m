% 假设您的数据已经以表格形式导入，命名为 data
% 分离数据
% 三次多项式拟合，用于涡尺度大的拟合
clear;
dname = uigetdir;

load([dname, '\data.mat']);

Da = data(:, 1);
pis = data(:, 2:5);
tau = data(:, 6);
zp = data(:, 7);

Coef = 0.025 ; 
% 定义目标函数，用于优化 exps 和 coef
objectiveFunction = @(parameters) optimizeRelativeShear(parameters, Da, pis, tau, zp, Coef);

% 初始参数猜测
exps_ini = [-1.295, 0.026, 0.221, -1.062];
initialGuess = exps_ini;
A = [-1, 0, 0, 0; 
    1, 0, 0, 0; 
    0, 1, 0, 0; 
    0, -1, 0, 0; 
    0, 0, 1, 0; 
    0, 0, -1, 0; 
    0, 0, 0, 1; 
    0, 0, 0, -1];
b = [3; 0; 0.1; 0; 1; 0; -0.1; 1.5];   %1.2
% 进行优化（使用 MATLAB 优化工具箱中的函数，如 fmincon）
optimizedParameters = fmincon(objectiveFunction, initialGuess, A, b);

% 优化后的 exps 
optimizedExps = optimizedParameters(1:4);

% 使用优化后的参数计算 tauRel
tauRelOptimized = RelativeShear(Da, pis, tau, optimizedExps, Coef);

                
p = polyfit(zp, tauRelOptimized, 3);  % 三次多项式拟合
y = linspace(min(zp), max(zp), 100);
x = polyval(p, y);

% 计算残差
residuals = tauRelOptimized - polyval(p, zp);

% 绘制散点图和拟合曲线在同一窗口
figure;
scatter(tauRelOptimized, zp, 'ro', 'DisplayName', '实测数据');
hold on;
plot(x, y, 'b-', 'DisplayName', '拟合曲线');
xlabel('相对切应力值 (\tau / \tau_{max})');
ylabel('相对高度 (z / D)');
%title('Fitted Curve vs Actual Data');
legend('Location', 'Best');


ym = mean(tauRelOptimized);
tauRelPredicted = polyval(p, zp);
SS_res = sum((tauRelOptimized - tauRelPredicted).^2);
SS_tot = sum((tauRelOptimized - ym).^2);
R2 = 1 - SS_res / SS_tot;
% 寻找拟合曲线上的峰值点
[~, peak_indices] = findpeaks(y);  % 使用 MATLAB 的 findpeaks 函数找到峰值点的索引
% __________________________________________________________
% 计算三次多项式拟合的相对切应力值
tauRelPolyfit = polyval(p, zp);

% 绘制散点图
figure;
scatter(tauRelOptimized, tauRelPolyfit, 'ro', 'DisplayName', '预测值');
hold on;
% 绘制对角线
plot([min(tauRelOptimized), max(tauRelOptimized)], [min(tauRelOptimized), max(tauRelOptimized)], 'b-', 'DisplayName', '预测线');
xlabel('实测相对切应力值(\tau / \tau_{max})');
ylabel('预测相对切应力值(\tau / \tau_{max})');
%title('Comparison of Optimized and Polyfit Relative Shear Stress');
legend('Location', 'Best');

% 函数定义
function cost = optimizeRelativeShear(parameters, Da, pis, tau, zp, Coef)
    exps = parameters(1:4);
    tauRelCalculated = RelativeShear(Da, pis, tau, exps, Coef);

    % 三次多项式拟合
    p = polyfit(zp, tauRelCalculated, 3);
    tauRelPredicted = polyval(p, zp);

    ym = mean(tauRelCalculated);
    SS_res = sum((tauRelCalculated - tauRelPredicted).^2);
    SS_tot = sum((tauRelCalculated - ym).^2);
    cost = SS_res / SS_tot;  % R2 is 1-cost
end
