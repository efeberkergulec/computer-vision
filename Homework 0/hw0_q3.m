%-------------------------------------------%
% CMPE 465                                  %
% Author: Efe Berk ERGULEC                  %
% Homework: 0                               %
% Question: 3                               %
% Description: Filter implementation to     % 
% observe how filters affect an image.      %
%-------------------------------------------%

%% QUESTION 3: FILTERS
disp('---------------------------------------------');
disp('QUESTION 3:');

% First two steps has taken from question 1.
image = imread('lena.jpg');
disp('--> Image read complete.');

image_g = rgb2gray(image);
disp('--> Conversion to gray complete.');

% Filter function implementations
H1 = [0,0,0;0,1,0;0,0,0];
H2 = [0,0,0;0,2,0;0,0,0];
H3 = [0,0,0;1,0,0;0,0,0];
H4 = [0,0,0;0,0,1;0,0,0];
H5 = [1,1,1;1,1,1;1,1,1];
disp('--> Filter function implementations complete.');

G1 = imfilter(image_g,H1,'conv');
G2 = imfilter(image_g,H2,'conv');
G3 = imfilter(image_g,H3,'conv');
G4 = imfilter(image_g,H4,'conv');
G5 = imfilter(image_g,H2-(H5/9),'conv');
disp('--> Image filter complete.');

filtered_images = [image_g,G1,G2;G3,G4,G5];


figure('Name', 'Answer of Question 3', 'NumberTitle', 'off');
imshow(filtered_images);
% imwrite(filtered_images, 'answer3.png');
title('Original Photo, G1, G2, G3, G4, G5');
savefig('answer3.fig');
disp('--> Plotting images complete.');
disp('---------------------------------------------');