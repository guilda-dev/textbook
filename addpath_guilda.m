addpath(absolute_path('guilda'));

function APATH = absolute_path(RPATH) 
% ABSOLUTE_PATH 
if ~ischar(RPATH) error(''); end; 
[dirname, filename, ext] = fileparts(RPATH);
[num,pathinfo] = fileattrib(dirname);
APATH = fullfile(pathinfo.Name, strcat([filename, ext]));
end

