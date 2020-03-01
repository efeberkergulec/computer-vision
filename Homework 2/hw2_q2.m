%--------------------------------------------%
% CMPE 465                                   %
% Author: Efe Berk ERGULEC                   %
% Homework: 2                                %
% Question: 2                                %
% Description: Describe and match two points %
% in one image.                              %
%--------------------------------------------%

I1 = imread('Rainier1.png');
I2 = imread('Rainier2.png');

I1 = rgb2gray(I1);
I2 = rgb2gray(I2);

[p1, np1] = HarrisCornerDetector('Rainier1.png',2,0.000001);
imshow(I1, 'Border', 'tight');
hold on;
plot(p1(:,1),p1(:,2),'r.', 'MarkerSize', 8);
savefig('2a.fig');
hold off;
[p2, np2] = HarrisCornerDetector('Rainier2.png',2,0.000001);
imshow(I2, 'Border', 'tight');
hold on;
plot(p2(:,1),p2(:,2),'r.', 'MarkerSize', 8);
savefig('2b.fig');
hold off;

[features1,valid_points1] = extractFeatures(I1,p1);
[features2,valid_points2] = extractFeatures(I2,p2);

indexPairs = matchFeatures(features1,features2);

matchedPoints1 = valid_points1(indexPairs(:,1),:);
matchedPoints2 = valid_points2(indexPairs(:,2),:);

showMatchedFeatures(I1,I2,matchedPoints1,matchedPoints2);