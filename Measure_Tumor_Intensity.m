%%%% Measure_Tumor_Intensity function %%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%CITED
%Code adapted from:
%<http://www.mathworks.com/matlabcentral/answers/112348-how-to-get-intensity-along-a-spcific-curve>
%(Image Analyst's answer)
%Function uses getborder function: included w/in this function
%http://www.mathworks.com/matlabcentral/fileexchange/12303-getborder
%by Wolfgang Schwanghart
%Copyright (c) 2009, Wolfgang Schwanghart
% All rights reserved. - License information included with getborder function

%This function produces a graph showing the intensities around the margin of the tumor, 
%inside the tumor, and outside the tumor - i.e. the "normal" tissue, and
%also calculates the mean intensity value for tumor/margin/"normal"

function [avg_outer_intensity,avg_margin_intensity,avg_inner_intensity] = Measure_Tumor_Intensity2(image)

imName = image(1:4); %kite file images' names are the first four characters in the string of images
image = imread(image); 
subplot(1,2,1); imshow(image); title(imName); image = rgb2gray(image); 
set(gcf, 'Units', 'Normalized', 'OuterPosition', [0 0 1 1]); % Enlarge figure to full screen
%Outline tumor
h = imfreehand();
% Create a mask from outline
mask = createMask(h); 
hold on;
% Plot line over original image.
line_mask = bwboundaries(mask);
hold on;
line_mask = line_mask{1};
x_margin = line_mask(:,1); y_margin = line_mask(:,2);
plot(y_margin, x_margin, 'r', 'LineWidth', 2);

%"normal" tissue
outer = getborder(mask,'outside'); %see getborder funct *** can adjust to change the distance from the margin
line = bwboundaries(outer);
line = line{1};
x_outer = line(:,1); y_outer = line(:,2);
%get intensity outside of tumor
for k = 1 : length(x_outer) 
 	outer_length(k) = image(x_outer(k), y_outer(k)); 
end
avg_outer_intensity = mean(outer_length(1 : length(x_outer)));
subplot(1,2,2); 
plot(outer_length);
hold on;

%margin
for k = 1 : length(x_margin) 
   margin(k) = mean2(image(x_margin(k)-2:x_margin(k)+2, y_margin(k)-2: y_margin(k)+2)); 
end
avg_margin_intensity = mean(margin(1 : length(x_margin)));
subplot(1,2,2); 
plot(margin); %graph intensity of margin
hold on;

%tumor
%getborder doesn't work for inside tumor
%shrink mask and center over original mask center
findCenter = regionprops(mask,image,'WeightedCentroid');
center = findCenter.WeightedCentroid;
inner = imresize(mask,0.90); %change this to adjust distance from tumor to margin
image_small = imresize(image,0.90); %and change this to match above
findCenter_Inner = regionprops(inner, image_small, 'WeightedCentroid');
inner_center = findCenter_Inner.WeightedCentroid;
%find distance between inner center and mask center
X = center(1); Y = center(2);
x = inner_center(1); y = inner_center(2);
diffX = X-x; diffY = Y-y;
inner = imtranslate(inner,[diffX diffY]); %center tumor mask over margin mask
line = bwboundaries(inner);
line = line{1};
x_inner = line(:,1); y_inner = line(:,2);
for k = 1 : length(x_inner) 
    if mask(x_inner(k),y_inner(k)) == 0
        %if tumor mask goes outside of margin mask, move tumor edge to
        %margin
        x(1) = x_inner(k);
        x(2) = y_inner(k);
        closest = knnsearch(line_mask,x);
        x_inner(k) = line_mask(closest,1);
        y_inner(k) = line_mask(closest,2);
        inner_length(k) = image(x_inner(k),y_inner(k)); 
    else
        inner_length(k) = image(x_inner(k),y_inner(k));
    end
end
avg_inner_intensity = mean(inner_length(1 : length(x_inner)));
plot(inner_length);
hold on;
subplot(1,2,2);
title(imName);
xlabel('Distance');
ylabel('Gray Level');
legend('"normal" tissue', 'margin', 'tumor', 'Location', 'SouthWest');



%getborder function:


%Copyright (c) 2009, Wolfgang Schwanghart
% All rights reserved.
% 
% Redistribution and use in source and binary forms, with or without
% modification, are permitted provided that the following conditions are
% met:
% 
%     * Redistributions of source code must retain the above copyright
%       notice, this list of conditions and the following disclaimer.
%     * Redistributions in binary form must reproduce the above copyright
%       notice, this list of conditions and the following disclaimer in
%       the documentation and/or other materials provided with the distribution
% 
% THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
% AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
% IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
% ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE
% LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
% CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
% SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
% INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
% CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
% ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
% POSSIBILITY OF SUCH DAMAGE.

function Ib = getborder(I,method);

% create border inside or outside a mask of logical arrays
%
% Ib = getborder(Ib,method)
% _________________________________________________________________________
%
% getborder returns the outline around logical values in A (mask) using a 8-
% connected neighborhood. 
% A must be a logical n*m matrix. method 'inside' returns the inner border 
% around "islands" of logical values. 'outside' returns the border outside 
% the islands.
% 
% Example:
%
% I = peaks(8)<0
% 
% I =
% 
%      0     0     1     1     1     1     1     1
%      0     0     1     1     1     1     1     0
%      1     0     0     1     1     1     0     0
%      1     1     1     0     0     0     0     0
%      1     1     1     0     0     0     0     0
%      1     1     0     0     0     0     0     0
%      0     0     0     0     0     0     0     0
%      0     0     0     0     0     0     0     0
% 
% Ib = getborder(I,'inside')
% 
% Ib =
% 
%      0     0     1     1     1     1     1     1
%      0     0     1     1     0     1     1     0
%      1     0     0     1     1     1     0     0
%      1     1     1     0     0     0     0     0
%      1     1     1     0     0     0     0     0
%      1     1     0     0     0     0     0     0
%      0     0     0     0     0     0     0     0
%      0     0     0     0     0     0     0     0
%      
% Ib = getborder(I,'outside')
% 
% Ib =
% 
%      0     1     0     0     0     0     0     0
%      1     1     0     0     0     0     0     1
%      0     1     1     0     0     0     1     1
%      0     0     0     1     1     1     1     0
%      0     0     0     1     0     0     0     0
%      0     0     1     1     0     0     0     0
%      1     1     1     0     0     0     0     0
%      0     0     0     0     0     0     0     0

% _________________________________________________________________________
% Wolfgang Schwanghart
%

% check input
if nargin~=2;
    error('wrong number of input arguments')
end

if ~islogical(I);
    error('I must be a logical matrix');
end

if strncmpi(method, 'inside', 1);
    method = 'inside';
elseif strncmpi(method, 'outside', 1);
    method = 'outside';
else
    error('unknown method');
end
    
% Kernel
B   = ones(15,15);
% convolution
C   = conv2(double(I),B,'same');

% create border
switch lower(method);
    case {'inside'};
        Ib = C<9 & I;
    case {'outside'};
        Ib = C>0 & ~I;
end