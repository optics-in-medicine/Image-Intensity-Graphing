%set up workspace
close;
clear all;

%%%set up subtightplot (code from demo)

%subtightplot code - and demo code - from:
%https://www.mathworks.com/matlabcentral/fileexchange/39664-subtightplot
make_it_tight = true;
subplot = @(m,n,p) subtightplot (m, n, p, [0.09 0.04], [0.05 0.01], [0.03 0.01]);
if ~make_it_tight,  clear subplot;  end

%read images, establish image variables:
%Fluorescent Image (ABY/PpIX)
image1_name = '509B_im1a.tif'; 
im1Name = 'IM1'; 
image1_rgb = imread(image1_name); 
image1 = rgb2gray(image1_rgb); 

%Fluorescent Image (ABY/PpIX)
image2_name = '509B_im2a.tif'; 
im2Name = 'IM2'; 
image2_rgb = imread(image2_name); 
image2 = rgb2gray(image2_rgb); 

%H&E image
HE_name = '509B_im2a.tif'; 
HE_rgb = imread(HE_name);
HE = rgb2gray(HE_rgb); 
HEName = HE_name(1:4);

%show H&E image - use to trace mask around brain, tumor
imshow(HE_rgb); 
% Enlarge figure to full screen, name figure (instructions for user)
set(gcf, 'Units', 'Normalized', 'OuterPosition', [0 0 1 1],'name','Trace the boundary of the brain'); 
%trace BRAIN
g = imfreehand();
% Create a mask from outline of BRAIN
BrainMask = createMask(g);

%figure name = instructions for user
set(gcf, 'Units', 'Normalized', 'OuterPosition', [0 0 1 1],'name','Trace the boundary of the tumor');
%Outline TUMOR
h = imfreehand();
% Create a mask from outline of TUMOR
mask = createMask(h); 
hold on;
%get points along tumor boundary
line_mask = bwboundaries(mask);
hold on;
line_mask = line_mask{1};
x_margin = line_mask(:,1); y_margin = line_mask(:,2);

close;

counting1 = 0; %used to make intensity matrix
counting2 = 0;
margin_length = length(x_margin); 


for k = 1:margin_length-2
    x = x_margin(k:k+2); y = y_margin(k:k+2); 
    center(1) = x_margin(k+1); center(2) = y_margin(k+1);
    %find line of best fit - tangent to margin
    best_fit = polyfit(x,y,1);
    %get slope of best_fit
    slope = best_fit(1);
    angle = atan(slope);
    angle1 = angle +(pi/2);
    angle2 = angle -(pi/2);
    %gets points (outside/inside) 15 pixels from margin perp. to best_fit slope
    [x1 y1] = pol2cart(angle1,15);
    [x2 y2] = pol2cart(angle2,15);
    X = [round(x1) round(x2)]; Y = [round(y1) round(y2)];
    X = X + center(1); Y = Y + center(2);
    %makes sure line starts outside tumor, ends inside tumor
    if mask(X(1),Y(1)) == 0
        X = [X(1) X(2)]; Y = [Y(1) Y(2)];
    else
        X = [X(2) X(1)]; Y = [Y(2) Y(1)];
    end

 X_lin = linspace(X(1),X(2),31);
 Y_lin = linspace(Y(1),Y(2),31);
 
 %reject lines that go partly through tumor, partly out of tumor
    for k = 1:15
        if mask(round(X_lin(k)),round(Y_lin(k)))==1; %reject
            X = 0;
            Y = 0;
        end
    end
    for k = 16:31
        if mask(round(X_lin(k)),round(Y_lin(k)))==0; %reject
            X = 0;
            Y = 0;
        end
    end 
    
    %reject lines that go outside of brain
    if BrainMask(round(X_lin(1)),round(Y_lin(1)))==0;
        X = 0;
        Y = 0;
    end
    
    %get intensity of line - IM1
    intensity1 = improfile(image1,Y,X);
    length1 = numel(intensity1);
    if length1 >=23
        intensity1 = interp1(linspace(0,1,length1),intensity1,linspace(0,1,23));
        counting1 = counting1 + 1;
        %plot(Y,X)
        intensity1_matrix(counting1,:) = intensity1;
    end
    
    %get intensity of line - IM2 
    intensity2 = improfile(image2,Y,X);
    length2 = numel(intensity2);
    if length2 >=23
        intensity2 = interp1(linspace(0,1,length2),intensity2,linspace(0,1,23));
        counting2 = counting2 + 1;
        %plot(Y,X)
        intensity2_matrix(counting2,:) = intensity2;
    end
    
end

intensity1_avg = mean(intensity1_matrix);
intensity1_std = std(intensity1_matrix);


intensity2_avg = mean(intensity2_matrix);
intensity2_std = std(intensity2_matrix);


%%%%%%%%%%%%%%%%%%%%%%%DISPLAY

figure
set(gcf, 'Units', 'Normalized', 'OuterPosition', [0 0 0.7 1]); 
subplot(2,2,1)
imshow(image1_rgb);
hold 
plot(y_margin, x_margin, 'r', 'LineWidth', 2);
text(280,10,im1Name,...
    'FontSize',14,'Fontname','Arial','HorizontalAlignment','center')
subplot(2,2,3)
imshow(image2_rgb);
hold 
plot(y_margin, x_margin, 'r', 'LineWidth', 2);
text(280,10,im2Name,...
    'FontSize',14,'Fontname','Arial','HorizontalAlignment','center')
subplot(2,2,[2 4]) 
errorbar(intensity1_avg,intensity1_std);
hold;
errorbar(intensity2_avg,intensity2_std);
legend('im1','im2','Location','southeast');
ylabel('intensity');

clc

%find slope from 1 -> max intensity

%im1
max_intensity_1 = 0;
vector1_length = size(intensity1_avg);
vector1_length = vector1_length(2);
for q = 1:vector1_length
    if intensity1_avg(q) > max_intensity_1
        max_intensity_1 = intensity1_avg(q);
        x1_value = q;
    end
end
x = linspace(1,x1_value,x1_value);
y = intensity1_avg(1:x1_value);
p = polyfit(x,y,1);
slope_1 = p(1)

%im2
max_intensity_2 = 0;
vector2_length = size(intensity2_avg);
vector2_length = vector2_length(2);
for k = 1:vector2_length
    if intensity2_avg(k) > max_intensity_2
        max_intensity_2 = intensity2_avg(k);
        x2_value = k;
    end
end
x = linspace(1,x2_value,x2_value);
y = intensity2_avg(1:x2_value);
p = polyfit(x,y,1);
slope_2 = p(1)