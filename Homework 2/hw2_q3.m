%---------------------------------------%
% CMPE 465                              %
% Author: Efe Berk ERGULEC              %
% Homework: 2                           %
% Question: 3                           %
% Description: Computes the homography  %
% between images using RANSAC.          %
%---------------------------------------%

I1 = imread('Rainier1.png');
I2 = imread('Rainier2.png');

I1 = rgb2gray(I1);
I2 = rgb2gray(I2);

[p1, np1] = HarrisCornerDetector('Rainier1.png',0.5,0.1);
[p2, np2] = HarrisCornerDetector('Rainier2.png',0.5,0.1);

[features1,valid_points1] = extractFeatures(I1,p1);
[features2,valid_points2] = extractFeatures(I2,p2);

indexPairs = matchFeatures(features1,features2);

matchedPoints1 = valid_points1(indexPairs(:,1),:);
matchedPoints2 = valid_points2(indexPairs(:,2),:);
matchedPoints = [matchedPoints1 matchedPoints2];
numMatchedPoints = length(matchedPoints);

[h, hInv] = RANSAC(matchedPoints,numMatchedPoints,200,5);
matchedPoints1 = matchedPoints(:,1:2);
matchedPoints2 = matchedPoints(:,3:4);
showMatchedFeatures(I1,I2,matchedPoints1,matchedPoints2);

function [hom, homInv]= RANSAC(matches, numMatches, iterations, inlierThreshold)
    ha = eye(3);
    for i = 1:iterations
        x = randsample(numMatches, 4);
        arrL = [matches(x(1),1),matches(x(1),2);
                matches(x(2),1),matches(x(2),2);
                matches(x(3),1),matches(x(3),2);
                matches(x(4),1),matches(x(4),2)];
        arrR = [matches(x(1),3),matches(x(1),4);
                matches(x(2),3),matches(x(2),4);
                matches(x(3),3),matches(x(3),4);
                matches(x(4),3),matches(x(4),4)];
        h = findHomography(arrL, arrR);
        inlierNum = ComputeInlierCount(h, matches, numMatches, inlierThreshold);
        if inlierNum > inlierThreshold
           ha = h;
           inlierThreshold = inlierNum;
        end
    end
    hom = ha;   
    homInv = inv(hom);
end

function inlierNum = ComputeInlierCount(h, matches, numMatches, inlierThreshold)
    rndNums = randsample(numMatches, 4);
    r1 = rndNums(1);
    r2 = rndNums(2);
    r3 = rndNums(3);
    r4 = rndNums(4);
    x1 = matches(r1,1);
    y1 = matches(r1,2);
    x2 = matches(r2,1);
    y2 = matches(r2,2);
    arrL = [matches(r1,1),matches(r1,2);
            matches(r2,1),matches(r2,2);
            matches(r3,1),matches(r3,2);
            matches(r4,1),matches(r4,2)];
    arrR = [matches(r1,3),matches(r1,4);
            matches(r2,3),matches(r2,4);
            matches(r3,3),matches(r3,4);
            matches(r4,3),matches(r4,4)];
    
    for i = 1:length(arrL)
        [arrL(i,1),arrL(i,2)] = Project(arrL(i,1),arrL(i,2),h);
    end
    for i = 1:length(arrR)
        [arrR(i,1),arrR(i,2)] = Project(arrR(i,1),arrR(i,2),h);
    end
    
    vars = polyfit([x1, x2], [y1, y2], 1); 
    s1 = vars(1);   % Slope
    s0 = vars(2);   % Constant
    
    rep_s1 =  -1 / s1;
    deg = atan(rep_s1) * (180 / pi);
    dd = inlierThreshold * cos(deg);
    inc = sqrt(inlierThreshold^2 + dd^2);
    
%     disp(deg);
%     plot(1:5,s);
%     hold on;
%     plot(1:5,s+inc,'r');
%     plot(1:5,s-inc,'k');
%     hold off;
    
    incNum = 0;
    yc = 0;
    for i = 1:length(matches)
       yi = (s0 + (s1 * matches(i,1)));
       yu = yi + inc;
       yd = yi - inc;
       yc = matches(i,2);
       if(yc <= yu && yc >= yd)
           incNum = incNum + 1;
       end
    end
    inlierNum = incNum;
end

function [x2, y2] = Project(x1, y1, h)
    res = h * [x1;y1;1];
    res = res';
    x2 = res(1);
    y2 = res(2);
end

% p1 and p2: n-by-2 matrices that keeps n different values as x and y
function [h] = findHomography(p1,p2)
    A = []; % First matrix that keeps values (2n-by-9)
    for i = 1:length(p1)
        xi = p1(i,1);
        yi = p1(i,2);
        xj = p2(i,1);
        yj = p2(i,2); 
        t = [xi yi 1 0 0 0 (-xj * xi) (-xj * yi) (-xj);0 0 0 xi yi 1 (-yj * xi) (-yj * yi) (-yj)];
        A = [A;t];
    end
    h = A' * A;
    h = eig(h);
    h = reshape(h, 3, 3);
    h = h';
end