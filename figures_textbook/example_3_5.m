function example_3_5()

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%  図3.5パート  %%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


net = network_example3bus('flow'     ,1,...
                          'comp2'   ,'L_impedance',...
                          'lossless',{'br23'}...
                          );

figure();

%図3_5 地絡に対する角周波数偏差の時間応答 (a) 50 [ms] の地絡
subplot(2, 1, 1)
x_init = net.x_equilibrium;
out = net.simulate([0, 50], 'x0_sys', x_init, 'fault', {{[0, 0.05], 1}});       %bus1を0から0.05まで地絡させた時のシミュレーション 初期値=x_init
plot(out.t, out.X{1}(:, 2), '-b', out.t, out.X{3}(:, 2), '--r')                 %bus1,3の周波数偏差の時系列応答をプロット
ylim([-0.02, 0.02])
subtitle('図3.5 地絡に対する角周波数偏差の時間応答 (a) 50 [ms] の地絡')

%図3_5 地絡に対する角周波数偏差の時間応答 (b) 100 [ms] の地絡
subplot(2, 1, 2)
x_init = net.x_equilibrium;
out = net.simulate([0, 50], 'x0_sys', x_init, 'fault', {{[0, 0.1], 1}});        %%bus1を0から0.1まで地絡させた時のシミュレーション 初期値=x_init
plot(out.t,out.X{1}(:,2),'-b',out.t,out.X{3}(:,2),'--r')                        %bus1,3の周波数偏差の時系列応答をプロット
ylim([-0.02, 0.02])
subtitle('図3.5 地絡に対する角周波数偏差の時間応答 (b) 100 [ms] の地絡')




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%  図3.6パート  %%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


net = network_example3bus('flow'     ,2,...
                          'comp2'   ,'L_impedance',...
                          'lossless',{'br23'}...
                          );

figure();

%図3_6 地絡に対する角周波数偏差の時間応答 (a) 50 [ms] の地絡
subplot(2, 1, 1)
x_init = net.x_equilibrium;
out = net.simulate([0, 50], 'x0_sys', x_init, 'fault', {{[0, 0.05], 1}});       %bus1を0から0.05まで地絡させた時のシミュレーション 初期値=x_init
plot(out.t, out.X{1}(: ,2), '-b', out.t, out.X{3}(:, 2), '--r')                 %bus1,3の周波数偏差の時系列応答をプロット
ylim([-0.02, 0.02])
subtitle('図3.6 地絡に対する角周波数偏差の時間応答 (a) 50 [ms] の地絡')

%図3_6 地絡に対する角周波数偏差の時間応答 (b) 100 [ms] の地絡
subplot(2, 1, 2)
x_init = net.x_equilibrium;
out = net.simulate([0, 50], 'x0_sys', x_init, 'fault', {{[0, 0.1], 1}});        %bus1を0から0.1まで地絡させた時のシミュレーション 初期値=x_init
plot(out.t, out.X{1}(:, 2), '-b', out.t, out.X{3}(:, 2), '--r')                 %bus1,3の周波数偏差の時系列応答をプロット
ylim([-0.02, 0.02])
subtitle('図3.6 地絡に対する角周波数偏差の時間応答 (b) 100 [ms] の地絡')

end