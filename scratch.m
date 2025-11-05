dt = 0.01;
T = 15;
t = 0:dt:T;

% 方法2的三角波
period = 5;
magnitude = 3;
% x_tri = 1 - 2 * abs(mod(t/period, 1) - 0.5);
% x_tri = (x_tri + 1)/2;
x_tri = abs(magnitude*mod(t/period-period/4,1)-magnitude/2);

% 对比原始正弦波
x_sin = (magnitude*sin(t*2*pi/period)+magnitude)/4;
% figure;
% title('匀速运行的三角波')
%plot(t, x_tri, 'r-', 'LineWidth', 2);
%hold on;
%plot(t, x_sin, 'b-', 'LineWidth', 2);
%%
N = 100;
z = linspace(-N/2, N/2, N);

% 高斯包络
envelope = exp(-4*(z'./(N/2)).^2);  % 转置与否无所谓

figure;
plot(z, envelope, 'LineWidth', 2);

title('包络函数');
xlabel('位置 z'); ylabel('包络幅度');
hold on;
envelope_2 = ones(N,1);
plot(z, envelope_2, 'LineWidth', 2);
legend('非周期','周期');
ylim([0,1.5]);
grid on;
%% DoG 差高斯函数 --构建权重函数时使用
% 1D情况示例
N = 100;
z = linspace(-N/2, N/2, N);

% 情况1：gamma > beta（中心窄，周边宽）
alpha = 1; gamma = 1; beta = 0.2;
dog1 = alpha*(exp(-gamma*z.^2) - exp(-beta*z.^2));  % 注意alpha的位置

% 情况2：gamma < beta（中心宽，周边窄）  
alpha = 1; gamma = 0.2; beta = 1;
dog2 = alpha*(exp(-gamma*z.^2) - exp(-beta*z.^2));

figure;
subplot(2,1,1); plot(z, dog1); title('gamma > beta: 中心窄周边宽');
subplot(2,1,2); plot(z, dog2); title('gamma < beta: 中心宽周边窄');
%% 演示周期性平移,以及对每个神经元根据神经元的位置/id生成权重矩阵的效果
% 演示平移效果
N = 100;
z = (-N/2:1:N/2-1);
crossSection = exp(-z.^2) - 0.5*exp(-0.3*z.^2);
crossSection_shifted = circshift(crossSection, [0, round(N/2)-1]);
% % 平移前：峰值在数组开头
% figure;
% subplot(2,1,1);
% plot(1:N, crossSection, 'b-', 'LineWidth', 2);
% title('平移前 - 峰值在数组开头');
% grid on;
W_RR = zeros(1,N);
W_LL = zeros(1,N);
W_RL = zeros(1,N);
W_LR = zeros(1,N);

i = 30;
% 一共两类群体，分别定义内部投射和外部投射
W_RR(:) =  circshift(crossSection_shifted,[0 i - 1]); % Right neurons to Right neurons
W_LL(:) =  circshift(crossSection_shifted,[0 i + 1]); % Left neurons to Left neurons
W_RL(:) =  circshift(crossSection_shifted,[0 i]);     % Left neurons to Right neurons
W_LR(:) =  circshift(crossSection_shifted,[0 i]);     % Right neurons to Left neurons

% 平移后：峰值在数组中间

subplot(5,1,1);
plot(1:N, crossSection_shifted, 'r-', 'LineWidth', 2);
title('neuron',i);
subplot(5,1,2);
plot(1:N, W_RR, 'b-', 'LineWidth', 2);
title('W_{RR}')
subplot(5,1,3);
plot(1:N, W_LL, 'b-', 'LineWidth', 2);
title('W_{LL}')
subplot(5,1,4);
plot(1:N, W_RL, 'b-', 'LineWidth', 2);
title('W_{RL}')
subplot(5,1,5);
plot(1:N, W_LR, 'b-', 'LineWidth', 2);
title('W_{LR}')
grid on;
%%
F = [0.5; 1.2; 0.8]; % (3个神经元的发放率，单位Hz)
m = 4; % (每个时间步细分为4个子间隔)
dt = 0.001; % (时间步长1ms)

rm = repmat(F,1,m)

