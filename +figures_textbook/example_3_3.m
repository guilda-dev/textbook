function example_3_3()

figure();

%図3_2_(a) 初期値変動に対する角周波数偏差の時間応答
subplot(2, 1, 1)

net = network_example3bus('flow'     ,1,...
                          'comp2'   ,'L_impedance',...
                          'lossless',{'br23'} );

x_init = net.x_equilibrium;
x_init(1) = x_init(1) + pi/6;                                   %bus1の周波数偏差の初期値(平衡点)を+pi/6
x_init(3) = x_init(3) + 0.1;                                    %bus1の内部電圧の初期値(平衡点)を+0.1
out = net.simulate([0, 50], 'x0_sys', x_init);                  %0から50秒まで 初期値=x_init
plot(out.t, out.X{1}(:, 2), '-b', out.t, out.X{3}(:, 2), '--r') %bus1,3の周波数偏差の時系列応答をプロット
ylim([-0.015, 0.015])
subtitle('図3.2(a) 初期値変動に対する角周波数偏差の時間応答')

%図3_2_(b) 初期値変動に対する角周波数偏差の時間応答
subplot(2, 1, 2)

net = network_example3bus('flow'     ,2,...
                          'comp2'   ,'L_impedance',...
                          'lossless',{'br23'} );

x_init = net.x_equilibrium;
x_init(1) = x_init(1) + pi/6;                                   %bus1の周波数偏差の初期値(平衡点)を+pi/6
x_init(3) = x_init(3) + 0.1;                                    %bus1の内部電圧の初期値(平衡点)を+0.1
out=net.simulate([0,50], 'x0_sys', x_init);                     %0から50秒まで 初期値=x_init
plot(out.t, out.X{1}(:,2), '-b', out.t, out.X{3}(:,2), '--r')   %bus1,3の周波数偏差の時系列応答をプロット
ylim([-0.015, 0.015])
subtitle('図3.2(b) 初期値変動に対する角周波数偏差の時間応答')

end