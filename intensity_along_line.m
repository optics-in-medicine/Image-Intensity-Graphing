%Code adapted from:
%http://www.mathworks.com/matlabcentral/answers/112348-how-to-get-intensity-along-a-spcific-curve
%(Image Analyst's answer)
%--Clare

function[] = intensity_along_line(image1,image2)

%%Image #1
image = rgb2gray(imread(image1)); %image #1: read, convert to grayscale
subplot(2,2,1); imshow(image); %show image in upper left quadrant
title(image1(1:4)) %show first four letters of file name (e.g. "501B")// adjust based on file name  
set(gcf, 'Units', 'Normalized', 'OuterPosition', [0 0 1 1]); % Enlarge figure to full screen

h = imline(gca,[100 475], [200 200]); %change these numbers to change the length/position of the line
%**If the length of the above line is changed, change the length for image 2 also.
% h = imline(); %% uncomment to hand-draw the line. 
% Create a mask 
mask = createMask(h);
% Plot line over original image.
line = bwboundaries(mask);
hold on;
line = line{1};
x = line(:,2); y = line(:,1);
plot(x, y, 'r', 'LineWidth', 1);
hold off;
% extract all pixels along this line
for k = 1 : length(x)/2 %1/2 the "boundary" for the line is the length of the line
 	line_length(k) = image(y(k), x(k)); % logical indexing
end
subplot(1,2,2);
plot(line_length);
hold on;

%Image #2
image = rgb2gray(imread(image2));
subplot(2,2,3); %bottom left quadrant
imshow(image);
title(image2(1:4))
% Enlarge figure to full screen.
set(gcf, 'Units', 'Normalized', 'OuterPosition', [0 0 1 1]);
h = imline(gca,[100 475], [200 200]);
%h = imline(); %uncomment to hand-draw line
% Create a mask 
mask = createMask(h);
% Find boundaries and plot over original image.
line = bwboundaries(mask);
hold on;
line = line{1};
x = line(:,2); y = line(:,1);
plot(x, y, 'r', 'LineWidth', 1);
hold off;
% extract all pixels along this line
for k = 1 : length(x)/2 
 	line_length(k) = image(y(k), x(k)); % logical indexing
end
subplot(1,2,2);
plot(line_length);
grid on;
xlabel('Distance');
ylabel('Gray Level');
legend (image1(1:4),image2(1:4))

clc;
