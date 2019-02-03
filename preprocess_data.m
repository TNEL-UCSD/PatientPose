%% preprocess_data.m
%
% Preprocesses a selected folder of RGB patient data by first cropping the 
% images to 256x256 dimensions, then normalizing each image's brightness via 
% contrast-limited adaptive histogram equalization (CLAHE) on the HSV-converted 
% frame's v-layer. The location of cropping is selected by right-click dragging 
% on the pop-up containing the folder's first image.
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

%% Select Folder Containing Raw Data
disp('Select folder containing raw data.');
d = dir(uigetdir);
im.rawPath = [d(1).folder '/'];

%% Create Cropping Rectangle and Save
disp(['Select the location to crop the images. Right-click to drag square (starting from the top-left corner).']);
rectImg = [im.rawPath d(3).name];
imshow(imgaussfilt(imread(rectImg), pp.blurimagesigma1080));
rect = getrect; close all;

% Create mat_files folder
if ~exist([im.rawPath,'/mat_files/'])
    mkdir([im.rawPath '/mat_files/']);
end

save([im.rawPath '/mat_files/rect_' dateTime],'rect','-v7.3');

%% Loop Through Subfolders Containing Raw Data
disp('Processing the image folder...');

% Process raw data
im.files = dir(fullfile(im.rawPath, strcat('*.',pp.inputfiletype)));

% Read and sort names
im.names = natsortfiles({im.files.name});

% Create folder to contain adapthisteq images
if ~exist([im.rawPath '/preprocessed'])
    mkdir(im.rawPath,'preprocessed');
end

for i = 1:length(im.names)
    disp(['Processing frame ' num2str(i) ' of ' num2str(length(im.names))]);
    
    % Read image
    try
        image = imread(im.names{i});
    catch
        warning(['Unable to read ' im.names{i} '. File may be corrupt.']);
        continue;
    end

    % Crop images
    cropped = imcrop(image, rect);
    resizedImage = resize_image(cropped, 256, 256);

    % Adaptive Histogram equalization
    img_hsv = rgb2hsv(resizedImage);
    img_h = img_hsv(:,:,1);
    img_s = img_hsv(:,:,2);
    img_v = adapthisteq(img_hsv(:,:,3));
    img_hsv_norm = cat(3,img_h,img_s,img_v);
    img_rgb_norm = hsv2rgb(img_hsv_norm);
    
    % Save image to disk
    imwrite(img_rgb_norm,[im.rawPath 'preprocessed/preprocessed_' num2str(i) '.' pp.inputfiletype]);
end

disp('Done.')
