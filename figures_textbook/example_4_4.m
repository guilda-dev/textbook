function example_4_4()
    figure('position',[100,100,1000,275])

    %送電網がロスレスの場合
    func(0,'bo')
    
    %送電網にロスがある場合
    func(1,'r*')
end


function func(theta2,plot_type)
    n = 3;
    
    omega0 = 120*pi;

    %アドミタンス行列の導出
    y12 = theta2*1.3652 - 1j*11.6041;
    y32 = theta2*1.9422 - 1j*10.5107;
    Y = 1*[y12, -y12, 0;
        -y12, y12+y32, -y32;
        0, -y32, y32];
    
    %発電機モデルのパラメータの設定
    Xq = diag([0.936; 0.911; 0.667]);
    Xd = diag([1.569; 1.651; 1.220]);
    M = diag([100; 18; 12]);
    D = 1*diag([10; 10; 10]);
    T = 1*diag([5.14; 5.90; 8.97]);
    
    %発電機モデルの平衡点を設定
    delta = [0.4656; 1.0903; 0.6067];
    E =1*[1.4363; 1.8095; 1.1030];
    

    %近似線形化モデルの各システム行列を導出
    Gam = Xq - 1j*Xq*conj(Y)*Xq;
    K = real( diag(exp(1j*delta))*inv(Gam)*diag(exp(-1j*delta)) );
    H = imag( diag(exp(1j*delta))*inv(Gam)*diag(exp(-1j*delta)) );
    
    L = -diag(E)*K*diag(E);
    L = L - diag(diag(L));
    L = L - diag(L*ones(n,1));
    
    C = diag(E)*H;
    C = C - diag(diag(C));
    C = C + diag( diag(H).*E + H*diag(E)*ones(n,1) );
    
    A = K;
    
    B = H*diag(E);
    B = B - diag(diag(B));
    B = B -diag(B*ones(n,1));
    
    AE = (Xd - Xq)*A - Xd*inv(Xq);
    BE = (Xd - Xq)*B;
    CE = C;
    
    Ahat = inv(Xd - Xq)*AE;
    Bhat = inv(Xd - Xq)*BE;
    Chat = CE;
    
    A_G = [zeros(n), zeros(n);
        inv(T)*BE, inv(T)*AE];
    
    B_G = [eye(n); zeros(n)];
    
    C_G = [L, CE];
    

    %近似線形モデルの設定
    sysG = ss(A_G,B_G,C_G,[]);
    
    n1 = -5;
    n2 = 3;
    num = 50;
    %MIMOnyquistを呼び出し（コード後半に記載）
    [w, ~, G_eigloci, ~] = MIMOnyqyist(n1,n2,num,sysG);
    

    %計算結果をプロット
    subplot(1,2,1)
    semilogx(w,cell2mat(G_eigloci),plot_type,'MarkerSize',4,'LineWidth',1.5);
    ylim([-6,8])
    grid on; hold on;
    
    sysH1j = ss(inv(T)*AE, inv(T)*BE, 1j*CE,1j*L);
    [w, ~, H_eigloci, ~] = MIMOnyqyist(n1,n2,num,sysH1j);
    
    subplot(1,2,2)
    semilogx(w,cell2mat(H_eigloci),plot_type,'MarkerSize',4,'LineWidth',1.5);
    ylim([-0.25,0.05])
    grid on; hold on;
end


function [w, G_jw, eigloci, eignyquist] = MIMOnyqyist(n,m,num,sys)

w = logspace(n,m,num);
n_sys = length(sys.A);

for i=1:num
    G_jw{i} = sys.C*inv(sqrt(-1)*w(i)*eye(n_sys)-sys.A)*sys.B+sys.D;
    eigloci{i} = 1/2*sort(real(eig(G_jw{i} +G_jw{i}')),'descend');
    eignyquist{i} = eig(G_jw{i});
end

end
