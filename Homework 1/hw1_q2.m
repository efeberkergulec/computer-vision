%--------------------------------------------%
% CMPE 465                                   %
% Author: Efe Berk ERGULEC                   %
% Homework: 0                                %
% Question: 2                                %
% Description: High-pass and low-pass filter %
% implementation to images and creating new  %
% image that contains both of them.          %
%--------------------------------------------%

%% QUESTION 2: HYBRID IMAGES

disp('--------------------------------');
disp('QUESTION 2:');
im1 = imread('cat.bmp');
im2 = imread('dog.bmp');
disp('--> Image implementation complete.');

% High filter and low filter implementation.
high_filter = fspecial('gaussian', [100 100], 20);
low_filter = fspecial('gaussian', [20 20], 20);
disp('--> Filter generation complete.');

% High and low filtered images.
hf = im1 - imfilter(im1,high_filter,'same');
lf = imfilter(im2,low_filter,'same');

% Filtered image
filtered_image = hf + lf;
filtered_image = imresize(filtered_image, 2);
imshow(filtered_image);
disp('--> Image display complete.');

% This loop generated in order to see images at different sizes.
% for i = 1:5
%     figure(i);
%     imshow(filtered_image);
%     
%     imwrite(filtered_image,sprintf('q2a%d.jpg',i));
%     filtered_image = imresize(filtered_image, 0.5);
% end
disp('--------------------------------');