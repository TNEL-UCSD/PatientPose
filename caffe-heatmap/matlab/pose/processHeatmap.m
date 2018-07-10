% Reformat output heatmap: rotate & permute color channels
function [joints, vals, heatmapResized] = processHeatmap(heatmap, opt, heatmapResizedPrev, numItr)
numJoints = opt.numJoints;
heatmapResized = imresize(heatmap*2500, [opt.dims(2) opt.dims(1)]) - 1;
heatmapResized = permute(heatmapResized, [2 1 3]);

% Normalize heatmap to 0-1 range
% heatmapResized = (heatmapResized - min(min(heatmapResized))) ./ max(max(heatmapResized));

% % Non-model Improving Methods
% if numItr ~= 1
%     %%%%%%%%%%%%%%%%%%%%%
%     % Gaussian Fall-Off %
%     %%%%%%%%%%%%%%%%%%%%%
%     for k = 1:numJoints
%         maxVal = max(max(heatmapResizedPrev(:,:,k)));
%         [row,col] = find(heatmapResizedPrev(:,:,k) == maxVal);
%         gfilt = gauss2d(256, 50, [row col]);
%         heatmapResized(:,:,k) = heatmapResized(:,:,k).*gfilt;
%     end
%     
%     %%%%%%%%%%%%%%%%%%%%%%
%     % Zone Probabilities %
%     %%%%%%%%%%%%%%%%%%%%%%
%     % Head
%     heatmapResized(1:128,:,1) = heatmapResized(1:128,:,1)*1.5;
%     maxHead = max(max(heatmapResizedPrev(:,:,1)));
%     [rowHead,colHead] = find(heatmapResizedPrev(:,:,1) == maxHead);
%     
%     % Left
%     for i = [2,4,6]
%         heatmapResized(:,1:colHead,i) = heatmapResized(:,1:colHead,i)*1.5;
%     end
%     
%     % Right
%     for i = [3,5,7]
%         heatmapResized(:,colHead+1:end,i) = heatmapResized(:,colHead+1:end,i)*1.5;
%     end
%     
% end

% Normalize new heatmap to 0-1 range
% heatmapResized = (heatmapResized - min(min(heatmapResized))) ./ max(max(heatmapResized));
% heatmapResized = heatmapResized * 282;

% % Border
% borderSize = 10;
% heatmapResized(1:borderSize,:,:) = 0;
% heatmapResized(256 - borderSize:end,:,:) = 0;
% heatmapResized(:,1:borderSize,:) = 0;
% heatmapResized(:,256 - borderSize:end,:) = 0;

[joints, vals] = heatmapToJoints(heatmapResized, numJoints);
end