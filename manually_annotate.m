%% manually_annotate.m
%   ---- AUTHOR INFORMATION ----
%   Kenny Chen
%   Translational Neuroengineering Laboratory (TNEL) @ UC San Diego

clear all; close all;
dateTime = datestr(now,'mm-dd-yy_HH:MM:SS');

%% Setup & Options
run patientpose_setup
run patientpose_options
execute = true;

%% Load Images and Labels
% Load images being tracked
disp('Select the folder containing images');
im.folder = uigetdir('','Folder containing images');
addpath(im.folder);
im.files = dir(fullfile(im.folder,'*.jpg'));

% Sort the files in natural counting order
im.names = {im.files.name};
im.namesNatSort = natsortfiles(im.names);

% Create mat_files folder
if ~exist(strcat(im.folder,'/mat_files/'))
    mkdir(strcat(im.folder,'/mat_files/'));
end

% Load joint labels
prev = input('Existing annotation file? (y/n)\n','s');
if strcmp(prev,'y')
    disp('Select file');
    uiopen('matlab');
    detections.manual.locs = joints;
    startingFrame = input('Enter the frame number to start at: ');
elseif strcmp(prev,'n')
    detections.manual.locs = zeros(2,7,length(im.names));
    detections.manual.locs(:,:,1) = [117 100 153 55 188 67 166; 53 132 125 127 103 76 67];
    startingFrame = 1;
else
    error('Incorrect input\n')
end

%% Manual Annotations
disp('Left click to drag joints to correct locations. ''w'' to continue. ''q'' to go back. ''c'' to copy previous skeleton.\nBackspace to exclude frame. Escape to save and quit.');

img = imread(im.namesNatSort{1});
h_figure = figure;
h_img = imagesc(img); axis image; hold on;
h_plot = plot_skeleton(zeros(2,size(detections.manual.locs,2)),inf(2,size(detections.manual.locs,2)),1,[],[]);
h_title = title(sprintf('Showing frame %d of %d',1,length(im.namesNatSort)));

frameNum = startingFrame;

while frameNum <= length(im.namesNatSort)
    img = imread(im.namesNatSort{frameNum});
    
    % Gaussian blur
    if tnelOpt.blurimage
        img = imgaussfilt(img, 2);
    end
    
    % Set title
    set(h_img,'cdata',img);
    set(h_title,'string',sprintf('Showing frame %d of %d',frameNum,length(im.namesNatSort)));
    
    % Plot the skeleton
    plot_skeleton(detections.manual.locs(:,:,frameNum),inf(2,size(detections.manual.locs,2)),1,[],h_plot);
    
    % Create draggable points
    for jointNum = 1:7
        correctedJoints(jointNum) = impoint(gca,detections.manual.locs(1,jointNum,frameNum),detections.manual.locs(2,jointNum,frameNum));
    end
    
    % Check button presses
    while 1
        % Wait for any action
        w = waitforbuttonpress;
        switch w
            case 1
                key = get(h_figure,'CurrentKey');
                switch key

                    case 'c'
                        % copy previous skeleton
                        for jointNum = 1:7
                            delete(correctedJoints(jointNum));
                        end
                        
                        % Plot the skeleton
                        plot_skeleton(detections.manual.locs(:,:,frameNum-1),inf(2,size(detections.manual.locs,2)),1,[],h_plot);
                        
                        % Create draggable points
                        for jointNum = 1:7
                            correctedJoints(jointNum) = impoint(gca,detections.manual.locs(1,jointNum,frameNum-1),detections.manual.locs(2,jointNum,frameNum-1));
                        end

                    case 'w'
                        % Save dragged joints
                        for i = 1:7
                            newJoints(1:2,i) = getPosition(correctedJoints(i))';
                        end
                        detections.manual.locs(:,:,frameNum) = newJoints;
                        detections.manual.locs(:,:,frameNum)
                        break;

                    case 'q'
                        % Save dragged joints
                        for i = 1:7
                            newJoints(1:2,i) = getPosition(correctedJoints(i))';
                        end
                        detections.manual.locs(:,:,frameNum) = newJoints;
                        detections.manual.locs(:,:,frameNum)
                        
                        frameNum = frameNum - 2;
                        break;

                    case 'backspace'
                        % Discard image by setting all points to -999
                        detections.manual.locs(:,:,frameNum) = -999;
                        break;
                        
                        % TODO: option to undo discarding image
 
                    case 'escape'
                        % Save and quit
                        execute = false;
                        break;
                end
        end
        
        % Save dragged joints
        for i = 1:7
            newJoints(1:2,i) = getPosition(correctedJoints(i))';
        end
        detections.manual.locs(:,:,frameNum) = newJoints;
        detections.manual.locs(:,:,frameNum)
        
        % Plot newly dragged joints
        plot_skeleton(detections.manual.locs(:,:,frameNum),inf(2,size(detections.manual.locs,2)),1,[],h_plot);
        drawnow;
    end
    
    % Delete joints for next iteration
    delete(correctedJoints);
    
    % Save and quit if escape is pressed
    if execute == false
        disp(['Saving progress at frame ' num2str(frameNum) '.']);
        startingFrame = frameNum;
        close(gcf);
        execute = true;
        detections.manual.locs = double(detections.manual.locs);
        save([strcat(im.folder,'/mat_files/corrected-detections_') dateTime],'detections','-v7.3');
        save([strcat(im.folder,'/mat_files/current-frame_') dateTime],'startingFrame','-v7.3');
        break;
    end
    
    % Done
    if frameNum == length(im.namesNatSort)
        disp('Done!');
        startingFrame = frameNum;
        close(gcf);
        execute = true;
        detections.manual.locs = double(detections.manual.locs);
        save([strcat(im.folder,'/mat_files/corrected-detections_') dateTime],'detections','-v7.3');
        save([strcat(im.folder,'/mat_files/current-frame_') dateTime],'startingFrame','-v7.3');
    end
    
    % Add to counter
    frameNum = frameNum + 1;
end
