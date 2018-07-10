%% patientpose.m
%   ---- AUTHOR INFORMATION ----
%   Kenny Chen
%   Translational Neuroengineering Laboratory (TNEL) @ UC San Diego

clear all; close all;
dateTime = datestr(now,'mm-dd-yy_HH:MM:SS');

%% Setup & Options
run patientpose_setup
run patientpose_options

%% Select Top-Level Folder with Subfolders of Data
disp('Select top-level folder of raw data.');
d = dir(uigetdir);
isub = [d(:).isdir];
rawPath = [d(1).folder '/'];
rawDataFolders = {d(isub).name}';
rawDataFolders(ismember(rawDataFolders,{'.','..'})) = [];

%% Load CNN Model
disp('Select patient CNN model');
[baseName, folder] = uigetfile('*.caffemodel');
opt.modelFile = [folder baseName];

%% Load KF Noise Parameters
disp('Select KF noise parameters')
uiopen('matlab');

%% PatientPose
% apply PatientPose for each folder
for rawFolderNum = 1:length(rawDataFolders)
    disp(['Processing folder ' num2str(rawFolderNum) ' of ' num2str(length(rawDataFolders)) '...']);
    
    % Select folder in order
    im.folderSave = [rawPath rawDataFolders{rawFolderNum} '/adapthisteq'];
    im.folder = im.folderSave;
    im.files = dir(fullfile(im.folder, strcat('*.',tnelOpt.inputfiletype)));
    addpath(im.folderSave);
    addpath(im.folder);
    
    % Sort the files in natural counting order
    im.names = {im.files.name};
    im.namesNatSort = natsortfiles(im.names);
    
    cd(im.folderSave)
    
    % Add directory of processed images
    im.filesSave = dir(fullfile(im.folderSave, strcat('*.',tnelOpt.inputfiletype)));
    im.namesSave = {im.filesSave.name};
    im.namesSaveNatSort = natsortfiles(im.namesSave);
    
    % Apply personalized Caffe-Heatmap
	opt.inputDir = strcat(pwd,'/');
	[joints_256, ~, ~, ~] = applyNet(im.namesNatSort, opt, tnelOpt);

    % Kalman Filter
    opt.numFiles = numel(im.namesSaveNatSort);
    pose = kf_test(joints_256, Q, R);
    
    % Save into cell array
    joints_complete(rawFolderNum).date = rawDataFolders{rawFolderNum};
    joints_complete(rawFolderNum).patientpose = pose;
    
end

% Save final joint poses
save([rawPath 'joints_complete.mat'],'joints_complete','-v7.3');
