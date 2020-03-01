%-------------------------------------------%
% CMPE 465                                  %
% Author: Efe Berk ERGULEC                  %
% Homework: 3                               %
% Question: 1                               %
% Description: Image stitch implementation. %
%-------------------------------------------%

I1 = imread('Rainier1.png');
I2 = imread('Rainier2.png');
% I1 = imread('Hanging1.png');
% I2 = imread('Hanging2.png');
% I1 = imread('ND1.png');
% I2 = imread('ND2.png');

hom = load('H_Rainier.mat');
% hom = load('H_Hanging.mat');
% hom = load('H_ND.mat');

hom = struct2cell(hom);
hom = hom{1,1};
homInv = inv(hom);
stitchedImage = Stitch(I1, I2, homInv);

imshow(stitchedImage,'Border','tight');
% imwrite(stitchedImage,'Rainier_output.png');

%% Stitch
% INPUTS
% image1: First image.
% image2: Second image.
% homInv: Inverse of homography function.
% OUTPUTS
% stitchedImage: Stitched image.
function [stitchedImage]= Stitch(image1, image2, homInv)
    [im2_y, im2_x, d]=size(image2);

    [x1,y1]=Project(0,0,homInv);
    [x2,y2]=Project(im2_x,0,homInv);
    [x3,y3]=Project(0,im2_y,homInv);
    [x4,b4]=Project(im2_x,im2_y,homInv);

    projectionPoints = [x1 y1;x2 y2;x3 y3;x4 b4];       % Projected Points
    image2_borders = [0 0;im2_x,0;0,im2_y;im2_x,im2_y]; % Original Points

    X=[x1,x2,x3,x4];
    Y=[y1,y2,y3,b4];

    borders=round(abs([max(Y) max(X)]));
    % Creates transformation and warps image with geometric transformation.
    transformation = fitgeotrans(image2_borders,projectionPoints,'projective');
    transformed_image = imwarp(image2,transformation,'OutputView',imref2d(borders));

    [x,y,d] = size(image1);
    
    % Puts first image to second image.
    for i = 1:x
        for j = 1:y
            transformed_image(i,j,:) = image1(i,j,:);
        end
    end
    
    stitchedImage = transformed_image;
end

function [x2, y2] = Project(x1, y1, h)
    res = h*[x1;y1;1];
    x2 = res(1) / res(3);
    y2 = res(2) / res(3);
end
