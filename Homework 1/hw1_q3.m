%------------------------------------------%
% CMPE 465                                 %
% Author: Efe Berk ERGULEC                 %
% Homework: 0                              %
% Question: 3                              %
% Description: Image blending with pyramid %
% blending pipeline.                       %
%------------------------------------------%

%% QUESTION 3: IMAGE BLENDING

% Implementation of images
image1 = imread('aa.jpeg');
image1 = imresize(image1,[512 512]);
image2 = imread('hand.jpg');
image1 = rgb2gray(image1);
image2 = rgb2gray(image2);

% Mask creation
imshow(image1);
e = imellipse;
mask = createMask(e);
mask = double(mask);
imshow(mask);

% Gaussian Pyramid
gp1 = gaussPyramid(image1);
gp2 = gaussPyramid(image2);
gpm = gaussPyramid(mask);
disp('--> Gaussian Pyramids generation complete.');

% Laplacian Pyramid
lp1 = laplPyramid(gp1);
lp2 = laplPyramid(gp2);
disp('--> Laplacian Pyramids generation complete.'); 

% Merging images and collapse
finalim = merge_images(lp1, lp2, gpm);
coll = collapse(finalim);
disp('--> Merging images and collapse complete.'); 

imgs = [image1 image2 coll];

imshow(imgs);
disp('--> Image display complete.');
% imwrite(imgs,'output.jpg');

% Gaussian Pyramid
function [gp] = gaussPyramid(image)
    gp = {image};
    for i = 1:4
        filt = fspecial('gaussian',20,3);
        im = imfilter(image,filt,'same');   % blur
        image = imresize(im,0.5);           % subsample
        gp = {gp{1:i},image};
    end
end

% Laplacian Pyramid
function [lp] = laplPyramid(image)
    lp = {image{length(image)}};
    for i = length(image) - 1:-1:1
        im = imresize(image{i + 1}, 2);
        lap = image{i} - im;
        lp = {lp{1:length(image) - i}, lap};
    end
end

% Collapse function
function [c] = collapse(image)
    im = image{length(image)};
    for i=length(image) - 1:-1:1
       im = imresize(im,2);
       im = im + image{i};
    end
    c = im;
end

% Merge images
function [merged] = merge_images(lapl1, lapl2, mask)
    merged = {};
    for i = length(lapl1):-1:1
        [c,r] = size(lapl1{i});
        ll = zeros(c,r);
        l1 = lapl1{i};
        l2 = lapl2{i};
        le = (length(mask) - i) + 1;
        ma = mask{le};
        for j = 1:c
           for k = 1:r
               ll(j,k) = (ma(j,k) * l1(j,k)) + ((1 - ma(j,k)) * l2(j,k));
           end
        end
        merged{length(merged) + 1} = ll;
    end
end