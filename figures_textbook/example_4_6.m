function example_4_6()
    figure;
    subFig = {'a','b','c','d'};
    for i = 1:4
        subplot(2,2,i)
        func(subFig{i});
    end
end

function func(subFig)
    n = 3;
    omega0 = 120*pi;
    
    %アドミタンス行列の導出
    y12 = 1.3652 - 1j*11.6041;
    y32 = 1.9422 - 1j*10.5107;
    Y = 1*[y12, -y12, 0;
        -y12, y12+y32, -y32;
        0, -y32, y32];
    
    switch subFig
        case {'a','b'}
            Yre = real(Y);
            Yim = imag(Y);
        case {'c','d'}
            Yre = real(Y) / 100;
            Yim = imag(Y) / 100;
    end
        
    %発電機モデルのパラメータを設定
    Xq = diag([0.936; 0.911; 0.667]);
    Xd = diag([1.569; 1.651; 1.220]);
    M = diag([100; 18; 12]);
    switch subFig
        case {'a','c'}
            D = 1*diag([10; 10; 10]);
        case {'b','d'}
            D = 0.01*diag([10; 10; 10]);
    end
    T = diag([5.14; 5.90; 8.97]);


    E =[1.4363; 1.8095; 1.1030];
    
    thar1s = [];
    thar2s = [];
    
    thar1u = [];
    thar2u = [];
    
    thar1uc = [];
    thar2uc = [];
    
    thar1ucs = [];
    thar2ucs = [];
    
    thar1uci = [];
    thar2uci = [];
    
    %θ1とθ2の各値におけるシステムの安定性を評価
    for theta_1 = 0:0.01:1
        for theta_2 = 0:0.05:5

            Y = theta_2*Yre + 1j*Yim;
            
            Gam = Xq - 1j*Xq*conj(Y)*Xq;
            
            delta = linspace(-theta_1*pi/2,theta_1*pi/2,n)';
            
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
            
            Psi = blkdiag(eye(n),inv(M),inv(T))*[zeros(n), omega0*eye(n), zeros(n);
                -L, -D, -CE;
                BE, zeros(n), AE];
            
            reeigPsi = sort(real(eig(Psi)),'descend');
            reeigA = sort(real(eig(AE)),'descend');
            eigK = eig(L-CE*inv(AE)*BE);
            reeigK = sort(real(eigK));
            
            
            flg = 0;
            
            if reeigPsi(1)<1e-7 & reeigPsi(2)~= 0
                thar1s = [thar1s theta_1];
                thar2s = [thar2s theta_2];
                flg = flg + 1;
            else
                thar1u = [thar1u theta_1];
                thar2u = [thar2u theta_2];
            end
            
            if min(reeigK)<-1e-7 | sum(reeigK)==0 
                thar1uc = [thar1uc theta_1];
                thar2uc = [thar2uc theta_2];
                flg = flg + 1;
            end
            
            if sum(abs(imag(eigK)))>1e-7
                thar1uci = [thar1uci theta_1];
                thar2uci = [thar2uci theta_2];
            end
            
            if reeigA(2)>=0 
                thar1ucs = [thar1ucs theta_1];
                thar2ucs = [thar2ucs theta_2];
            end
        end
    end
    

    %解析結果をプロット
    plot(thar1s,thar2s,'ob','MarkerFaceColor','b','MarkerSize',6);
    hold on;
    grid on;
    plot(thar1uc,thar2uc,'or','MarkerSize',6);
    plot(thar1uci,thar2uci,'om','MarkerSize',9);
    plot(thar1ucs,thar2ucs,'xc','MarkerSize',9);
    xlabel('\theta_1')
    ylabel('\theta_2')
end



