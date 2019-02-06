%% patientpose.m
%
% This is the main script in the PatientPose workflow and assumes preprocessing, manual annotations, and CNN caffe model
% & Kalman filter parameter training have been completed. Running this will prompt you to load in the various pieces to
% generate estimated subject poses, but these can be coded in by the user for slightly more automation. The estimated
% poses can be visualized (overlayed on the images) by uncommenting the line which calls the 'visualize_pose' function.
% Additionally, heatmaps for each joint can be outputted through the applyNet function (currently only outputting joint
% values from Pfister's Caffe-Heatmap). Keep in mind however that these heatmaps can be extremely costly in storage
% space if saved.
%
% Usage:
%   1. Select the folder containing your preprocessed images to estimate pose on
%   2. Load your patient CNN caffe model
%   3. Load your patient Kalman filter noise parameters
%   4. Sit back and relax
%
% Inputs:
%   - Preprocessed images to estimate pose on
%   - Patient CNN caffe model
%   - Patient Kalman filter parameters
%
% Outputs:
%   - Estimated poses saved in ./estimated_pose_[dateTime].mat
%   - JPG's of estimated poses overlayed on the subject (if visualize_pose is uncommented), saved in ./pose/ of the
%     selected folder of images. Can also optionally output images of the heatmap (from Pfister et al.'s Caffe-Heatmap)
%     via patientpose_options.m
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

% Apply patient CNN caffe model
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
