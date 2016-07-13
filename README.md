# Image-Intensity-Graphing

The current best code for the image intensity graphing is the 
code Tumor_Intensity_FINAL_BothFluorImages
this code requires the function subtightplot, which can be found here: https://www.mathworks.com/matlabcentral/fileexchange/39664-subtightplot

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Everything below refers to other attempts (irrelevant when using Tumor_Intensity_FINAL_BothFluorImages)

501B im2.I_c.jpg can be used as an example image for testing out the program

Measure_Tumor_Intensity:
This function takes an image, allows the user to trace tumor in image, and then produces a graph showing the intensities along the tumor margin, in the tumor, and outside the tumor margin ("normal" tissue) in addition to finding the mean intensities of each 
Works Cited:
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
% All rights reserved.
further licensing info (conditions/disclaimer) included in function, along with the getborder function.

Tumor_Intensity_Graph_and_Means:
This script runs the Measure_Tumor_Intensity function 

intensity_along_line:
  first pass at comparing the intensities of two images along a line: "intensity_along_line"
  This code was adapted from:
  Image Analyst (2014) "How to get INTENSITY along a spcific curve?" 
  <http://www.mathworks.com/matlabcentral/answers/112348-how-to-get-intensity-along-a-spcific-curve>
  #NOTE: the lengths/positions of the lines measuring intensity can be changed, but they should both be approximately the same length for best graph results
  Currently, this code accepts and measures two images, but that could easily be adjusted to accommodate more/fewer images. 
