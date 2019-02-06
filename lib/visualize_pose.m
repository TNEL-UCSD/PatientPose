function [] = visualize_pose(pp, im, pose, heatmapVis)

% Visualize the output of Caffe-Heatmap
if pp.visualizeoutput1
    % Create a folder to save overlayed images in
    mkdir(im.folderPath,'pose');
    mkdir(im.folderPath,'heatmap');
    
    % Show the first image to set the window boundaries
    img = imgaussfilt(imread(im.names{1}),pp.blurimagesigma256);
    
    % Create image handle
    h_img = imagesc(img);
    axis fill; hold on;
    h_plot = plot_skeleton(zeros(2,size(pose,2)),inf(2,size(pose,2)),1,[],[]);
    h_title = title(sprintf('Showing frame %d of %d',1,length(im.names)));
    pause(3);
    
    for i = 1:length(im.names)
        
        if pp.visualizeoutput1Skel
            disp(['Saving pose overlay image ' num2str(i) ' of ' num2str(length(im.names))]);
            
            % Process image
            if pp.blurimage
                img = uint8(imgaussfilt(imread(im.names{i}), pp.blurimagesigma256));
            else
                img = uint8(imread(im.names{i}));
            end
            
            % Overlay pose on image and save
            set(h_img,'cdata',img);
            plot_skeleton(pose(:,:,i),inf(2,size(pose,2)),1,[],h_plot);
            set(h_title,'string',sprintf('Showing frame %d of %d',i,length(im.names)));
            set(gcf,'position',[0 0 500 500]);
            saveas(gcf, [im.folderPath 'pose/patientpose_' num2str(i) '.jpg']);
        end
        
        if pp.visualizeoutput1Heatmap
            disp(['Saving heatmap image ' num2str(i) ' of ' num2str(length(im.names))]);
            
            % Save heatmap images
            imwrite(heatmapVis(:,:,:,i),strcat(strcat(strcat(im.folderPath,'/heatmap/'),strcat('heatmap_',num2str(i))),'.jpg'));
             
        end
        
        if i == length(im.names)
            disp('Done.');
        end
    end
end

end