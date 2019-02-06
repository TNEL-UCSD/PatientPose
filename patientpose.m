%% patientpose.m
%
% This is the main script to generate subject-specific pose estimates via
% PatientPose. 
%
% Usage:
%   1. Select the folder containing your raw patient RGB data
%   2. Indicate the area to crop and resize the images by right-click dragging a
%      square over the desired ROI. Dragging begins at the top-left corner.
%
% Inputs:
%   - Folder containing the raw images to be processed for pose estimates
%
% Outputs:
%   - Coordinates of the selected ROI saved as a .mat file
%   - Preprocessed images saved under the ./preprocessed/ folder
%
% Translational Neuroengineering Laboratory (TNEL) @ UC San Diego
% Website: http://www.tnel.ucsd.edu

clear all; close all;
dateTime = datestr(now,'mm-dd-yy_HH:MM:SS');

%% Setup & Options
run patientpose_setup
run patientpose_options

%% Load Data
disp('Select folder containing preprocessed images to estimate pose on.');
d = dir(uigetdir);
im.folderPath = [d(1).folder '/'];
addpath(im.folderPath)

%% Load CNN Model
disp('Load patient CNN caffe model');
[baseName, folder] = uigetfile('*.caffemodel');
opt.modelFile = [folder baseName];

%% Load Kalman Filter Noise Parameters
disp('Load trained Kalman filter noise parameters')
uiopen('matlab');

%% Apply PatientPose
% Process files
im.files = dir(fullfile(im.folderPath, strcat('*.',pp.inputfiletype)));

% Read and sort filenames
im.names = natsortfiles({im.files.name});

% Apply personalized CNN model
path = mfilename('fullpath');
cd(path(1:50));
opt.inputDir = im.folderPath;
[pose_caffe, ~, ~, ~] = applyNet(im.names, opt, pp);

% Kalman Filter
opt.numFiles = numel(im.names);
pose = kf_apply(pose_caffe, Q, R);

% Visualize results if desired
%visualize_pose(pp, im, pose, [])

% Save the date and estimated pose
estimated_pose.date = dateTime;
estimated_pose.pose = pose;

% Save data as a mat file
save(['./estimated_pose_' dateTime '.mat'],'estimated_pose','-v7.3');
