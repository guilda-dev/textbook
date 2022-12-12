function example_3_4()


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%  図3.3パート  %%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

net = network_example3bus('flow'     ,1,...
                          'comp2'   ,'L_impedance',...
                          'lossless',{'br23'});                                 %ネットワークを定義

figure();

%図3_3_負荷の変化に対する角周波数偏差の時間応答 (a) 抵抗が1%増加した場合 
subplot(2, 1, 1)
x_init = net.x_equilibrium;
u = [0, 0.01, 0.01;
     0, 0.01, 0.01];                                                            %実数と虚数それぞれに値が必要 1%ずつ増加
out = net.simulate([0, 10, 100], u, 2, 'method', 'foh', 'x0_sys', x_init);      %0から100秒までplot 0から10秒まで1次ホールドで入力 初期値=x_init 定インピーダンス負荷モデルのbus2の抵抗を1%増加させる
plot(out.t, out.X{1}(:, 2), '-b', out.t, out.X{3}(:, 2), '--r')                 %bus1,3の周波数偏差の時系列応答をプロット
ylim([-0.001, 0])
subtitle('図3.3 負荷の変化に対する角周波数偏差の時間応答 (a) 抵抗が1%増加した場合 ')

%図3_3_負荷の変化に対する角周波数偏差の時間応答 (b) 抵抗が1%減少した場合 
subplot(2, 1, 2)
u = [0, -0.01, -0.01;
     0, -0.01, -0.01];                                                          %実数と虚数それぞれに値が必要 1%ずつ減少
out = net.simulate([0, 10, 100], u, 2, 'method', 'foh', 'x0_sys', x_init);      %0から100秒までplot 0から10秒まで1次ホールドで入力 初期値=x_init 定インピーダンス負荷モデルのbus2の抵抗を1%減少させる
plot(out.t, out.X{1}(:, 2), '-b', out.t, out.X{3}(:, 2), '--r')                 %bus1,3の周波数偏差の時系列応答をプロット
ylim([0, 0.001])
subtitle('図3.3 負荷の変化に対する角周波数偏差の時間応答 (b) 抵抗が1%減少した場合 ')




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%  図3.4パート  %%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


net = network_example3bus('flow'     ,2,...
                          'comp2'   ,'L_impedance',...
                          'lossless',{'br23'});                                 %ネットワークを定義

figure();

%図3_4_負荷の変化に対する角周波数偏差の時間応答 (a) 抵抗が1%増加した場合 
subplot(2, 1, 1)
x_init = net.x_equilibrium;
u = [0, 0.01, 0.01;
     0, 0.01, 0.01];                                                            %負荷モデルへの入力値の設定には実数と虚数それぞれに対する値が必要 1%ずつ増加
out = net.simulate([0, 10, 100], u, 2, 'method', 'foh', 'x0_sys', x_init);      %0から100秒までplot 0から10秒まで1次ホールドで入力 初期値=x_init 定インピーダンス負荷モデルのbus2の抵抗を1%増加させる
plot(out.t, out.X{1}(:, 2), '-b',out.t, out.X{3}(:, 2), '--r')                  %bus1,3の周波数偏差の時系列応答をプロット
ylim([-0.001, 0])
subtitle('図3.4 負荷の変化に対する角周波数偏差の時間応答 (a) 抵抗が1%増加した場合 ')

%図3_4_負荷の変化に対する角周波数偏差の時間応答 (b) 抵抗が1%減少した場合 
subplot(2, 1, 2)
u = [0, -0.01, -0.01;
     0, -0.01, -0.01];                                                          %負荷モデルへの入力値の設定には実数と虚数それぞれに対する値が必要 1%ずつ減少
out = net.simulate([0, 10, 100], u, 2, 'method', 'foh', 'x0_sys', x_init);      %0から100秒までplot 0から10秒まで1次ホールドで入力 初期値=x_init 定インピーダンス負荷モデルのbus2の抵抗を1%減少させる
plot(out.t, out.X{1}(:, 2), '-b', out.t, out.X{3}(:, 2), '--r')                 %bus1,3の周波数偏差の時系列応答をプロット
ylim([0, 0.001])
subtitle('図3.4 負荷の変化に対する角周波数偏差の時間応答 (b) 抵抗が1%減少した場合 ')

end