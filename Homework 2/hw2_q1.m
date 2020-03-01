%-------------------------------------------%
% CMPE 465                                  %
% Author: Efe Berk ERGULEC                  %
% Homework: 2                               %
% Question: 1                               %
% Description: Harris corner detector       %
% implementation.                           %
%-------------------------------------------%

img = imread('Boxes.png');
[cornerPts, numCornerPts] = HarrisCornerDetector('Boxes.png', 2, 0.01);

imshow(img, 'Border', 'tight');
hold on;
plot(cornerPts(:,1),cornerPts(:,2),'r.', 'MarkerSize', 8);
savefig('1a.fig');