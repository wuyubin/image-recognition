


I=imread('20.jpg');
% i1=rgb2gray(I);%i1�Ҷ�ͼ��
% i2=im2bw(i1);% i2�Ƕ�ֵͼ�񣬲���Ҫ����ֵ

bw = ~I;
% imshow(I);
name= strcat('2','.jpg');
imwrite(bw,name);


% figure,imshow(bw);