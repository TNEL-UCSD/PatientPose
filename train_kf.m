%% train_kf.m
%  
% Trains the Kalman filter process and measurement noise parameters according.
% Training images that are used are from get_training_data.py
%
% Inputs:
%   - Folder containing Kalman filter training data, extracted using the
%     get_training_data.py script
%   - Trained CNN model for the subject
%
% Outputs:
%   - QR process and measurement noise parameters, saved in ./parameters/
%
% Translational Neuroengineering Laboratory (TNEL) @ UC San Diego
% Website: http://www.tnel.ucsd.edu

clear; close all;
dateTime = datestr(now,'mm-dd-yy_HH:MM:SS');

%% Setup & Options
run patientpose_setup
run patientpose_options

%% Load Kalman Filter Training Images
disp('Select the folder containing Kalman filter training images');
im.folder = uigetdir('','Folder containing Kalman filter training images');
addpath(im.folder);
im.files = dir(fullfile(im.folder,'*.jpg'));
im.names = natsortfiles({im.files.name});

%% Apply Model to KF Training Data
opt.modelFile = '/home/kjchen/Documents/tnel_patient-analysis/models/ny531.caffemodel';
[kf_raw, ~, ~, ~] = applyNet(im.names, opt, pp);

%% Load GT KF Training Data
disp('Load the ground truth data for the Kalman filter training images');
uiopen('matlab');
kf_gt = detections.manual.locs;

%% Train KF Noise Parameters
[Q,R] = kf_train(kf_gt, kf_raw);

%% Save
save([pwd '/parameters/QR_' dateTime '.mat'],'Q','R');

