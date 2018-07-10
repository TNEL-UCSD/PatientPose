%function to visualise video and joint locations
function show_skeleton(videofilename,imscale,frameids,locs,secs)

vidobj = VideoReader(videofilename);
figure
img = imresize(read(vidobj,frameids(1)),imscale);

% Gaussian blur
%sigma = 3;
%img = imgaussfilt(img, sigma);

h_img = imagesc(img);

axis fill;
hold on
h_plot = plot_skeleton(zeros(2,size(locs,2)),inf(2,size(locs,2)),1,[],[]);
h_title = title(sprintf('Showing frame %d of %d',1,numel(frameids)));

for i = 1:numel(frameids)
    img = imresize(read(vidobj,frameids(i)),imscale);
    
    % Gaussian blur
    %sigma = 3;
    %img = imgaussfilt(img, sigma);
    
    set(h_img,'cdata',img);
    plot_skeleton(locs(:,:,i),inf(2,size(locs,2)),1,[],h_plot);
    set(h_title,'string',sprintf('Showing frame %d of %d',i,numel(frameids)));
    %drawnow
    
    set(gcf,'position',[0 0 500 500]);
    
    % Save images
    %saveas(gcf,['/home/kjchen/Documents/personalized/' strcat('personalized_',num2str(i),'.png')]);
    
    if secs < 0
        pause
    else
        pause(secs)
    end
    %waitforbuttonpress;
end