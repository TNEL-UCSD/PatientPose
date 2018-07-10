% Wrapper to run network on multiple images
function [joints, vals, heatmapResized, heatmapVis] = tnel_applyNet(files, opt)
opt.numFiles = numel(files);

fprintf('config:\n\n');
disp(opt)
fprintf('\n');

% Initialise caffe
net = initCaffe(opt); 

% Create filename and file
caffeFilename = sprintf('%smat_files/caffe.mat',opt.inputDir);
caffe_file = matfile(caffeFilename,'Writable',true);

% Apply network separately to each image
caffe_file.joints = zeros(2, opt.numJoints, opt.numFiles, 'single');
caffe_file.vals = zeros(7, opt.numFiles);
caffe_file.heatmapResized = zeros(256, 256, 7, opt.numFiles, 'single');
caffe_file.heatmapVis = zeros(256, 256, 3, opt.numFiles);

for ind = 1:opt.numFiles
    
	imFile = files{ind};
	fprintf('file: %s\n', imFile);
    
	[joints, vals, heatmapResized, heatmapVis] = applyNetImage([opt.inputDir imFile], net, opt);

    caffe_file.joints(:, :, ind) = joints;
    caffe_file.vals(:, ind) = vals';
    caffe_file.heatmapResized(:, :, :, ind) = heatmapResized;
    caffe_file.heatmapVis(:, :, :, ind) = heatmapVis;

	if opt.visualize; waitforbuttonpress; end
end

end