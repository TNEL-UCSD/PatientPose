%% parse_openpose.m
%
% This script converts a folder of Open Pose joint coordinates to Caffe-Heatmap format [2x7xn]
%
% Inputs:
%   - Folder of Open Pose joint coordinates
%
% Outputs:
%   - Struct of joint coordinates [2x7xn] corresponding to [Head LHand RHand LElbow RElbow LShldr RShldr]
%
% Translational Neuroengineering Laboratory (TNEL) @ UC San Diego
% Website: http://www.tnel.ucsd.edu

clear all; close all;
dateTime = datestr(now,'mm-dd-yy_HH:MM:SS');
jointlabels = {'Head','L Hand','R Hand', 'L Elbow','R Elbow', 'L Shldr','R Shldr'};

%% Select Folder of OpenPose Data
openpose.folder = uigetdir('','Folder of Open Pose Data');
addpath(openpose.folder);

% process files within the folder
openpose.files = dir(fullfile(openpose.folder, strcat('*.json')));
openpose.namesSave = {openpose.files.name};
openpose.namesSaveNatSort = natsortfiles(openpose.namesSave);

%% Analyze OpenPose JSON Files
% run python script
data_str = python('parse_openpose.py', [openpose.folder '/']);

% convert data to array
data_cell = strsplit(data_str,' ');

% initialize data structure
data = zeros(1,length(data_cell));

% put data into matrix
for i = 1:length(data)
    data(1,i) = str2double(data_cell{i});
end
    
% reshape data
data = reshape(data,[3 7 length(data_cell)/21]);

% split data into pose and structure
openpose_joints = data(1:2,:,:);
openpose_confidence = data(3,:,:);
