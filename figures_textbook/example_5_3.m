function example_5_3()

    fig = figure('position',[100,100,950,300]);
    net = network_example3bus('flow'     ,2,...
                          'comp2'   ,'L_power',...
                          'lossless',{'br12','br23'}...
                          );


    %PIコントローラを母線1,3の発電機に付加
    PIcon = controller_broadcast_PI_AGC(net,[1,3],[1,3],-100,-500);
    PIcon.set_K_input([1;1]);
    PIcon.set_K_observe([1;1]);
    net.add_controller_global(PIcon);



    %表5.2の左の表に対応する潮流設定のネットワークの平衡点を取得する
        net.a_bus{1}.set_Vangle(0); net.a_bus{1}.set_Vabs(2);
        net.a_bus{2}.set_P(-3);     net.a_bus{2}.set_Q(0);
        net.a_bus{3}.set_P(0.5);    net.a_bus{3}.set_Vabs(2);
        net.initialize
        xinit_1 = net.x_equilibrium;
        x0_controller = net.a_bus{2}.P / (2 * net.a_controller_global{1}.Ki);
    
        %各発電機の入力の定常値を0にセット
        net.a_bus{1}.component.governor.P = 0;
        net.a_bus{3}.component.governor.P = 0;
    
        %xinit_1の初期値に対しての応答をシミュレート
        out1 = net.simulate([0,5],'x0_sys',xinit_1,'x0_con_global',x0_controller);
        subplot(1,2,1)
        storage_func(out1,net);




    %表5.2の左の表に対応する潮流設定のネットワークの平衡点を取得する
        net.a_bus{1}.set_Vangle(-0.0488);   net.a_bus{1}.set_Vabs(2);
        net.a_bus{2}.set_P(-3);             net.a_bus{2}.set_Q(0);
        net.a_bus{3}.set_P(2.5);            net.a_bus{3}.set_Vabs(2);
        net.initialize
        xinit_2 = net.x_equilibrium;
        x0_controller = net.a_bus{2}.P / (2 * net.a_controller_global{1}.Ki);
        
        %各発電機の入力の定常値を0にセット
        net.a_bus{1}.component.governor.P = 0;
        net.a_bus{3}.component.governor.P = 0;
        
        %xinit_2の初期値に対しての応答をシミュレート
        out2 = net.simulate([0,5],'x0_sys',xinit_2,'x0_con_global',x0_controller);
        subplot(1,2,2)
        storage_func(out2,net);

end


function [W,WF,WG,Wxi] = storage_func(out,net)

    %ネットワークのパラメータを取得
    Y = net.get_admittance_matrix;
    B = imag(Y);
    omega0 = 2*pi*60;

    %発電機バスと負荷バスのインデックスを取得
    gen_idx   = tools.vcellfun(@(bus)  isa(bus.component,'generator_1axis'),net.a_bus);
    load_idx  = tools.vcellfun(@(bus) contains(class(bus.component),'load'),net.a_bus);
    
    %各バスの有効電力/無効電力の平衡点を取得
    V_st     = tools.vcellfun(@(bus) bus(end,1)+1j*bus(end,2), out.V);
    I_st     = tools.vcellfun(@(bus) bus(end,1)+1j*bus(end,2), out.I);
    PQ_st    = V_st .* conj(I_st);
    %V_st  = tools.vcellfun(@(bus) bus.V_equilibrium, net.a_bus);
    %PQ_st    = tools.vcellfun(@(bus) bus.V_equilibrium * conj(bus.I_equilibrium), net.a_bus);
    Vabs_st  = abs(V_st);
    Vangle_st= angle(V_st);
    P_st     = real(PQ_st);
    Q_st     = imag(PQ_st);

    %各発電機の状態の平衡点を取得
    %x_st     = tools.varrayfun(@(idx) net.a_bus{idx}.component.x_equilibrium(:).',find(gen_idx));
    x_st     = tools.varrayfun(@(idx) out.X{idx}(end,:),find(gen_idx));
    delta_st = nan(size(out.X));
    omega_st = nan(size(out.X));
    E_st     = nan(size(out.X));
    delta_st(gen_idx) = x_st(:,1);
    omega_st(gen_idx) = x_st(:,2);
        E_st(gen_idx) = x_st(:,3);

    %各発電機のパラメータを取得
       para   = tools.varrayfun(@(idx) net.a_bus{idx}.component.parameter, find(gen_idx));
        M     = nan(size(out.X));
        X     = nan(size(out.X));
      X_prime = nan(size(out.X));
          M(gen_idx) = para{:,'M'};
          X(gen_idx) = para{:,'Xd'};
    X_prime(gen_idx) = para{:,'Xd_prime'};
    

    %コントローラの状態・パラメータを取得
    PIcon_idx = tools.vcellfun(@(con) isa(con,'controller_broadcast_PI_AGC'),net.a_controller_global);
    KI = tools.varrayfun(@(idx) abs(net.a_controller_global{idx}.Ki),find(PIcon_idx));
    xi_st = tools.vcellfun(@(con) con(end), out.Xk_global);
    % xi_st = zeros(sum(PIcon_idx),1);

    
    %電気サブシステムGのポテンシャルエネルギー関数(UG)の定義
        %UGの第１項
        UG1_i = @(i, delta,E,Vabs,Vangle) X(i)*E(i)^2/(2*X_prime(i)*(X(i)-X_prime(i))) - E(i)*Vabs(i)/X_prime(i)*cos(delta(i)-Vangle(i)) + Vabs(i)^2/(2*X_prime(i));
        UG1   = @(delta,E,Vabs,Vangle) sum(tools.varrayfun(@(i) UG1_i(i,delta,E,Vabs,Vangle), find(gen_idx)));
        %UGの第２項
        UG2   = @(Vabs,Vangle) sum(tools.varrayfun(@(i) P_st(i)*Vangle(i) + Q_st(i)*log(Vabs(i)) ,find(load_idx)));
        %UGの第３項
        UG3   = @(Vabs,Vangle) sum( (diag(Vabs)*B/2*diag(Vabs)) .* cos(Vangle-Vangle.'),"all");
        %UGの第１項〜第３項をまとめる
        UG    = @(delta,E,Vabs,Vangle) UG1(delta,E,Vabs,Vangle) - UG2(Vabs,Vangle) - UG3(Vabs,Vangle);
        % UGをδで偏微分したベクトル
        rUGrdelta = @(delta,E,Vabs,Vangle) tools.harrayfun(@(i) E(i)*Vabs(i)/X_prime(i)*sin(delta(i)-Vangle(i)),find(gen_idx));
        % UGをEで偏微分したベクトル
        rUGrE     = @(delta,E,Vabs,Vangle) tools.harrayfun(@(i) -1/(X(i)-X_prime(i))*(-X(i)/X_prime(i)*E(i)+(X(i)/X_prime(i)-1)*Vabs(i)*cos(delta(i)-Vangle(i))),find(gen_idx));
        %平衡点におけるUGの値
        UG_st = UG(delta_st,E_st,Vabs_st,Vangle_st);
        
    %変数の準備
    num_sample = numel(out.t);
    WF    = zeros(num_sample,1);
    WG    = zeros(num_sample,1);
    Wxi   = zeros(num_sample,1);
    delta = nan(size(out.X));
    omega = nan(size(out.X));
      E   = nan(size(out.X));

    for tidx = 1:numel(out.t) %各サンプル毎に蓄積関数を計算

        %状態の取得
        x      = tools.varrayfun(@(idx) out.X{idx}(tidx,:),find(gen_idx));
        delta(gen_idx) = x(:,1);
        omega(gen_idx) = x(:,2);
            E(gen_idx) = x(:,3);
        V      = tools.vcellfun(@(V) V(tidx,1) + 1j*V(tidx,2),out.V);
        Vabs   = abs(V);
        Vangle = angle(V);

        %機械サブシステムFの蓄積関数(WF)の値を求める。
        WF(tidx)  = omega0/2 * (omega(gen_idx)-omega_st(gen_idx)).' * diag(M(gen_idx)) * (omega(gen_idx)-omega_st(gen_idx));

        %電気サブシステムGの蓄積関数(WG)の値を求める
        WG(tidx) =  UG(delta,E,Vabs,Vangle) ...
                   -UG_st ...
                   -rUGrdelta(delta_st,E_st,Vabs_st,Vangle_st) * (delta(gen_idx)-delta_st(gen_idx))...
                   -    rUGrE(delta_st,E_st,Vabs_st,Vangle_st) * (    E(gen_idx)-    E_st(gen_idx));
        if numel(KI)~=0
            xi        = tools.vcellfun(@(con) con(tidx), out.Xk_global);
            Wxi(tidx) = 1/2 * omega0 * (xi-xi_st).' * diag(KI) * (xi-xi_st); 
        end
    end
    W = WF + WG + Wxi;

    
    Wplot = @(Wdata,lintype,color) plot(out.t,Wdata,lintype,'LineWidth',2,'Color',color);
    


    hold on 
    Wplot(W,'.','k')
    Wplot(WF,'-','#0072BD')
    Wplot(WG,'-','#D95319')
    Wplot(Wxi,'-','#77AC30')
    xlabel('Time(s)','FontSize',15)
    legend({'W','WF','WG','Wxi'})
    ylim([0,4])
    xlim([0,5])
    grid on
    hold off
end