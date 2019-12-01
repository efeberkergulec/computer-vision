%-------------------------------------------%
% CMPE 465                                  %
% Author: Efe Berk ERGULEC                  %
% Homework: 0                               %
% Question: 2                               %
% Description: Remove noise at the image    %
% using gaussian filter implementation.     %
%-------------------------------------------%

%% QUESTION 2: REMOVE NOISE
disp('---------------------------------------------');
disp('QUESTION 2:');

% First three steps has taken from question 1.
image = imread('lena.jpg');
disp('--> Image read complete.');

image_g = rgb2gray(image);
disp('--> Conversion to gray complete.');

image_noise = imnoise(image_g, 'gaussian');
disp('--> Noise generation complete.');

% For the sake of efficiency, I decided to make my experimtents with
% multiple variables and wrote a code that can try all permutations. If you
% want to see other options and/or manipulate variables, this helps you to
% make it in simplest way.
sigma = [0.1, 0.3, 0.5, 1, 2];
filter_size = [3, 5, 7, 100];

% Sigma and filter array sizes. Will be useful in for loops.
s_size = size(sigma);
ss = s_size(2);
f_size = size(filter_size);
fs = f_size(2);

% This array is implemented to store filters.
image_array = zeros(ss, fs, 256, 256);
disp('--> Array generation complete.');

% Filtering implementation.
for i = 1:ss
    for j = 1:fs
        filter = fspecial('gaussian',[j j], i);
        image_array(i,j,:,:) = imfilter(image_noise, filter, 'replicate');
    end
end
disp('--> Filtering implementation complete.');

% This step includes outputs like plots, write image to the directory and
% a conversion operation. Image writing line is under comment due to
% unnecessary operations. Lastly, figure that will exist at the end of this
% loop needs to be expand to see output.
z = 1;
figure('Name', 'Answer of Question 2 (need to expand this window)', 'NumberTitle', 'off');
for i = 1:ss
    for j = 1:fs
        subplot(ss, fs, z);
        temp = image_array(i,j,:,:);
        img = uint8(squeeze(temp));
        imshow(img);
        title(sprintf('%.1f sigma; %d filter size',round(sigma(i),1),filter_size(j)));
%         imwrite(img,sprintf('%d.jpg',z));
        z = z + 1;
    end
end
savefig('answer2.fig');
disp('--> Plotting images complete.');
disp('---------------------------------------------');