function [CorrectIndex] = mvWrongIndex(Image_1,Image_2,P1,P2,th_length,th_angle)
% Manually marked groundtruth
%  

global CorrectIndex_g;
CorrectIndex_g = (1:size(P1,2));

%% 位移幅度和角度阈值
w_sum = 0;
theta_sum = 0;
for i = 1:size(P1,2)
    w = sqrt((P1(1,i)-P2(1,i)^2 + (P1(2,i)-P2(2,i))^2));
    w_sum = w_sum+w;
    
    theta = (P2(2,i)-P1(2,i))/(P2(1,i)-P1(1,i));
    theta_sum = theta_sum + theta;
end

w_med = w_sum/size(P1,2);
theta_med = theta_sum/size(P1,2);

for i = 1:size(P1,2)
    if(abs(sqrt((P1(1,i)-P2(1,i)^2 + (P1(2,i)-P2(2,i))^2)) - w_med)/size(Image_1,1) > w_med*th_length || abs((P2(2,i)-P1(2,i))/(P2(1,i)-P1(1,i)) -  theta_med) > abs(theta_med)*th_angle)
        CorrectIndex_g(CorrectIndex_g == i) = [];
    end
end



%% 人工去除
figure('DockControls', 'on'); 
image_show = catImage(Image_1,Image_2);
imshow(image_show) ;
hold on;
for i=1:size(CorrectIndex_g,2)
    line([P1(1,CorrectIndex_g(i));P2(1,CorrectIndex_g(i)) + size(Image_1,2)+20],[P1(2,CorrectIndex_g(i));P2(2,CorrectIndex_g(i))],'color','b','Tag',int2str(CorrectIndex_g(i)),'ButtonDownFcn',@lineCallback);
end
hold off;

uiwait;

% global Flag;
% Flag = 1;
% 
% while Flag == 1
%     print("loading");
% end

CorrectIndex = CorrectIndex_g;
end

