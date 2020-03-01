%-------------------------------------------%
% CMPE 465                                  %
% Author: Efe Berk ERGULEC                  %
% Homework: 3                               %
% Question: 2                               %
% Description: Mean shifting algorithm      %
% implementation.                           %
%-------------------------------------------%

I = imread('atakule.jpg');
bandWidth = 0.4;
stopT = 0.05;

[labels,peaks] = segmentMS(I,bandWidth,stopT);

imshow(labels, 'Border', 'tight');
% imwrite(labels,'5st.png');

%% Segment MS (Mean Shift Segmentation)
% INPUTS
% image: Input image (n x d matrix).
% bandwidth: Associated peak.
% stopT: Stops loop by controlling shift amount.
% OUTPUTS
% labels: Output image.
% peaks: Cluster points.
function [labels,peaks] = segmentMS(image,bandWidth,stopThresh)
    labels = image;     % This will be output image
    image = im2double(image);
    image = reshape(image,size(image,1)*size(image,2),3); 
    tempImg = image;    % Matrix that will use for writing output
    image = image';

    % Variable initialization
    [numDim,numPts] = size(image);
    numClust = 0;
    bandWidth = bandWidth^2;
    indexes = 1:numPts;
    centroids = [];
    seenArr = zeros(1,numPts,'uint8');
    remPts = numPts;
    clusterVotes = zeros(1,numPts,'uint16');
    while remPts
        tempInd = ceil( (remPts-1e-6)*rand);
        stInd = indexes(tempInd);
        cur_mean = image(:,stInd);
        members = [];                         
        tempSeenArr = zeros(1,numPts,'uint16');
        while 1
            distance = sum((repmat(cur_mean,1,numPts) - image).^2);
            inInds = find(distance < bandWidth);
            tempSeenArr(inInds) = tempSeenArr(inInds)+1;
            old_mean = cur_mean;
            cur_mean = mean(image(:,inInds),2);
            members = [members inInds];
            seenArr(members) = 1;
            
            if norm(cur_mean-old_mean) < stopThresh
                mergeWith = 0;
                if mergeWith > 0    
                    clusterVotes(mergeWith,:) = clusterVotes(mergeWith,:) + tempSeenArr;
                else    
                    numClust = numClust+1;
                    centroids(:,numClust) = cur_mean;
                    clusterVotes(numClust,:) = tempSeenArr;
                end
                break;
            end
        end
        indexes=find(seenArr == 0);
        remPts=length(indexes);
    end
    [val,data] = max(clusterVotes,[],1);
    
    peaks = cell(numClust,1);
    for i = 1:numClust
        members = find(data == i);
        peaks{i} = members;
    end
    
    for i = 1:length(peaks)
        tempImg(peaks{i},:) = repmat(centroids(:,i)',size(peaks{i},2),1); 
    end
    labels = reshape(tempImg,size(labels,1),size(labels,2),3);
end