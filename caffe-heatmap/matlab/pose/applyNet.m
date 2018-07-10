% Wrapper to run network on multiple images
function [joints, vals, heatmapResized, heatmapVis] = applyNet(files, opt, tnelOpt)
opt.numFiles = numel(files);

fprintf('config:\n\n');
disp(opt)
fprintf('\n');

% Initialise caffe
net = initCaffe(opt);

% Apply network separately to each image
joints = zeros(2, opt.numJoints, opt.numFiles, 'single');
vals = zeros(7, opt.numFiles);
%heatmapResized = zeros(256, 256, 7, opt.numFiles);

if strcmp(opt.heatmapstyle,'combined')
    heatmapVis = zeros(256, 256, 3, opt.numFiles);
elseif strcmp(opt.heatmapstyle,'separate')
    %heatmapVis = zeros(256, 256, 3, 7, opt.numFiles);
end

numItr = 1;

for ind = 1:opt.numFiles
    imFile = files{ind};
    fprintf('file: %s\n', imFile);
    
    if opt.visualizeheatmap || tnelOpt.visualizeoutput1Heatmap
        if numItr == 1 && strcmp(opt.heatmapstyle,'separate')
            [joints(:, :, ind), vals(:, ind), heatmapResized(:, :, :, ind), heatmapVis(:,:,:,:,ind)] = applyNetImage([opt.inputDir imFile], net, opt, tnelOpt, zeros(256, 256, 7), numItr);
        elseif numItr ~= 1 && strcmp(opt.heatmapstyle,'separate')
            [joints(:, :, ind), vals(:, ind), heatmapResized(:, :, :, ind), heatmapVis(:,:,:,:,ind)] = applyNetImage([opt.inputDir imFile], net, opt, tnelOpt, heatmapResized(:, :, :, ind-1), numItr);
        elseif numItr == 1 && strcmp(opt.heatmapstyle,'combined')
            [joints(:, :, ind), vals(:, ind), heatmapResized(:, :, :, ind), heatmapVis(:,:,:,ind)] = applyNetImage([opt.inputDir imFile], net, opt, tnelOpt, zeros(256, 256, 7), numItr);
        elseif numItr ~= 1 && strcmp(opt.heatmapstyle,'combined')
            [joints(:, :, ind), vals(:, ind), heatmapResized(:, :, :, ind), heatmapVis(:,:,:,ind)] = applyNetImage([opt.inputDir imFile], net, opt, tnelOpt, heatmapResized(:, :, :, ind-1), numItr);
        end
    else
        if numItr == 1
            [joints(:, :, ind), vals(:, ind), heatmapResized(:, :, :, ind), ~] = applyNetImage([opt.inputDir imFile], net, opt, tnelOpt, zeros(256, 256, 7), numItr);
        elseif numItr ~= 1
            [joints(:, :, ind), vals(:, ind), heatmapResized(:, :, :, ind), ~] = applyNetImage([opt.inputDir imFile], net, opt, tnelOpt, heatmapResized(:, :, :, ind-1), numItr);
        end
    end
    
    numItr = numItr + 1;
    if opt.visualizeskel || opt.visualizeheatmap; waitforbuttonpress; end
end




end