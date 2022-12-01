close all; clear; clc;

disp('実行したいプログラムに対応する例の番号を入力してください');
disp('  ex) プログラム3-1, 3-2（例3.8） → 3.8');
num = input('→ ', "s");

run_mfile(num);

disp(newline);
disp(strcat('例:', num, 'に対応するプログラムを実行し、エディターに対応するプログラムを開きました'));
disp(newline);

function run_mfile(num)
    folder_name_ = strcat('example', num);
    folder_name = fullfile('codes_textbook', folder_name_);
    cd(folder_name)
    switch num
        case '3.8'
            disp('↓↓↓main_ex1.m の実行結果↓↓↓');
            run('main_ex1.m');
            disp(newline);
            open('main_ex1.m');
        case '3.9'
            disp('↓↓↓main_ex2.m の実行結果↓↓↓');
            run('main_ex2.m');
            disp(newline);
            open('main_ex2.m');
        case '3.10'
            disp('↓↓↓main_ex3.m の実行結果↓↓↓');
            run('main_ex3.m');
            disp(newline);open('main_ex3.m');
        case '3.11'
            disp('↓↓↓main_ex4.m の実行結果↓↓↓');
            run('main_ex4.m');
            disp(newline);
            open('main_ex4.m');
        case '3.12'
            disp('↓↓↓main_admittance.m の実行結果↓↓↓');
            run('main_admittance.m');
            disp(newline);
            open('main_admittance.m');
        case '3.13'
            disp('↓↓↓main_power_flow.m の実行結果↓↓↓');
            run('main_power_flow.m');
            disp(newline);
            open('main_power_flow.m');
        case '3.14'
            disp('↓↓↓main_RLC_dae.m の実行結果↓↓↓');
            run('main_RLC_dae.m');
            disp(newline);
            open('main_RLC_dae.m');
            disp('↓↓↓main_RLC_ode.m の実行結果↓↓↓');
            run('main_RLC_ode.m');
            disp(newline);
            open('main_RLC_ode.m');
        case '3.15'
            disp('↓↓↓main_simulation_3bus_simple.m の実行結果↓↓↓');
            run('main_simulation_3bus_simple.m');
            disp(newline);
            open('main_simulation_3bus_simple.m');
        case '3.16'
            disp('↓↓↓main_simulation_3bus.m の実行結果↓↓↓');
            run('main_simulation_3bus.m');
            disp(newline);
            open('main_simulation_3bus.m');
        case '3.17'
            disp('↓↓↓main_simulation_3bus_equilibrium.m の実行結果↓↓↓');
            run('main_simulation_3bus_equilibrium.m');
            disp(newline);
            open('main_simulation_3bus_equilibrium.m');
        case '3.18'
            disp('↓↓↓main_simulation_3bus_fault.m の実行結果↓↓↓');
            run('main_simulation_3bus_fault.m');
            disp(newline);
            open('main_simulation_3bus_fault.m');
        case '3.19'
            disp('↓↓↓main_simulation_3bus_input.m の実行結果↓↓↓');
            run('main_simulation_3bus_input.m');
            disp(newline);
            open('main_simulation_3bus_input.m');
        otherwise
            error('入力した番号に対応するファイルは存在しません')
    end
    cd('../..')
end