function [] = visualize_pose(pp, im, joints, heatmapVis)

% Visualize the output of Caffe-Heatmap
if pp.visualizeoutput1
    % Create a folder to save overlayed images in
    mkdir(im.folderSave,'skel_overlay');
    mkdir(im.folderSave,'heatmap');
    
    % Show the first image to set the window boundaries
    img = imgaussfilt(imread(im.namesSaveNatSort{1}),pp.blurimagesigma256);
    
    % Create image handle
    h_img = imagesc(img);
    axis fill; hold on;
    h_plot = plot_skeleton(zeros(2,size(joints,2)),inf(2,size(joints,2)),1,[],[]);
    h_title = title(sprintf('Showing frame %d of %d',1,length(im.namesSaveNatSort)));
    pause(3);
    
    for i = 1:length(im.namesSaveNatSort)
        
        if pp.visualizeoutput1Skel
            disp(['Saving skeleton overlay image ' num2str(i) ' of ' num2str(length(im.namesSaveNatSort))]);
            
            % Process image
            if pp.blurimage
                img = uint8(imgaussfilt(imread(im.namesSaveNatSort{i}), pp.blurimagesigma256));
            else
                img = uint8(imread(im.namesSaveNatSort{i}));
            end
            
            % Overlay skeleton on image and save
            set(h_img,'cdata',img);
            plot_skeleton(joints(:,:,i),inf(2,size(joints,2)),1,[],h_plot);
            set(h_title,'string',sprintf('Showing frame %d of %d',i,length(im.namesSaveNatSort)));
            set(gcf,'position',[0 0 500 500]);
            saveas(gcf, [im.folderSave '/skel_overlay/skel_overlay_' num2str(i) '.jpg']);
        end
        
        if pp.visualizeoutput1Heatmap
            disp(['Saving heatmap image ' num2str(i) ' of ' num2str(length(im.namesSaveNatSort))]);
            
            % Save heatmap images
            imwrite(heatmapVis(:,:,:,i),strcat(strcat(strcat(im.folderSave,'/heatmap/'),strcat('heatmap_',num2str(i))),'.jpg'));
%             
%             set(h_img,'cdata',heatmapVis(:,:,:,i));
%             saveas(gcf, [im.folderSave '/heatmap/heatmap_' num2str(i) '.svg']);
        end
        
        if i == length(im.namesSaveNatSort)
            disp('Done.');
        end
    end
end

end