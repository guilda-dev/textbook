classdef network_example3bus < power_network

    methods
        function obj = network_example3bus(varargin)
        
        p = inputParser;
        p.CaseSensitive = false;
        addParameter(p, 'flow'    , 1            );
        addParameter(p, 'comp2'   , 'L_impedance');
        addParameter(p, 'lossless', {}           );
        parse(p, varargin{:});
        option = p.Results;
        
        
        
        %% 潮流設定 %%
                shunt =    0;
                switch option.flow
                    case 0
                        P1    =   -0.5623; Vabs1 =1.372;
                        P2    =    0.8832; Vabs2 =1.375;
                        P3    =   -0.3160; Vabs3 =1.337;  
                        bus1 = bus_PV(P1, Vabs1, shunt);                                                            %母線１はPVバスに定義
                        bus2 = bus_PV(P2, Vabs2, shunt);                                                            %母線２はPVバスに定義
                        bus3 = bus_PV(P3, Vabs3, shunt);                                                            %母線３はPVバスに定義
                    case 1
                        P1    =  0.5; Vabs1 =2;
                        P2    =   -3; Q2    =0;
                        Vabs3 =    2; Varg3 =0;
                        bus1 = bus_PV(P1, Vabs1, shunt);                                                            %母線１はPVバスに定義
                        bus2 = bus_PQ(P2, Q2, shunt);                                                               %母線２はPQバスに定義
                        bus3 = bus_slack(Vabs3, Varg3, shunt);                                                      %母線３はslackバスに定義
                    case 2
                        Vabs1 =    2; Varg1 =0;
                        P2    =   -3; Q2    =0;
                        P3    =  0.5; Vabs3 =2;
                        bus1 = bus_slack(Vabs1, Varg1, shunt);                                                      %母線１はslackバスに定義
                        bus2 = bus_PQ(P2, Q2, shunt);                                                               %母線２はPQバスに定義
                        bus3 = bus_PV(P3, Vabs3, shunt);                                                            %母線３はPVバスに定義
                end
        
        
        
        %% 機器の定義 %%
                omega0 = 60 * 2 * pi;                                                                               %周波数60hz
                
                %発電機パラメータ設定
                    machinery = array2table(...
                                        [         1,        1,  1.569,      0.936,   0.936,  5.14,  100,  10;...    %発電機1のpara
                                                  2,        2,  1.651,      0.911,   0.911,  5.90,   18,  10;...    %発電機2のpara
                                                  3,        3,  1.220,      0.667,   0.667,  8.97,   12,  10],...   %発電機3のpara
                         'VariableNames', {'No_mac', 'No_bus',   'Xd', 'Xd_prime',    'Xq',   'T',  'M', 'D'});
                    
                %母線１への機器
                    comp4bus1 = generator_1axis(omega0, machinery(1, :));                                           %一軸モデルの発電機 (発電機3のパラメータ)
                    bus1.set_component(comp4bus1);                                                                  %busのcomponentプロパティに発電機クラスを代入
                
                %母線2への機器
                    switch option.comp2
                        case 'L_impedance'
                            comp4bus2 = load_impedance();                                                           %定インピーダンス負荷モデル
                        case 'L_power'
                            comp4bus2 = load_power();                                                               %定電力負荷モデル
                        case 'Gen_1axis'
                            comp4bus2 = generator_1axis(omega0, machinery(2, :));                                   %一軸モデルの発電機 (発電機2のパラメータ)
                    end
                    bus2.set_component(comp4bus2);                                                                  %busのcomponentプロパティに負荷クラスを代入
                    
                %母線3への機器
                    comp4bus3 = generator_1axis(omega0, machinery(3, :));                                           %一軸モデルの発電機 (発電機3のパラメータ)
                    bus3.set_component(comp4bus3);                                                                  %busのcomponentプロパティに発電機クラスを代入
        
        
        
        %% 送電網の定義 %%
                %branch1,2
                    if ismember('br12',option.lossless)
                        y12  = - 11.6041 * 1j;
                    else
                        y12  = 1.3652 - 11.6041 * 1j;
                    end
                    br12 = branch_pi(1, 2, [real(1/y12), imag(1/y12)], 0);
                
                %branch2,3
                    if ismember('br23',option.lossless)
                        y23  = -10.5107 * 1j;
                    else
                        y23  = 1.9422 - 10.5107 * 1j;  
                    end
                    br23 = branch_pi(2, 3, [real(1/y23), imag(1/y23)], 0);
        
        
        
        %% power_netwrokクラスの定義 %%
                obj.add_bus(bus1);                                                                                  %netのa_busプロパティにbus_PVクラスを追加
                obj.add_bus(bus2);                                                                                  %netのa_busプロパティにbus_PVクラスを追加
                obj.add_bus(bus3);                                                                                  %netのa_busプロパティにbus_PVクラスを追加
                obj.add_branch(br12);                                                                               %netのa_busプロパティにbranch_piクラスを追加
                obj.add_branch(br23);                                                                               %netのa_busプロパティにbranch_piクラスを追加
                obj.initialize();
        
        end
    end
end