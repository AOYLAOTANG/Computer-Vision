% num = match(image1, image2)
%
% This function reads two images, finds their SIFT features, and
%   displays lines connecting the matched keypoints.  A match is accepted
%   only if its distance is less than distRatio times the distance to the
%   second closest match.
% It returns the number of matches displayed.
%
% Example: match('scene.pgm','book.pgm');

function num = ransac(image1, image2)

% Find SIFT keypoints for each image
[im1, des1, loc1] = sift(image1);
[im2, des2, loc2] = sift(image2);

% For efficiency in Matlab, it is cheaper to compute dot products between
%  unit vectors rather than Euclidean distances.  Note that the ratio of 
%  angles (acos of dot products of unit vectors) is a close approximation
%  to the ratio of Euclidean distances for small angles.
%
% distRatio: Only keep matches in which the ratio of vector angles from the
%   nearest to second nearest neighbor is less than distRatio.
distRatio = 0.6;   

% For each descriptor in the first image, select its match to second image.
des2t = des2';                          % Precompute matrix transpose
for i = 1 : size(des1,1)
   dotprods = des1(i,:) * des2t;        % Computes vector of dot products
   [vals,indx] = sort(acos(dotprods));  % Take inverse cosine and sort results

   % Check if nearest neighbor has angle less than distRatio times 2nd.
   if (vals(1) < distRatio * vals(2))
      match(i) = indx(1);
   else
      match(i) = 0;
   end
end

j=1;
for i = 1: size(des1,1)
  if (match(i) > 0)
      matchedPoints1(j,1)=loc1(i,1);
      matchedPoints1(j,2)=loc1(i,2);
      matchedPoints2(j,1)=loc2(match(i),1);
      matchedPoints2(j,2)=loc2(match(i),2);
      j=j+1;
  end
end

%[F,inliersIndex] = estimateFundamentalMatrix(matchedPoints1,matchedPoints2);
[F,inliersIndex] = CalF(matchedPoints1,matchedPoints2);

% Create a new image showing the two images side by side.
im3 = appendimages(im1,im2);

% Show a figure with lines joining the accepted matches.
figure('Position', [100 0 size(im3,2) size(im3,1)*2]);
subplot(2,1,1);
colormap('gray');
imagesc(im3);
hold on;
num = sum(match > 0);
cols1 = size(im1,2);
for i = 1: num
   line([matchedPoints1(i,2),matchedPoints2(i,2)+cols1],[matchedPoints1(i,1),matchedPoints2(i,1)], 'Color','g');
end
hold on;


subplot(2,1,2);
colormap('gray');
imagesc(im3);
hold on;
for i = 1: num
    if(inliersIndex(i)>0)
      line([matchedPoints1(i,2),matchedPoints2(i,2)+cols1],[matchedPoints1(i,1),matchedPoints2(i,1)], 'Color','g');
    end
end
hold off;
fprintf('Found %d matches.\n', num);
truenum=sum(inliersIndex>0);
fprintf('After ransac found %d matches.\n', truenum);




