function example_4_3()
    %GUILDAの使用なし
    figure
    subplot(1,2,1)
    theta2 = 0;
    func(theta2)
    
    subplot(1,2,2)
    theta2 = 1;
    func(theta2)
end

function func(theta2)
    n = 3;
    
    omega0 = 120*pi;
    
    %アドミタンス行列の設定
    y12 = theta2 * 1.3652 - 1j*11.6041;
    y32 = theta2 * 1.9422 - 1j*10.5107;
    Y = 1*[y12, -y12, 0;
        -y12, y12+y32, -y32;
        0, -y32, y32];
    
    %発電機のパラメータを設定
    Xq = diag([0.936; 0.911; 0.667]);
    Xd = diag([1.569; 1.651; 1.220]);
    M = diag([100; 18; 12]);
    D = 1*diag([10; 10; 10]);
    T = 1*diag([5.14; 5.90; 8.97]);
    
    %発電機モデルの状態の平衡点を設定
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
    

    %近似線形モデルから初期値応答を計算
    Psi = blkdiag(eye(n),inv(M),inv(T))*[zeros(n), omega0*eye(n), zeros(n);
        -L, -D, -CE;
        BE, zeros(n), AE];
    sys = ss(Psi,[],[],[]);
    x0 = [pi/6; 0; 0; 0; 0; 0; 0.1; 0; 0];
    [y,t,x] = initial(sys,x0);
    
    deltax = x(:,1:n);
    omegax = x(:,n+1:2*n);
    Ex = x(:,2*n+1:3*n);
    
    
    Ahat = inv(Xd - Xq)*AE;
    Bhat = inv(Xd - Xq)*BE;
    Chat = CE;
    
    PF = 1/2*omega0*M;
    PG = 1/2*[L, -Bhat';
            -Bhat, -Ahat];
    PG = (PG+PG')/2;
    
    %サブシステムFの蓄積関数
    WF = diag(omegax*PF*omegax');
    %サブシステムGの蓄積関数    
    xG = [deltax, Ex];
    WG = diag(xG*PG*xG');
    
    
    plot(t,WF,'-b','LineWidth',1.5);
    grid on;
    hold on;
    
    plot(t,WG,'-r','LineWidth',1.5);
    
    plot(t,WF+WG,'-k','LineWidth',1.5);
    
    xlim([0,30])
    ylim([0,0.18])
    
end