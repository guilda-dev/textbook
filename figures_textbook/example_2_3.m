function example_2_3()


net = network_example3bus('flow'     ,0,...
                          'comp2'   ,'Gen_1axis',...
                          'lossless',{}...
                          );

x_init = net.x_equilibrium;
x_init(1) = x_init(1) + pi/6;                                                                       %bus1の周波数偏差の初期値(平衡点)を+pi/6
x_init(3) = x_init(3) + 0.1;                                                                        %bus1の内部電圧の初期値(平衡点)を+0.1

a_color = {'b', 'k', 'r'};



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%  図2.10パート  %%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

out = net.simulate([0, 30], 'x0_sys', x_init);                                                      %0から30秒まで 初期値=x_init 

figure();

%%図2_10(a) 初期値に摂動を加えた場合の時間応答 
subplot(2, 2, 1)
plot(out.t, out.X{1}(:, 2), 'b', out.t, out.X{2}(:, 2), 'k', out.t, out.X{3}(:, 2), 'r')            %bus1,2,3の周波数偏差を時系列プロット
subtitle('図2.10(a) 初期値に摂動を加えた場合の時間応答')

%%図2_10(b) 初期値に摂動を加えた場合の時間応答
subplot(2, 2, 2)
hold on
for i = 1:3
    plot(out.t, wrapTo2Pi(out.X{i}(:, 1)), a_color{i})
    plot(out.t, wrapTo2Pi(angle(out.V{i}(:, 1) + 1j*out.V{i}(:, 2))), strcat('--', a_color{i}))     %bus1,2,3を実線：δi，破線：∠Viとして時系列プロット
end
ylim([0, 6])
subtitle('図2.10(b) 初期値に摂動を加えた場合の時間応答')

%%図2_10(c) 初期値に摂動を加えた場合の時間応答
subplot(2, 2, 3)
hold on
for i = 1:3
    plot(out.t, out.X{i}(:, 3), a_color{i})
    plot(out.t, abs(out.V{i}(:, 1) + 1j * out.V{i}(:, 2)), strcat('--', a_color{i}))                %bus1,2,3を実線：Ei,破線：|Vi|として時系列プロット
end
ylim([0, 2])
subtitle('図2.10(c) 初期値に摂動を加えた場合の時間応答')

%%図2_10(d) 初期値に摂動を加えた場合の時間応答
subplot(2, 2, 4)
hold on
V = tools.hcellfun(@(V) V(:, 1)+1j*V(:, 2), out.V);
I = tools.hcellfun(@(I) I(:, 1)+1j*I(:, 2), out.I);
PQ = V .* conj(I);
P = real(PQ);
Q = imag(PQ);
for i = 1:3
    plot(out.t, P(:, i), a_color{i})
    plot(out.t, Q(:, i), strcat('--', a_color{i}))                                                  %bus1,2,3を 実線：Pi，破線：Qiとして時系列プロット
end
ylim([-1.5, 1.5])
subtitle('図2,10(d) 初期値に摂動を加えた場合の時間応答')






%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%  図2.11パート  %%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

u = [0.05, 0.05;
        0,    0];
out = net.simulate([0,30], u, 1, 'x0_sys', x_init);

figure();

%%図2_11(a) 機械入力に摂動を加えた場合の時間応答
subplot(2, 2, 1)
plot(out.t, out.X{1}(:, 2), 'b', out.t, out.X{2}(:, 2), 'k', out.t, out.X{3}(:, 2), 'r')            %bus1,2,3の周波数偏差を時系列プロット
subtitle('図2.11(a) 機械入力に摂動を加えた場合の時間応答')

%%図2_11(b) 機械入力に摂動を加えた場合の時間応答
subplot(2, 2, 2)
hold on
for i = 1:3
    plot(out.t, wrapTo2Pi(out.X{i}(:, 1)), a_color{i})
    plot(out.t, wrapTo2Pi(angle(out.V{i}(:, 1) + 1j*out.V{i}(:, 2))), strcat('--', a_color{i}))     %bus1,2,3を実線：δi，破線：∠Viとして時系列プロット
end
ylim([0, 6])
subtitle('図2.11(b) 機械入力に摂動を加えた場合の時間応答')

%%図2_11(c) 機械入力に摂動を加えた場合の時間応答
subplot(2, 2, 3)
hold on
for i = 1:3
    plot(out.t, out.X{i}(:, 3), a_color{i})
    plot(out.t, abs(out.V{i}(:, 1) + 1j * out.V{i}(:, 2)), strcat('--', a_color{i}))                %bus1,2,3を実線：Ei,破線：|Vi|として時系列プロット
end
ylim([0, 2])
subtitle('図2.11(c) 機械入力に摂動を加えた場合の時間応答')

%%図2_11(d) 機械入力に摂動を加えた場合の時間応答
subplot(2, 2, 4)
hold on
V = tools.hcellfun(@(V) V(:, 1)+1j*V(:, 2), out.V);
I = tools.hcellfun(@(I) I(:, 1)+1j*I(:, 2), out.I);
PQ = V .* conj(I);
P = real(PQ);
Q = imag(PQ);
for i = 1:3
    plot(out.t, P(:, i), a_color{i})
    plot(out.t, Q(:, i), strcat('--', a_color{i}))                                                  %bus1,2,3を 実線：Pi，破線：Qiとして時系列プロット
end
ylim([-1.5, 1.5])
subtitle('図2.11(d) 機械入力に摂動を加えた場合の時間応答')






%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%  図2.12パート  %%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

u = [   0,    0;
     0.05, 0.05];
out=net.simulate([0, 30], u, 1, 'x0_sys', x_init);

figure();

%%図2_12(a) 界磁電圧に摂動を加えた場合の時間応答
subplot(2, 2, 1)
plot(out.t, out.X{1}(:, 2), 'b', out.t, out.X{2}(:, 2), 'k', out.t, out.X{3}(:, 2), 'r')            %bus1,2,3の周波数偏差を時系列プロット
subtitle('図2.12(a) 界磁電圧に摂動を加えた場合の時間応答')

%%図2_12(b) 界磁電圧に摂動を加えた場合の時間応答
subplot(2, 2, 2)
hold on
for i = 1:3
    plot(out.t, wrapTo2Pi(out.X{i}(:, 1)), a_color{i})
    plot(out.t, wrapTo2Pi(angle(out.V{i}(:, 1) + 1j*out.V{i}(:, 2))), strcat('--', a_color{i}))     %bus1,2,3を実線：δi，破線：∠Viとして時系列プロット
end
ylim([0, 6])
subtitle('図2.12(b) 界磁電圧に摂動を加えた場合の時間応答')

%%図2_12(c) 界磁電圧に摂動を加えた場合の時間応答
subplot(2, 2, 3)
hold on
for i = 1:3
    plot(out.t, out.X{i}(:, 3), a_color{i})
    plot(out.t, abs(out.V{i}(:, 1) + 1j * out.V{i}(:, 2)), strcat('--', a_color{i}))                %bus1,2,3を実線：Ei,破線：|Vi|として時系列プロット
end
ylim([0, 2])
subtitle('図2.12(c) 界磁電圧に摂動を加えた場合の時間応答')

%%図2_12(d) 界磁電圧に摂動を加えた場合の時間応答
subplot(2, 2, 4)
hold on
V = tools.hcellfun(@(V) V(:, 1)+1j*V(:, 2), out.V);
I = tools.hcellfun(@(I) I(:, 1)+1j*I(:, 2), out.I);
PQ = V .* conj(I);
P = real(PQ);
Q = imag(PQ);
for i = 1:3
    plot(out.t, P(:, i), a_color{i})
    plot(out.t, Q(:, i), strcat('--', a_color{i}))                                                  %bus1,2,3を 実線：Pi，破線：Qiとして時系列プロット
end
ylim([-1.5, 1.5])
subtitle('図2.12(d) 界磁電圧に摂動を加えた場合の時間応答')

end