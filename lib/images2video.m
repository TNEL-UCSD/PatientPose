function [] = images2video(im, dateTime)

% Create a video object and open it
outputVideo = VideoWriter(strcat('input2_',dateTime,'.avi'));
outputVideo.FrameRate = 30;
open(outputVideo);

% Write images to the video one at a time
for i = 1:length(im.names)
    disp(strcat('Writing images to video...',num2str(i/length(im.names)*100),'%'));
    
    img = imread(im.names{i});
    writeVideo(outputVideo,img);
end

% Close the object
close(outputVideo);

end

