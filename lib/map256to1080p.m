function [joints_1080p] = map256to1080p(joints_256, rect)
% joints_256: [2 x 7 x n]
% rect: [xmin ymin width height]

% calculate joint percentage relative to matrix size
joints_percentage = joints_256./256;

% convert joints_1080square
joints_1080square = [joints_percentage(1,:,:).*rect(3); joints_percentage(2,:,:).*rect(4)];

% convert joints_1080square to joints_1080p
joints_1080p = [joints_1080square(1,:,:)+rect(1); joints_1080square(2,:,:)+rect(2)];

end