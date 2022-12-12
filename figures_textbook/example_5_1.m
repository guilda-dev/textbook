function example_5_1()

figure();

%図5_2_消費電力増加に対する角周波数偏差の時間応答 (a) 自動発電制御なし
subplot(2, 1, 1)
net = network_example3bus('flow'     ,2,...
                          'comp2'   ,'L_power',...
                          'lossless',{'br23'});                                 %電力系統モデルを定義(引数の設定内容はREADMEを参照)

x_init = net.x_equilibrium;
u = [0, 0.01, 0.01;
     0,    0,    0];                                                            %負荷モデルにおける有効電力の消費量を1%ずつ増加
out = net.simulate([0, 10, 100], u, 2, 'method', 'foh', 'x0_sys', x_init);      %0から100秒までplot 0から10秒まで1次ホールドで入力 初期値=x_init 定インピーダンス負荷モデルのbus2の抵抗を1%増加させる
plot(out.t,out.X{1}(:, 2), 'b', out.t, out.X{3}(:, 2), '--r')                   %bus1,3の周波数偏差の時系列応答をプロット
ylim([-0.002, 0.002])
subtitle('図5.2 消費電力増加に対する角周波数偏差の時間応答 (a) 自動発電制御なし ')

%図5_2_消費電力増加に対する角周波数偏差の時間応答 (a) 自動発電制御なし
subplot(2, 1, 2)
net = network_example3bus('flow'     ,2,...
                          'comp2'   ,'L_power',...
                          'lossless',{'br23'});                                 %電力系統モデルを定義(引数の設定内容はREADMEを参照)

con = controller_broadcast_PI_AGC(net, [1, 3], [1, 3], -100, -500);             %AGCコントローラを作成
con.set_K_input([1; 3]);                                                        %AGCコントローラの入力ポートの寄与係数を[alpha1;alpha3]=[1;3]に設定
con.set_K_observe([1; 3]);                                                      %AGCコントローラの観測ポートの寄与係数を[beta1;beta3]=[1;3]に設定
net.add_controller_global(con);                                                 %電力系統モデルにAGCコントローラを付加
x_init = net.x_equilibrium;                                                     %シミュレーションの初期値は平衡点のまま
u = [0, 0.01, 0.01;
     0,    0,    0];                                                            %負荷モデルにおける有効電力の消費量を1%ずつ増加
out = net.simulate([0, 10, 100], u, 2, 'method', 'foh', 'x0_sys', x_init);      %0から100秒までplot 0から10秒まで1次ホールドで入力 初期値=x_init 定インピーダンス負荷モデルのbus2の抵抗を1%増加させる
plot(out.t, out.X{1}(:, 2), 'b', out.t, out.X{3}(:, 2), '--r')                  %bus1,3の周波数偏差の時系列応答をプロット
ylim([-0.002, 0.002])
subtitle('図5.2 消費電力増加に対する角周波数偏差の時間応答 (b) 自動発電制御あり ')

end