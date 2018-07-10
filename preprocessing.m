%% preprocessing.m
%   ---- AUTHOR INFORMATION ----
%   Kenny Chen
%   Translational Neuroengineering Laboratory (TNEL) @ UC San Diego

clear all; close all;
dateTime = datestr(now,'mm-dd-yy_HH:MM:SS');

%% Setup & Options
run patientpose_setup
run patientpose_options

%% Select Top-Level Folder with Subfolders of Raw Data
disp('Select folder of folder(s) containing raw data.');
d = dir(uigetdir);
isub = [d(:).isdir];
rawPath = [d(1).folder '/'];
rawDataFolders = {d(isub).name}';
rawDataFolders(ismember(rawDataFolders,{'.','..'})) = [];

%% Select Top-Level Folder to Save Processed Data
disp('Select folder to save data.');
im.folderSaveTop = uigetdir('','Folder to Save Processed Images');
addpath(im.folderSaveTop);
cd(im.folderSaveTop);

%% Create Cropping Rectangle and Save
rect = cell(length(rawDataFolders));
for rawFolderNum = 1:length(rawDataFolders)
    if exist([rawPath rawDataFolders{rawFolderNum} '/Color/ColorFrame_1.jpg'])
        disp(['Creating cropping rectangle for raw folder ' num2str(rawFolderNum) ' of ' num2str(length(rawDataFolders)) '. Right-click to drag square (starting from the top-left corner).']);
        rectImg = [rawPath rawDataFolders{rawFolderNum} '/Color/ColorFrame_1.jpg'];
        imshow(imgaussfilt(imread(rectImg), tnelOpt.blurimagesigma1080));
        rect{rawFolderNum} = getrect; close all;
    else
        disp(['No more color data! Only ' num2str(length(rect)) ' out of ' num2str(length(rawDataFolders)) ' folders contained RGB images.']);
        break;
    end
end

save(strcat('croplocations_',dateTime),'rect','-v7.3');

%% Loop Through Subfolders Containing Raw Data
for rawFolderNum = 1:length(rawDataFolders)%length(rect)
    disp(['Processing raw folder with color data ' num2str(rawFolderNum) ' of ' num2str(length(rawDataFolders)) '...']);
    
    % Process raw data
    im.folder = [rawPath rawDataFolders{rawFolderNum} '/cropped/'];
    addpath(im.folder);
    im.files = dir(fullfile(im.folder, strcat('*.',tnelOpt.inputfiletype)));
    
    % Sort names
    im.names = {im.files.name};
    im.namesNatSort = natsortfiles(im.names);
    
    if ~exist([im.folderSaveTop '/' rawDataFolders{rawFolderNum}])
        mkdir(im.folderSaveTop, rawDataFolders{rawFolderNum});
    end
    
    im.folderSave = [im.folderSaveTop '/' rawDataFolders{rawFolderNum}];
    cd(im.folderSave);
    
    % Create folder to contain adapthisteq images
    if ~exist([im.folderSave '/adapthisteq'])
        mkdir(im.folderSave,'adapthisteq');
    end
      
    for i = 1:length(im.namesNatSort)
        % Read image
        try
            image = imread(im.namesNatSort{i});
        catch
            warning(['Unable to read ' im.namesNatSort{i} ' in folder ' rawDataFolders{rawFolderNum} '. File may be corrupt.']);
            continue;
        end
                 
        % Crop images
        disp(['Cropping frame ' num2str(i) ' of ' num2str(length(im.namesNatSort))]);
        cropped = imcrop(image, rect{rawFolderNum});
        resizedImage = resize_image(cropped,256,256);

        % Adaptive Histogram equalization
        disp(['Adaptive histogram equalizing frame ' num2str(i) ' of ' num2str(length(im.namesNatSort))]);
        img_hsv = rgb2hsv(resizedImage);
        img_h = img_hsv(:,:,1);
        img_s = img_hsv(:,:,2);
        img_v = adapthisteq(img_hsv(:,:,3));
        img_hsv_norm = cat(3,img_h,img_s,img_v);
        img_rgb_norm = hsv2rgb(img_hsv_norm);
        imwrite(img_rgb_norm,['adapthisteq/adapthisteq_' num2str(i) '.' tnelOpt.inputfiletype]);
    end
end
