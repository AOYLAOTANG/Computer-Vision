%% Use the Least Median of Squares Method to Find Inliers
%
%% 
% Load the putatively matched points.
load stereoPointPairs
[fLMedS, inliers] = estimateFundamentalMatrix(matchedPoints1,matchedPoints2,'NumTrials',2000)
%%
% Load the stereo images.
I1 = imread('cxk1.jpg');
I2 = imread('cxk2.jpg');
%%
% Show the putatively matched points.
figure;
showMatchedFeatures(I1,I2,matchedPoints1,matchedPoints2,'montage','PlotOptions',{'ro','go','y--'});
title('Putative point matches');
%%
% Show the inlier points.
figure;
showMatchedFeatures(I1, I2, matchedPoints1(inliers,:),matchedPoints2(inliers,:),'montage','PlotOptions',{'ro','go','y--'});
title('Point matches after outliers were removed');