function [image_out] = catImage(image1,image2)
%拼接两幅不同大小的图像
% 
[r1,c1,d1] = size(image1);
[r2,c2,d2] = size(image2);

white = ones(r1,20,d1).*255;

image1 = cat(2,image1,white);

rmax = max(r1,r2);
if r1 < rmax
    imgtmp = zeros(rmax,c1,d1);
    imgtmp(1:r1,1:c1,1:d1)=image1;
    Ia=imgtmp;
else
   Ia=image1;  
end

if r2 < rmax
   imgtmp=zeros(rmax,c2,d2);
   imgtmp(1:r2,1:c2,1:d2)=image2;
   Ib=imgtmp; 
else
    Ib=image2;
end
image_out=cat(2,Ia,Ib);
end

