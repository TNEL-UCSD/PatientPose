function [resizedImage] = resize_image(originalImage,rows,cols)

% Create a temp file and resize it accordingly
temp = imresize(originalImage,[cols rows]);

if rows > cols
    % If the image is tall, pad in the width direction
    resizedImage = padarray(temp,[(rows-cols)/2 0],0);
elseif cols > rows
    % If the image is fat, pad in the height direction
    resizedImage = padarray(temp,[0 (cols-rows)/2],0);
else
    % If the image is square, don't do anything
    resizedImage = temp;
end

end
