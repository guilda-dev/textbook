function example_5_5()
        
    net = network_example3bus('flow'     ,1,...
                              'comp2'   ,'L_impedance',...
                              'lossless',{'br23'} );


    %AVRの定義
    t_tr = 0.015; k_ap = 200; k0 = 0.04; 
    gamma_max = 7; gamma_min = -6.4;
    avr_para = table(t_tr,k_ap,k0,gamma_max,gamma_min);
    net.a_bus{1}.component.set_avr(avr_IEEE_ST1(avr_para));
    net.a_bus{3}.component.set_avr(avr_IEEE_ST1(avr_para));

    %PSSの定義
    Kpss = 20; Tws = 10;
    Td1 = 0.02; Tn1 = 0.05; Td2 = 5.40; Tn2 = 3.00;
    Vpss_max = Inf; Vpss_min = -Inf;
    pss_para = table(Kpss,Tws,Td1,Tn1,Td2,Tn2,Vpss_max ,Vpss_min);
    net.a_bus{1}.component.set_pss(pss_IEEE_PSS1(pss_para));
    net.a_bus{3}.component.set_pss(pss_IEEE_PSS1(pss_para));
    
    net.initialize();


    % 指定された平衡点に合う入力定常値を計算
    delta_equilibrium = [pi/6,0];
    E_equilibrium     = net.x_equilibrium([3,6]);
    [Pmech,Vfield,V] = culculate_PmVfd(net,delta_equilibrium,E_equilibrium);
    net.a_bus{1}.component.governor.P  = Pmech(1);
    net.a_bus{3}.component.governor.P  = Pmech(2);
    net.a_bus{1}.component.avr.initialize( Vfield(1), abs(V(1)));
    net.a_bus{3}.component.avr.initialize( Vfield(2), abs(V(2)));

    % シミュレーション(AVRなしver)
        x_init = net.x_equilibrium;
        x_init(1) = 0;
        x_init(4) = abs(V(1));
        x_init(net.a_bus{1}.component.get_nx+4) = abs(V(2));
    
        % δの初期値: δ3-δ1 = -1 の時
        x_init(net.a_bus{1}.component.get_nx+1) = -1;
        out_1 = net.simulate([0,50], 'x0_sys', x_init);                     %0から50秒まで 初期値=x_init
            
        % δの初期値: δ3-δ1 = -pi/2 の時
        x_init(net.a_bus{1}.component.get_nx+1) = -pi/2;
        out_pi2 = net.simulate([0,50], 'x0_sys', x_init);                     %0から50秒まで 初期値=x_init

    

    % 図5.12のプロット
    figure('Position',[100,150,850,250])
    subplot(1,2,1)
    myplot(out_1)
    xlabel('(a) δ1(0)-δ3(0) = -1')
    subplot(1,2,2)
    myplot(out_pi2)
    xlabel('(b) δ1(0)-δ3(0) = -1.57')
    sgtitle('図5.12 角周波数偏差の初期値応答 (初期値:δ13=-1)')

end

function myplot(out)
    plot(out.t, out.X{3}(:, 2), '--r', out.t, out.X{1}(:, 2), '-b','LineWidth',1.5);
    xlim([0,50])
    ylim([-0.03,0.03])
    grid on
end

function [Pmech,Vfield,V] = culculate_PmVfd(net,delta,E)

    Y = net.get_admittance_matrix();
    load_idx = tools.vcellfun(@(bus) isa(bus.component,'load_impedance'), net.a_bus);
    y_load   = tools.varrayfun(@(i) net.a_bus{i}.component.Y, find(load_idx));
    Y        = Y(~load_idx,~load_idx) - Y(~load_idx,load_idx) * inv(Y(load_idx,load_idx)-diag(y_load)) * Y(load_idx,~load_idx);

    gen_idx = tools.vcellfun(@(bus) isa(bus.component,'generator_1axis'), net.a_bus);
    gen_idx = find(gen_idx);
    X       = tools.varrayfun(@(i) net.a_bus{i}.component.parameter{:,'Xd'},gen_idx);
    X_prime = tools.varrayfun(@(i) net.a_bus{i}.component.parameter{:,'Xd_prime'},gen_idx);
    
    gamma = diag(X_prime) - 1j* diag(X_prime) * conj(Y) * diag(X_prime);
    Yred  = -1j * inv(gamma);
    Gred  = real(Yred);
    Bred  = imag(Yred);
    
    gen_num = numel(delta);
    d = @(i,j) delta(i) - delta(j);
    f = @(i) - E(i) * sum( tools.varrayfun(@(j) E(j) * (Bred(i,j)*sin(d(i,j)) - Gred(i,j)*cos(d(i,j))), 1:gen_num));
    g = @(i)        - sum( tools.varrayfun(@(j) E(j) * (Bred(i,j)*cos(d(i,j)) + Gred(i,j)*sin(d(i,j))), 1:gen_num));
    
    Pmech  = tools.varrayfun(@(i) f(i), 1:gen_num);
    Vfield = tools.varrayfun(@(i) X(i)/X_prime(i)*E(i) -(X(i)-X_prime(i))*g(i),1:gen_num);

    V = inv(diag(1./(1j*X_prime))+Y) * diag(exp(1j*delta(:))./(1j*X_prime(:))) *E;
end