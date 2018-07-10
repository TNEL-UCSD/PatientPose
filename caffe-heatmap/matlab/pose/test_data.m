% This file uses a FLIC trained model and applies it to a video sequence from Poses in the Wild
%
% Download the model:
%    wget http://tomas.pfister.fi/models/caffe-heatmap-flic.caffemodel -P ../../models/heatmap-flic-fusion/

% Options
opt.visualise = false;		% Visualise predictions?
opt.useGPU = false;         % Run on GPU
opt.dims = [256 256]; 		% Input dimensions (needs to match matlab.txt)
opt.numJoints = 7; 			% Number of joints
opt.layerName = 'conv5_fusion'; % Output layer name
opt.modelDefFile = '../../models/heatmap-flic-fusion/matlab.prototxt'; % Model definition
opt.modelFile = '../../models/heatmap-flic-fusion/caffe-heatmap-flic.caffemodel'; % Model weights

% Add caffe matlab into path
addpath('../')

% Image input directory
opt.inputDir = '/home/kjchen/Documents/TNEL_Test_Data/2016.12.09.12.14/ColorCropped_2/';

% Create image file list
imInds = 1:10655;
for ind = 1:numel(imInds); files{ind} = ['Cropped_ColorFrame_' num2str(imInds(ind)) '.jpg']; end

% Apply network
joints = applyNet(files, opt)