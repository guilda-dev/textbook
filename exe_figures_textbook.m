close all; clear; clc;
operate_path('guilda');
operate_path('figures_textbook');

disp('生成したいグラフに対応する例や節の番号を入力してください');
disp('  ex) 例2.3 → 2.3または2_3');
num_ = input('→ ', "s");
num_cell = strsplit(num_, {'.', '_'});
disp(newline);
if numel(num_cell)==2
    num = strcat(num_cell{1}, '_', num_cell{2});
else
    error('ファイル名は例えば、例2.3の場合は 2.3 や 2_3 のように入力してください')
end

try
    run_mfile(num);
catch
    error('入力した番号に対応するファイルは存在しません')
end

disp(newline);
disp(strcat('例/節:', num_, 'に対応するプログラムを実行し、グラフの生成を行い、エディターに対応するプログラムを開きました'));
disp(newline);

function run_mfile(num)
    name_ = strcat('example_', num, '.m');
    name = fullfile('figures_textbook', name_);
    run(name);
    open(name);
end