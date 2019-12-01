%-------------------------------------------%
% CMPE 465                                  %
% Author: Efe Berk ERGULEC                  %
% Homework: 0                               %
% Question: 1                               %
% Description: In this quesiton, you asked  %
% me to implement noise to a picture.       %
%-------------------------------------------%

%% QUESTION 1: ADD NOISE
disp('---------------------------------------------');
disp('QUESTION 1:');

% a)imread
image = imread('lena.jpg');
disp('--> Image read complete.');

% b)conversion
image_g = rgb2gray(image);
disp('--> Conversion to gray complete.');

% c)generate random noise
image_noise = imnoise(image_g, 'gaussian');
disp('--> Noise generation complete.');

% d)display images
images = [image_g image_noise];
figure('Name', 'Answer of Question 1', 'NumberTitle', 'off');
imshow(images);
title('Without Noise vs. With Noise');
% imwrite(images, 'answer1.png');
savefig('answer1.fig');
disp('--> Display image complete.');
disp('---------------------------------------------');