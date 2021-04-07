function [sift_matches, P1, P2] = getMatch(image_1,image_2)
%get putative matches
%   
[~,~,z1] = size(image_1);
[~,~,z2] = size(image_2);

if(z1 == 3 && z2 == 3)
    I1 = single(rgb2gray(image_1));
    I2 = single(rgb2gray(image_2));
end

if(z1 == 1 && z2 == 1)
    I1 = single(image_1);
    I2 = single(image_2);
end


[f1,d1] = vl_sift(I1);
[f2,d2] = vl_sift(I2);

[matches, scores] = vl_ubcmatch(d1, d2, 1.4);

[drop, perm] = sort(scores, 'descend');
matches = matches(:, perm);
scores = scores(perm);
sift_matches = matches;
P1 = f1(1:2,matches(1,:));
P2 = f2(1:2,matches(2,:));




end

