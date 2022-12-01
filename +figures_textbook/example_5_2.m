function example_5_2()

%図5_3_寄与係数の変化に対する有効電力の時間応答

net = network_example3bus('flow'     ,2,...
                          'comp2'   ,'L_power',...
                          'lossless',{'br23'}...
                          );

con = controller_broadcast_PI_AGC(net, [1, 3], [1, 3], -100, -500);
net.add_controller_global(con);                                                             %AGCコントローラ付加

net.a_bus{1}.component.governor.P = 0;
net.a_bus{3}.component.governor.P = 0;                                                      %母線1,3の発電機のPmechの定常値を0

%0秒から20秒のシミュレーション
net.a_controller_global{1}.set_K_input([1; 1])                                              %AGCパラメータ[alpha1;alpha3]
net.a_controller_global{1}.set_K_observe([1; 1])                                            %AGCパラメータ[beta1;beta3]
x0_system = net.x_equilibrium;                                                              %システムの平衡点に偏差を加えた値を初期値
x0_controller = net.a_bus{2}.P / (2 * net.a_controller_global{1}.Ki);                       %コントローラの平衡点を初期値

out_term{1} = net.simulate([0, 20], 'x0_sys', x0_system, 'x0_con_global', x0_controller);   %解析実行

%20秒から40秒のシミュレーション
net.a_controller_global{1}.set_K_input([1; 3])                                              %AGCパラメータ[alpha1;alpha3]
net.a_controller_global{1}.set_K_observe([1; 3])                                            %AGCパラメータ[beta1;beta3]
x0_system     = tools.vcellfun( @(X) X(end,:).', out_term{1}.X);
x0_controller = tools.vcellfun( @(X) X(end,:).', out_term{1}.Xk_global);                    %term1のシミュレーションの最終値を初期値に
out_term{2} = net.simulate([20, 40], 'x0_sys', x0_system, 'x0_con_global', x0_controller);  %解析実行

%40秒から60秒のシミュレーション
net.a_controller_global{1}.set_K_input([3; 1])                                              %AGCパラメータ[alpha1;alpha3]
net.a_controller_global{1}.set_K_observe([3; 1])                                            %AGCパラメータ[beta1;beta3]
x0_system     = tools.vcellfun( @(X) X(end,:).', out_term{2}.X);
x0_controller = tools.vcellfun( @(X) X(end,:).', out_term{2}.Xk_global);                    %term2のシミュレーションの最終値を初期値に
out_term{3} = net.simulate([40, 60], 'x0_sys', x0_system, 'x0_con_global', x0_controller);  %解析実行

%プロット用にデータを整形      

time = tools.vcellfun(@(out) out.t, out_term);

V = @(out) tools.hcellfun(@(V) V(:, 1)+1j*V(:, 2), out.V);
I = @(out) tools.hcellfun(@(I) I(:, 1)+1j*I(:, 2), out.I);
PQ = @(out)  V(out) .* conj(I(out));
PQ = tools.vcellfun(@(out) PQ(out), out_term);
P = real(PQ);

figure()

%(a) 青実線:P1, 赤波線:P3 
subplot(1, 2, 1)
plot(time, P(:, 1), 'b', time, P(:, 3), '--r')
ylim([-1, 4])
subtitle('(a) 青実線:P1, 赤波線:P3 ')

%(b) 送電損失 P1+P2+P3
subplot(1, 2, 2)
plot(time, P(:, 1) + P(:, 2) + P(:, 3), 'b')
ylim([0, 0.03])
subtitle('(b) 送電損失 P1+P2+P3')

end