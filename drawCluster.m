function [] = drawCluster(cluster_1,cluster_2,img1,img2)
%remove mismatches
%

%% ·Ö×é
[matches_size,~] = size(cluster_1);

C1 = {};
C2 = {};

a = cluster_1(1,4);
b = [1];
for i = 1:matches_size
    [~, b_size] = size(b);
    if(cluster_1(i,4) == a)
        continue;
    else
        a = cluster_1(i,4);
        b = [b,i];
    end
end

[~,b_size] = size(b);
for i = 1:b_size-1
    C1{end+1} = cluster_1(b(1,i):b(1,i+1)-1,:);
end
C1{end+1} = cluster_1(b(1,b_size):size(cluster_1,1),:);

a = cluster_2(1,4);
b = [1];
for i = 1:matches_size
    [~, b_size] = size(b);
    if(cluster_2(i,4) == a)
        continue;
    else
        a = cluster_2(i,4);
        b = [b,i];
    end
end

[~,b_size] = size(b);
for i = 1:b_size-1
    C2{end+1} = cluster_2(b(1,i):b(1,i+1)-1,:);
end
C2{end+1} = cluster_2(b(1,b_size):size(cluster_2,1),:);


%% »­Í¼
img_show = catImage(img1,img2);
figure(2) ; clf ;
imshow(img_show) ;
hold on ;

[row1,col1,~] = size(img1);
c=['k';'r';'g';'b';'y';'m';'c';'w';'r';'g';'b';'y';'m';'c';'w';'r';'g';'b';'y';'m';'c';'w'];
for i = 1:size(C1,2)
    points = C1{1,i};
    for j = 1:size(points,1)
        X = points(:,2).*col1;
        Y = points(:,3).*row1;
        scatter(X,Y,20,c(i),'filled');
    end
end

[row,col,~] = size(img2);
for i = 1:size(C2,2)
    points = C2{1,i};
    for j = 1:size(points,1)
        scatter(points(:,2).*col+col1+20,points(:,3).*row,20,c(i),'filled');
    end
end



end

