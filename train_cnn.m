%% train_cnn.m
%   ---- AUTHOR INFORMATION ----
%   Kenny Chen
%   Translational Neuroengineering Laboratory (TNEL) @ UC San Diego

clear; close all;
dateTime = datestr(now,'mm-dd-yy_HH:MM:SS');

%% Setup & Options
run patientpose_setup
run patientpose_options

%% Training Images
% Load images being tracked
disp('Select the folder containing training images');
im.folder = uigetdir('','Folder containing images');
addpath(im.folder);
im.files = dir(fullfile(im.folder,'*.jpg'));

% Sort the files in natural counting order
im.names = {im.files.name};
im.namesNatSort = natsortfiles(im.names);

%% Training Annotations
% Load ground truth annotations for training images
disp('Select training annotations');
uiopen('matlab');

%% Create training files
% Create video from images
pdir = pwd;

cd(tnelOpt.input2vidloc);
images2video(im, dateTime)

cd(pdir);

% Create training files
videoname = strcat('input2_',dateTime);
dataset = 'youtube';
[opts, folder] = load_system_options(dataset, videoname);
[filename, folder] = setup_filenames(folder, videoname, dataset);

fusion.setupFinetuningCropped(opts.cnn,dataset,videoname,...
    filename.video,detections.manual.frameids,...
    detections.manual.locs,detections.manual.frameids(1),...
    detections.manual.locs(:,:,1),opts.imscale,...
    opts.cnn.finetune.dims(1),opts.cnn.finetune.dims(2),dateTime);

copyfile([tnelOpt.personalizeloc '+fusion/fusion_training/youtube/heatmap_finetuned/' videoname '/train_' dateTime '.sh']);

error('Run created .sh file in terminal');
