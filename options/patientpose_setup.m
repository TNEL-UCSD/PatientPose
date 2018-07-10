% Turn off some warnings
warning off MATLAB:hg:willberemoved
warning off MATLAB:dispatcher:nameConflict
warning off MATLAB:MKDIR:DirectoryExists
warning off images:initSize:adjustingMag

% Tight figure borders
iptsetpref('ImshowBorder','tight');

% Environment setup
%setenv LD_LIBRARY_PATH /home/kjchen/anaconda2/lib:/usr/local/MATLAB/R2016b/sys/opengl/lib/glnxa64:/usr/local/MATLAB/R2016b/extern/lib/glnxa64:/usr/local/MATLAB/R2016b/runtime/glnxa64:/usr/local/MATLAB/R2016b/sys/java/jre/glnxa64/jre/lib/amd64/native_threads:/usr/local/MATLAB/R2016b/sys/java/jre/glnxa64/jre/lib/amd64/server:/home/kjchen/Documents/tnel_pose-estimation/caffe-heatmap/build/lib:/usr/lib/x86_64-linux-gnu

% Set paths
%run set_paths;

% Mandatory VLFeat setup (run only once; check via 'vl_version verbose')
%p = mfilename('fullpath');
%[pathstr,name,ext] = fileparts('tnel_pose-estimation');
%pr = reverse(p);
%pr(1:length(name)) = [];
%p = reverse(pr);
%run(strcat(p,'personalized-pose/3_dependencies/vlfeat/toolbox/vl_setup'));