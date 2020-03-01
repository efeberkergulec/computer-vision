%-------------------------------------------%
% CMPE 465                                  %
% Author: Efe Berk ERGULEC                  %
% Homework: 0                               %
% Question: 1                               %
% Description: Edge detection and gradient  %
% magnitude calculation.                    %
%-------------------------------------------%

%% QUESTION 1: EDGE DETECTION
disp('--------------------------------');
disp('QUESTION 1:');

[Gx,Gy] = sobeledge('lena.jpg');
disp('--> SobelEdge worked.');

Gm = gradient_magnitude(Gx, Gy);
disp('--> Gradient magnitude worked.');

images = [Gx, Gy];
figure(1);
imshow(images,[]);
figure(2);
imshow(Gm);
disp('--> Image display completed.');
disp('--------------------------------');

% Sobel Edge function implementation.
function [Gx,Gy] = sobeledge(image)
    % Sobel operators
    kernel_xv = [1;2;1] / 4;
    kernel_xh = [-1,0,1] / 2;
    kernel_yv = [-1;0;1] / 2;
    kernel_yh = [1,2,1] / 4;
    
    % Image implementation and conversion
    im = imread(image);
    im_g = im2double(rgb2gray(im));
    im_g = [zeros(1,length(im_g) + 2);zeros(length(im_g),1),im_g,zeros(length(im_g),1);zeros(1,length(im_g) + 2)];
    
    % Gx calculation
    gX_ver = vertical_scan(im_g, kernel_xv);
    Gx = horizontal_scan(gX_ver, kernel_xh);
    Gx = Gx(2:length(im_g) - 1,2:length(im_g) - 1);
    
    % Gy calculation
    gY_ver = vertical_scan(im_g, kernel_yv);
    Gy = horizontal_scan(gY_ver, kernel_yh);
    Gy = Gy(2:length(im_g) - 1,2:length(im_g) - 1);
end

% Funciton for vertical scan.
function [ver_mat] = vertical_scan(image, v_mtx)
    v_mtx = v_mtx';
    ver_mat = zeros(length(image));
    for i = 2:length(image) - 1
        for j = 2:length(image) - 1
            ver_mat(i,j) = (v_mtx(1) * image(i-1,j)) + (v_mtx(2) * image(i,j)) + (v_mtx(3) * image(i+1,j));
        end
    end
end

% Funciton for horizontal scan.
function [hor_mat] = horizontal_scan(image, h_mtx)
    hor_mat = zeros(length(image));
    for i = 2:length(image) - 1
        for j = 2:length(image) - 1
            hor_mat(i,j) = (h_mtx(1) * image(i,j-1)) + (h_mtx(2) * image(i,j)) + (h_mtx(3) * image(i,j+1));
        end
    end
end

% Function to calculate gradient magnitude.
function Gm = gradient_magnitude(x, y)
    xx = x.^2;
    yy = y.^2;
    Gm = sqrt(xx + yy);
end
