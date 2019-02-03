% Apply network to a single image
function [joints, vals, heatmapResized, heatmapVis] = applyNetImage(imgFile, net, opt, pp, heatmapResizedPrev, numItr)

% Read & reformat input image
img = imread(imgFile);
input_data = prepareImagePose(img, opt);

% Forward pass
tic
net.forward({input_data});
features = net.blobs(opt.layerName).get_data();

[joints, vals, heatmapResized] = processHeatmap(features, opt, heatmapResizedPrev, numItr);

disp(toc);

% Visualisation
if opt.visualizeheatmap
    % Heatmap
    if strcmp(opt.heatmapstyle,'combined')
        heatmapVis = getConfidenceImage(heatmapResized, img);
        figure(2); imshow(heatmapVis);
    elseif strcmp(opt.heatmapstyle,'separate')
        heatmapVis = getConfidenceImageSeparate(heatmapResized, img);
        for c = 1:7
            figure(c+1); imshow(heatmapVis(:,:,:,c));
        end
    end
elseif pp.visualizeoutput1Heatmap
    % Heatmap
    if strcmp(opt.heatmapstyle,'combined')
        heatmapVis = getConfidenceImage(heatmapResized, img);
    elseif strcmp(opt.heatmapstyle,'separate')
        heatmapVis = getConfidenceImageSeparate(heatmapResized, img);
    end
else
    heatmapVis = zeros(256,256,3);
end

if opt.visualizeskel
    % Original image overlaid with joints
    img_blur = imgaussfilt(img,2);
    figure(1),imshow(uint8(img));
    hold on
    plotSkeleton(joints, [], []);
    hold off
end
