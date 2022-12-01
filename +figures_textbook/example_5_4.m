function [Out,Out_avr] = example_5_4()


net = network_example3bus('flow'     ,1,...
                          'comp2'   ,'L_impedance',...
                          'lossless',{'br23'} );

% 指定された平衡点に合う入力定常値を計算
    delta_equilibrium = [pi/6,0];
    E_equilibrium     = net.x_equilibrium([3,6]);
    [Pmech,Vfield,V] = culculate_PmVfd(net,delta_equilibrium,E_equilibrium);
    
% networkの入力定常値に計算した値をセット
    net.a_bus{1}.component.avr.Vfd_st = Vfield(1);
    net.a_bus{3}.component.avr.Vfd_st = Vfield(2);
    net.a_bus{1}.component.governor.P = Pmech(1);
    net.a_bus{3}.component.governor.P = Pmech(2);


% シミュレーション(AVRなしver)
    x_init = net.x_equilibrium;
    x_init(1) = 0;

    % δの初期値: δ3-δ1 = -1 の時
    x_init(4) = -1;
    out_1 = net.simulate([0,50], 'x0_sys', x_init);                     %0から50秒まで 初期値=x_init
        
    % δの初期値: δ3-δ1 = -pi/2 の時
    x_init(4) = -pi/2;
    out_pi2 = net.simulate([0,50], 'x0_sys', x_init);                     %0から50秒まで 初期値=x_init


    % δの初期値を移動させた時のL2ノルムの計算
    n = 100;
    delta_lim = linspace(-pi*11/10,pi*6/10,n);
    
    omega_L2 = nan(1,n);
    Vabs_L2  = nan(1,n);
    Out = cell(n,1);

%     % 図5.8用のシミュレーション
%     for i = 1:n
%         disp(['AVRなしver：',num2str(n),'回中',num2str(i),'回目'])
%         x_init(1) = delta_lim(i);
%         out = net.simulate([0,50], 'x0_sys'   , x_init,...
%                                    'reset_tim', 5,...
%                                    'do_retry' , false,...
%                                    'do_report', false);
%         omega1_L2 = norm(out.X{1}(:,2));
%         omega3_L2 = norm(out.X{3}(:,2));
%         omega_L2(i) = norm([omega1_L2; omega3_L2]);
%         Vabs1_L2        = norm(abs(out.V{1}(:,1)+1j*out.V{1}(:,2)),2);
%         Vabs3_L2        = norm(abs(out.V{3}(:,1)+1j*out.V{3}(:,2)),2);
%         Vabs_L2(i)  = norm([Vabs1_L2; Vabs3_L2]);
%         disp(omega_L2)
%         disp(Vabs_L2)
%         Out{i} = out;
%     end


%%%%%%%%%%%%%%%%%%%%%%%%
%  同期発電機にAVRを付加  %
%%%%%%%%%%%%%%%%%%%%%%%%
    t_tr = 0.015; k_ap = 200; k0 = 0.04; gamma_max = 7; gamma_min = -6.4;
    avr_para = table(t_tr, k_ap, k0, gamma_min, gamma_max);
    net.a_bus{1}.component.set_avr(avr_IEEE_ST1(avr_para));
    net.a_bus{3}.component.set_avr(avr_IEEE_ST1(avr_para));
    net.initialize;
    
    net.a_bus{1}.component.avr.initialize( Vfield(1), abs(V(1)));
    net.a_bus{3}.component.avr.initialize( Vfield(2), abs(V(2)));
    net.a_bus{1}.component.governor.P  = Pmech(1);
    net.a_bus{3}.component.governor.P  = Pmech(2);

% シミュレーション(AVRありver)
    x_init = net.x_equilibrium;
    x_init(1) = 0;
    x_init(4) = abs(V(1));
    x_init(net.a_bus{1}.component.get_nx+4) = abs(V(2));
    
    % δの初期値: δ3-δ1 = -1 の時
    x_init(5) = -1;
    out_avr_1 = net.simulate([0, 50], 'x0_sys', x_init);                  %0から50秒まで 初期値=x_init
    
    % δの初期値: δ3-δ1 = -pi/2 の時
    x_init(5) = -pi/2;
    out_avr_pi2 = net.simulate([0, 50], 'x0_sys', x_init);                  %0から50秒まで 初期値=x_init

    % δの初期値を移動させた時のL2ノルムの計算
    omega_L2_avr = nan(1,n);
    Vabs_L2_avr  = nan(1,n);
    Out_avr = cell(n,1);

%     % 図5.8用のシミュレーション
%     for i = 1:n
%         disp(['AVRありver：',num2str(n),'回中',num2str(i),'回目'])
%         x_init(1) = delta_lim(i);
%         out = net.simulate([0,50], 'x0_sys'   , x_init,...
%                                    'reset_tim', 5,...
%                                    'do_retry' , false,...
%                                    'do_report', false);
%         omega1_L2       = norm(out.X{1}(:,2));
%         omega3_L2       = norm(out.X{3}(:,2));
%         omega_L2_avr(i) = norm([omega1_L2; omega3_L2]);
%         Vabs1_L2        = norm(abs(out.V{1}(:,1)+1j*out.V{1}(:,2)),2);
%         Vabs3_L2        = norm(abs(out.V{3}(:,1)+1j*out.V{3}(:,2)),2);
%         Vabs_L2_avr(i)  = norm([Vabs1_L2; Vabs3_L2]);
%         disp(omega_L2_avr)
%         disp(Vabs_L2_avr)
%         Out_avr{i} = out;
%     end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% 図5.8のプロット
%     figure('Position',[100,100,850,250])
%     subplot(1,2,1)
%     plot(delta_lim,omega_L2,'b-',delta_lim,omega_L2_avr,'k--','LineWidth',1.5)
%     ylim([0,0.25])
%     subplot(1,2,2)
%     plot(delta_lim,Vabs_L2,'b-',delta_lim,Vabs_L2_avr,'k--','LineWidth',1.5)
%     ylim([0,0.25])
 

% 図5.9のプロット
    figure('Position',[100,100,850,250])
    subplot(1,2,1)
    myplot(out_1)
    xlabel('(a) 自動電圧調整機なし')
    subplot(1,2,2)
    myplot(out_avr_1)
    xlabel('(b) 自動電圧調整機あり')
    sgtitle('図5.9 角周波数偏差の初期値応答 (初期値:δ13=-1)')


% 図5.10のプロット
    figure('Position',[100,100,850,250])
    subplot(1,2,1)
    myplot(out_pi2)
    xlabel('(a) 自動電圧調整機なし')
    subplot(1,2,2)
    myplot(out_avr_pi2)
    xlabel('(b) 自動電圧調整機あり')
    sgtitle('図5.10 角周波数偏差の初期値応答 (初期値:δ13=-pi/2)')

end

function myplot(out)
    plot(out.t, out.X{3}(:, 2), '--r', out.t, out.X{1}(:, 2), '-b','LineWidth',1);
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