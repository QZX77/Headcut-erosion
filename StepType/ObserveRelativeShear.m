function ObserveRelativeShear(Da, pis, tau, hRel)
    % 创建UI界面
    fig = uifigure('Name', 'Relative Shear Calculator');
    fig.Position = [100 100 600 400]; % 设置窗口大小

    % 创建绘图区
    ax = uiaxes(fig, 'Position', [150 150 400 200]);

    % 初始化参数
    defaultExps = [-1.295, 0.026, 0.221, -1.062];
    defaultCoef = 0.025;

    % 创建滑块和标签
    for i = 1:4
        minValue = min([defaultExps(i)*0.5, defaultExps(i)*1.5]);
        maxValue = max([defaultExps(i)*0.5, defaultExps(i)*1.5]);

        % 滑块
        sliders(i) = uislider(fig, ...
            'Position', [20 350-40*i 100 3], ...
            'Limits', [minValue maxValue], ...
            'Value', defaultExps(i));
        % 标签
        labels(i) = uilabel(fig, ...
            'Position', [130 345-40*i 100 15], ...
            'Text', ['exps(' num2str(i) '): ' num2str(defaultExps(i))]);

        % 添加回调函数
        sliders(i).ValueChangedFcn = @(sld,event) updatePlot();
    end

    % coef 滑块和标签
    coefSlider = uislider(fig, ...
        'Position', [20 50 100 3], ...
        'Limits', [defaultCoef*0.5 defaultCoef*1.5], ...
        'Value', defaultCoef);
    coefLabel = uilabel(fig, ...
        'Position', [130 45 100 15], ...
        'Text', ['coef: ' num2str(defaultCoef)]);
    coefSlider.ValueChangedFcn = @(sld,event) updatePlot();

    % 更新绘图
    function updatePlot()
        expsValues = [sliders(1).Value, sliders(2).Value, sliders(3).Value, sliders(4).Value];
        coefValue = coefSlider.Value;

        % 更新标签文本
        for i = 1:4
            labels(i).Text = ['exps(' num2str(i) '): ' num2str(expsValues(i))];
        end
        coefLabel.Text = ['coef: ' num2str(coefValue)];

        %         % 调用 RelativeShear 函数并绘图 (使用示例数据)
        %         Da = 1; % 示例数据
        %         pis = [1, 1, 1, 1]; % 示例数据
        %         tau = 1; % 示例数据
        tauRel = RelativeShear(Da, pis, tau, expsValues, coefValue);

        % 绘图 (这里只是简单地显示 tauRel 的值)
        plot(ax, tauRel, hRel, 'ro');
    end
end