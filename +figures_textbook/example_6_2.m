function example_6_2()

    %IEEE68busモデルを呼び出す
    net = network_IEEE68bus;

    %既存のAVR,PSSを一度外す
    arrayfun(@(i) net.a_bus{i}.component.set_avr(avr()), 1:16);
    arrayfun(@(i) net.a_bus{i}.component.set_pss(pss()), 1:16);
    net.initialize;
    

    load_bus_idx = tools.hcellfun(@(bus) isa(bus.component,'load_impedance'), net.a_bus);
    load_bus_idx = find(load_bus_idx);
    
    %使用するプロット用の関数のプロパティを指定しておく
    myplot = @(x,y) plot(x,y,'LineWidth',1,'Color','#0072BD');
    mypolarplot = @(x,y) polarplot(x,y,'LineWidth',2);



    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%  図6.2パート  %%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    t = [0,15];                                                             %シミュレーション時間は15秒
    load_percentage = ones(2*numel(load_bus_idx),1) * [0,15/36000];         %負荷変動の速度は、10[%]/時間

    figure();

    %１つ目のシミュレーション：入力が定常値の場合の負荷変動に対する応答
        out = net.simulate(t,load_percentage,load_bus_idx,'method','foh');
        subplot(2,2,1)
        hold on
        arrayfun(@(i) myplot(out.t,out.X{i}(:,2)), 1:16)
        xlim([0,15]);ylim([-2*1e-5,2*1e-5]); grid on;


    %２つ目のシミュレーション：IEEE_ST1型のAVRとIEEE_PSS1型のPSSを付加した場合の応答    
        %AVRの定義
        t_tr = 0.015; k_ap = 20; k0 = 0; 
        gamma_max = Inf; gamma_min = -Inf;
        avr_para = table(t_tr,k_ap,k0,gamma_max,gamma_min);
        arrayfun(@(i) net.a_bus{i}.component.set_avr(avr_IEEE_ST1(avr_para)), 1:16);
    
        %PSSの定義
        Kpss = 9.5; Tws = 1.4;
        Td1 = 0.033; Tn1 = 0.033*4.67; Td2 = 1e-6; Tn2 = 1e-6;
        Vpss_max = Inf; Vpss_min = -Inf;
        pss_para = table(Kpss,Tws,Td1,Tn1,Td2,Tn2,Vpss_max ,Vpss_min);
        arrayfun(@(i) net.a_bus{i}.component.set_pss(pss_IEEE_PSS1(pss_para)), 1:16);
        
        net.initialize
        out = net.simulate(t,load_percentage,load_bus_idx,'method','foh');      %シミュレーションの実行
        subplot(2,2,2)
        hold on
        arrayfun(@(i) myplot(out.t,out.X{i}(:,2)), 1:16)
        xlim([0,15]);ylim([-4*1e-5,0]);grid on;

    %３つ目のシミュレーション：AGCを付加した場合の応答
%         net = network_IEEE68bus;
%         arrayfun(@(i) net.a_bus{i}.component.set_avr(avr()), 1:16);             %PSSとAVRを取り外す
%         arrayfun(@(i) net.a_bus{i}.component.set_pss(pss()), 1:16);  
%         net.initialize;

        AGC = controller_broadcast_PI_AGC(net,1:16,1:16,-100,-500);             %母線1~16に取り付ける自動発電制御器(AGC)を定義
        Pstar = tools.varrayfun(@(i) net.a_bus{i}.component.governor.P,1:16);   %各発電機のPmechの定常値を抽出
        AGC.set_K_input(Pstar/mean(Pstar));                                     %AGCの各発電機への寄与係数を定義
        net.add_controller_global(AGC);                                         %AGCを系統モデルにセット
        out = net.simulate(t,load_percentage,load_bus_idx,'method','foh');      %定義したモデルで付加変動に対する応答をシミュレート
        subplot(2,2,3)
        hold on
        arrayfun(@(i) myplot(out.t,out.X{i}(:,2)), 1:16)
        xlim([0,15]);ylim([-4*1e-5,0]); grid on;
        subplot(2,2,4)
        hold on
        arrayfun(@(i) myplot(out.t,out.X{i}(:,2)), 1:16)
        xlim([0,15]);ylim([-1e-6,0]); grid on;


        
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%  図6.3パート  %%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    %系統モデルは上の図6.2パートの３つ目のシミュレーションと同様であるため、系統モデルはそのまま使う

    t = [0,3*60*60];                                                        %シミュレーション時間は3時間
    load_percentage = ones(2*numel(load_bus_idx),1) * [0,3*60*60/36000];    %負荷変動の速度は、10[%]/時間
    out = net.simulate(t,load_percentage,load_bus_idx,'method','foh');      %シミュレーション実行

    %出力結果の各データを呼び出す関数を定義
    E     = @(i) out.X{i}(:,3);
    delta = @(i) out.X{i}(:,1);
    V = @(i) out.V{i}(:,1) + 1j * out.V{i}(:,2);
    I = @(i) out.I{i}(:,1) + 1j * out.I{i}(:,2);
    PjQ = @(i) V(i) .* conj(I(i));

    figure;
    %各発電機の「回転子偏角」と「内部電圧」の極座標プロット
    subplot(2,2,1)
    mypolarplot(delta(1),E(1))
    hold on
    arrayfun(@(i) mypolarplot(delta(i),E(i)), 2:16)

    %各母線電圧の「偏角」と「絶対値」の極座標プロット
    subplot(2,2,2)
    mypolarplot(angle(V(2)),abs(V(2)))
    hold on
    arrayfun(@(i) mypolarplot(angle(V(i)),abs(V(i))), 2:16)

    %各母線電流の「偏角」と「絶対値」の極座標プロット
    subplot(2,2,3)
    mypolarplot(angle(I(3)),abs(I(3)))
    hold on
    arrayfun(@(i) mypolarplot(angle(I(i)),abs(I(i))), 2:16)

    %各母線の「力率」と「皮相電力」の極座標プロット
    subplot(2,2,4)
    mypolarplot(angle(PjQ(1)),abs(PjQ(1)))
    hold on
    arrayfun(@(i) mypolarplot(angle(PjQ(i)),abs(PjQ(i))), 2:16)

end