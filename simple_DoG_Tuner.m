% 简化版 DoG 调参工具
function simple_DoG_Tuner()
    % 基本参数
    z = linspace(-8, 8, 256);
    
    % 创建图形窗口
    fig = figure('Name', 'DoG参数调试', 'Position', [100 100 800 500]);
    
    % 创建滑块
    uicontrol('Style', 'text', 'Position', [50 450 100 20], 'String', 'Alpha:');
    alpha_slider = uicontrol('Style', 'slider', 'Position', [50 430 200 20], ...
        'Min', 1, 'Max', 10, 'Value', 1.2, 'Callback', @updatePlot);
    
    uicontrol('Style', 'text', 'Position', [50 400 100 20], 'String', 'Gamma:');
    gamma_slider = uicontrol('Style', 'slider', 'Position', [50 380 200 20], ...
        'Min', 0.1, 'Max', 2, 'Value', 0.8, 'Callback', @updatePlot);
    
    uicontrol('Style', 'text', 'Position', [50 350 100 20], 'String', 'Beta:');
    beta_slider = uicontrol('Style', 'slider', 'Position', [50 330 200 20], ...
        'Min', 0.05, 'Max', 1, 'Value', 0.2, 'Callback', @updatePlot);
    
    % 创建坐标轴
    ax = axes('Position', [0.4 0.2 0.55 0.7]);
    
    % 初始绘图
    updatePlot();
    
    function updatePlot(~,~)
        alpha = alpha_slider.Value;
        gamma = gamma_slider.Value;
        beta = beta_slider.Value;
        
        % 计算DoG
        dog = alpha * exp(-gamma * z.^2) - exp(-beta * z.^2);
        
        % 绘图
        plot(ax, z, dog, 'LineWidth', 2);
        title(ax, sprintf('DoG函数: α=%.2f, γ=%.2f, β=%.2f', alpha, gamma, beta));
        xlabel('位置 z'); ylabel('幅度');
        grid on;
    end
end