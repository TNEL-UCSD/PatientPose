%% train_cnn.m
%  
% Generates a bash script that trains the CNN model when executed in terminal.
% Prior to generating the script, training data is prepared and saved in:
%
%   ./caffe-heatmap/model-trainer/+fusion/training_data
%
% The underlying CNN model training framework is derived from the following works:
%
%   T. Pfister, J. Charles, and A. Zisserman, "Flowing ConvNets for human pose estimation in videos," 
%       in Proc. IEEE Int. Conf. Comput. Vis., Dec. 2015, pp. 1913-1921.
%
%   J. Charles, T. Pfister, D. Magee, D. Hogg, and A. Zisserman, "Personalizing human video pose estimation,"
%       in Proc. IEEE Comput. Soc. Conf. Comput. Vis. Pattern Recognit. (CVPR), Jun. 2016, pp. 3063-3072.
%
% Usage:
%   Run this while the current directory is in the top-level folder of the
%   PatientPose package
%
% Inputs:
%   - Folder containing the preprocessed training images
%   - Ground truth pose annotations generated via label_images.m as a .mat file
%
% Outputs:
%   - A bash script located in ./caffe-heatmap/model-trainer/training_scripts/
%     to train the patient CNN model
%
% Translational Neuroengineering Laboratory (TNEL) @ UC San Diego
% Website: http://www.tnel.ucsd.edu

clear; close all;
dateTime = datestr(now,'mm-dd-yy_HH:MM:SS');

%% Setup & Options
run patientpose_setup
run patientpose_options

%% Training Images
% Load images being tracked
disp('Select the folder containing the preprocessed training images');
im.folder = uigetdir('','Folder containing images');
addpath(im.folder);
im.files = dir(fullfile(im.folder,'*.jpg'));

% Sort the files in natural counting order
im.names = natsortfiles({im.files.name});

%% Training Annotations
% Load ground truth annotations for training images
disp('Select training ground truth poses generated via label_images.m');
uiopen('matlab');

%% Create training files
% Create video from images
pdir = pwd;
cd(pp.input2vidloc);
images2video(im, dateTime)
cd(pdir);

% Create the training files
videoname = strcat('input2_',dateTime);
dataset = 'youtube';
[opts, folder] = load_system_options(dataset, videoname);
[filename, folder] = setup_filenames(folder, videoname, dataset);

fusion.setupFinetuningCropped(opts.cnn,dataset,videoname,...
    filename.video,detections.manual.frameids,...
    detections.manual.locs,detections.manual.frameids(1),...
    detections.manual.locs(:,:,1),opts.imscale,...
    opts.cnn.finetune.dims(1),opts.cnn.finetune.dims(2),dateTime);

% Create training scripts folder and copy to folder
if ~exist([pp.personalizeloc '/training_scripts/'])
    mkdir([pp.personalizeloc '/training_scripts/']);
end

copyfile([pp.personalizeloc '+fusion/fusion_training/' dataset '/heatmap_finetuned/input2_' dateTime '/train_' dateTime '.sh'],...
    [pp.personalizeloc 'training_scripts/train_cnn_' dateTime '.sh']);

error('Run the generated .sh file in terminal to train the patient CNN model.');
