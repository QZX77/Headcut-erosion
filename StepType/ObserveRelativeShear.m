function ObserveRelativeShear(Da, pis, tau, hRel)
    % ����UI����
    fig = uifigure('Name', 'Relative Shear Calculator');
    fig.Position = [100 100 600 400]; % ���ô��ڴ�С

    % ������ͼ��
    ax = uiaxes(fig, 'Position', [150 150 400 200]);

    % ��ʼ������
    defaultExps = [-1.295, 0.026, 0.221, -1.062];
    defaultCoef = 0.025;

    % ��������ͱ�ǩ
    for i = 1:4
        minValue = min([defaultExps(i)*0.5, defaultExps(i)*1.5]);
        maxValue = max([defaultExps(i)*0.5, defaultExps(i)*1.5]);

        % ����
        sliders(i) = uislider(fig, ...
            'Position', [20 350-40*i 100 3], ...
            'Limits', [minValue maxValue], ...
            'Value', defaultExps(i));
        % ��ǩ
        labels(i) = uilabel(fig, ...
            'Position', [130 345-40*i 100 15], ...
            'Text', ['exps(' num2str(i) '): ' num2str(defaultExps(i))]);

        % ��ӻص�����
        sliders(i).ValueChangedFcn = @(sld,event) updatePlot();
    end

    % coef ����ͱ�ǩ
    coefSlider = uislider(fig, ...
        'Position', [20 50 100 3], ...
        'Limits', [defaultCoef*0.5 defaultCoef*1.5], ...
        'Value', defaultCoef);
    coefLabel = uilabel(fig, ...
        'Position', [130 45 100 15], ...
        'Text', ['coef: ' num2str(defaultCoef)]);
    coefSlider.ValueChangedFcn = @(sld,event) updatePlot();

    % ���»�ͼ
    function updatePlot()
        expsValues = [sliders(1).Value, sliders(2).Value, sliders(3).Value, sliders(4).Value];
        coefValue = coefSlider.Value;

        % ���±�ǩ�ı�
        for i = 1:4
            labels(i).Text = ['exps(' num2str(i) '): ' num2str(expsValues(i))];
        end
        coefLabel.Text = ['coef: ' num2str(coefValue)];

        %         % ���� RelativeShear ��������ͼ (ʹ��ʾ������)
        %         Da = 1; % ʾ������
        %         pis = [1, 1, 1, 1]; % ʾ������
        %         tau = 1; % ʾ������
        tauRel = RelativeShear(Da, pis, tau, expsValues, coefValue);

        % ��ͼ (����ֻ�Ǽ򵥵���ʾ tauRel ��ֵ)
        plot(ax, tauRel, hRel, 'ro');
    end
end