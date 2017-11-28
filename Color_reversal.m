


I=imread('20.jpg');
% i1=rgb2gray(I);%i1灰度图像
% i2=im2bw(i1);% i2是二值图像，不需要求阈值

bw = ~I;
% imshow(I);
name= strcat('2','.jpg');
imwrite(bw,name);


% figure,imshow(bw);
