function example_5_1()

figure();

%図5_2_消費電力増加に対する角周波数偏差の時間応答 (a) 自動発電制御なし
subplot(2, 1, 1)
net = network_example3bus('flow'     ,2,...
                          'comp2'   ,'L_power',...
                          'lossless',{'br23'}...
                          );
x_init = net.x_equilibrium;
u = [0, 0.01, 0.01;
     0,    0,    0];                                                            %有効電力の消費量を1%ずつ増加
out = net.simulate([0, 10, 100], u, 2, 'method', 'foh', 'x0_sys', x_init);      %0から100秒までplot 0から10秒まで1次ホールドで入力 初期値=x_init 定インピーダンス負荷モデルのbus2の抵抗を1%増加させる
plot(out.t,out.X{1}(:, 2), 'b', out.t, out.X{3}(:, 2), '--r')                   %bus1,3の周波数偏差の時系列応答をプロット
ylim([-0.002, 0.002])
subtitle('図5.2 消費電力増加に対する角周波数偏差の時間応答 (a) 自動発電制御なし ')

%図5_2_消費電力増加に対する角周波数偏差の時間応答 (a) 自動発電制御なし
subplot(2, 1, 2)
net = network_example3bus('flow'     ,2,...
                          'comp2'   ,'L_power',...
                          'lossless',{'br23'}...
                          );
con = controller_broadcast_PI_AGC(net, [1, 3], [1, 3], -100, -500);             %AGCコントローラ付与
con.set_K_input([1; 3]);                                                        %AGCパラメータ[alpha1;alpha3]
con.set_K_observe([1; 3]);                                                      %AGCパラメータ[beta1;beta3]
net.add_controller_global(con);
x_init = net.x_equilibrium;
u = [0, 0.01, 0.01;
     0,    0,    0];                                                            %有効電力の消費量を1%ずつ増加
out = net.simulate([0, 10, 100], u, 2, 'method', 'foh', 'x0_sys', x_init);      %0から100秒までplot 0から10秒まで1次ホールドで入力 初期値=x_init 定インピーダンス負荷モデルのbus2の抵抗を1%増加させる
plot(out.t, out.X{1}(:, 2), 'b', out.t, out.X{3}(:, 2), '--r')                  %bus1,3の周波数偏差の時系列応答をプロット
ylim([-0.002, 0.002])
subtitle('図5.2 消費電力増加に対する角周波数偏差の時間応答 (b) 自動発電制御あり ')

end