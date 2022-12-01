function example_4_2()



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%  図4.2パート  %%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%近似線形モデルの初期値応答

net = network_example3bus('flow'     ,0,...
                          'comp2'   ,'Gen_1axis',...
                          'lossless',{}...
                          );

x_init = net.x_equilibrium;
x_init(1) = x_init(1) + pi/6;                                                                       %bus1の周波数偏差の初期値(平衡点)を+pi/6
x_init(3) = x_init(3) + 0.1;                                                                        %bus1の内部電圧の初期値(平衡点)を+0.1
out = net.simulate([0, 30], 'x0_sys', x_init, 'linear', false);                                     %0から30秒まで 初期値=x_init 

a_color = {'b', 'k', 'r'};

figure();
sgtitle('図4.2');

%%図4_2(a) 近似値モデルの初期値応答
subplot(2, 2, 1)
hold on
for bus_idx = 1:3
    omega_equilibrium = net.a_bus{bus_idx}.component.x_equilibrium(2);
    plot(out.t, out.X{bus_idx}(:, 2) - omega_equilibrium, a_color{bus_idx})                         %bus1,2,3の∆ω^{lin}を時系列プロット
end
ylim([-0.005, 0.005])
subtitle('(a) $\Delta\omega^{\rm{lin}}$', 'Interpreter', 'latex')

%%図4_2(b) 近似値モデルの初期値応答
subplot(2, 2, 2)
hold on
for bus_idx = 1:3
    omega_equilibrium = net.a_bus{bus_idx}.component.x_equilibrium(1);
    plot(out.t, out.X{bus_idx}(:, 1) - omega_equilibrium, a_color{bus_idx})                         %bus1,2,3のδi^{lin}を時系列プロット
end
ylim([-pi, pi])
subtitle('(b) $\delta^{lin}$', 'Interpreter', 'latex')

%%図4_2(c) 近似値モデルの初期値応答
subplot(2, 2, 3)
hold on
for bus_idx = 1:3
    omega_equilibrium = net.a_bus{bus_idx}.component.x_equilibrium(3);
    plot(out.t, out.X{bus_idx}(:, 3) - omega_equilibrium, a_color{bus_idx})                         %bus1,2,3のδEi^{lin}を時系列プロット
end
ylim([-1 1])
subtitle('(c) $E^{lin}$', 'Interpreter', 'latex')

%%図4_2(d) 近似値モデルの初期値応答
subplot(2, 2, 4)
hold on
V = tools.hcellfun(@(V) V(:, 1)+1j*V(:, 2), out.V);
I = tools.hcellfun(@(I) I(:, 1)+1j*I(:, 2), out.I);
PQ = V .* conj(I);
P = real(PQ);
for bus_idx = 1:3
    PQ_equilibrium = net.a_bus{bus_idx}.V_equilibrium .* conj(net.a_bus{bus_idx}.I_equilibrium);
    plot(out.t, P(:,bus_idx) - real(PQ_equilibrium), a_color{bus_idx})                              %bus1,2,3を実線：Pi^{lin}として時系列プロット
end
ylim([-1.5, 1.5])
subtitle('(d) $P^{lin}$', 'Interpreter', 'latex')



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%  図4.3パート  %%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

disp('"example_4_6.m" と同様')

end
