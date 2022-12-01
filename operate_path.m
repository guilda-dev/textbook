%%% addpath, rmpathの実行を行うためのプログラム
%   例: guildaフォルダをaddpath → operate_path('guilda')
%   例: figures_textbookフォルダをrmpath → operate_path('guilda', 'rm')
%   folder_name: addpath/rmpath するフォルダの名前
%   option: addpathなら'add', rmpathなら'rm'（デフォルトはaddpath）

function operate_path(folder_name, option)
    if nargin < 2
        option = 'add';
    end
    
    if strcmp(option, 'add')
        addpath(absolute_path(folder_name));
    elseif strcmp(option, 'rm')
        rmpath(absolute_path(folder_name));
    end
end

function APATH = absolute_path(RPATH) 
% ABSOLUTE_PATH 
if ~ischar(RPATH) error(''); end; 
[dirname, filename, ext] = fileparts(RPATH);
[num,pathinfo] = fileattrib(dirname);
APATH = fullfile(pathinfo.Name, strcat([filename, ext]));
end
