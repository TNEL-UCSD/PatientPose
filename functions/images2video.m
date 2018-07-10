function [] = images2video(im, dateTime)

% Create a video object and open it
outputVideo = VideoWriter(strcat('input2_',dateTime,'.avi'));
outputVideo.FrameRate = 30;
open(outputVideo);

% Write images to the video one at a time
for i = 1:length(im.namesNatSort)
    disp(strcat('Writing images to video...',num2str(i/length(im.namesNatSort)*100),'%'));
    
    img = imread(im.namesNatSort{i});
    writeVideo(outputVideo,img);
end

% Close the object
close(outputVideo);

end

