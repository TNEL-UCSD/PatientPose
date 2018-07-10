% Find joints in heatmap (== max locations in heatmap)
function [joints,vals] = heatmapToJoints(heatmapResized, numJoints, useMin)
joints = zeros(2, numJoints, 'single');
vals = zeros(1, numJoints, 'single');

for i = 1:numJoints
    sub_img = heatmapResized(:, :, i);
    vec = sub_img(:);
    
    [val,idx] = max(vec); 
    
    [y,x] = ind2sub(size(sub_img), idx);
    
    joints(:, i) = [x y];
    vals(i) = val;
end