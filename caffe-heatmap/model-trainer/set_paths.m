%setup paths
p = mfilename('fullpath');
[pathstr,name,ext] = fileparts('set_paths.m');
pr = reverse(p);
pr(1:length(name)) = [];
p = reverse(pr);

addpath(genpath(strcat(p,'methods/')));
addpath(strcat(p,'mex/'));
addpath(strcat(p,'options/'));
addpath(strcat(p,'system'));
