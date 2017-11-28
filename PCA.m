% img=OCR_feature('Img/Sample058/img058-056.png');
% imshow(img);


fid = fopen('bufen.txt');
row=42;
column=24;
train_data=zeros(64,row*column);%Ԥ�������ݿ��Լ������ݶ�ȡ
tline = fgetl(fid);
i=1;
% train_num=3446;
labelMat=ones(1,64);
while ischar(tline)
%     disp(tline(12:13));
    img=OCR_feature(tline);
    labelMat(1,i)=str2num(tline(12:13));
%     labelMat(1,4)
    img_data=img(1:row*column);%����ȡ������ת��һ��������
    train_data(i,:)=img_data;
    i=i+1;
   
    tline = fgetl(fid);
end
% size(train_data)
% labelMat(1,3410)

%�������ɷݷ��������صĽ��Ϊ
%   COEFF��ÿ��Ϊ��������
%   latent������ֵ�����ɴ�С��˳������
%�����ݵ�ά�ȴ������ݸ���ʱ��ͨ���ں���������Ӳ�����econ�����Լ��ټ���
%princomp�����Ƚ�ÿһ�м�ȥ���о�ֵ
[COEFF,~,latent] = princomp(train_data,'econ');

%�����ά�ȣ�����ֵ������ʹͼ�񱣴����������95%
dimension_left=0;
%matlab��cumsum����ͨ�����ڼ���һ��������е��ۼ�ֵ
cum_percent=cumsum(latent)/sum(latent);%�ۼƹ�����
for i=1:length(cum_percent)
    %ʹͼ�񱣴����������0.95
    if cum_percent(i)>=0.95
        dimension_left=i;
        break;
    end
end
%��ѵ�����ݼ����������󣩽��н�ά������������Ϊ��������
train_data_reduced=train_data*COEFF(:,1:dimension_left);

%��ȡ�������ݼ�
test_data=zeros(20,row*column);%Ԥ�������ݿ��Լ������ݶ�ȡ
word=[ ];
for i=1:20
    name=num2str(i);
    file_name1=strcat(name,'.jpg');
    file_name=strcat('extra/',file_name1);
    %��ȡ�ļ�����������ʽ
    img_data=imread(file_name);
    img_data=img_data(1:row*column);%����ȡ������ת��һ��������
    test_data(i,:)=img_data;%������������ӵ�ѵ������
end
%���������ݼ����н�ά
test_data_reduced=test_data*COEFF(:,1:dimension_left);
result=zeros(1,20);
for i=1:20
    %ͨ�������������׷����ķ�������ŷʽ����
    min=norm(test_data_reduced(i,:)-train_data_reduced(1,:))*norm(test_data_reduced(i,:)-train_data_reduced(1,:));
    %ŷ�Ͼ�����̵��Ǹ�
    position=1;
    for j=2:65
        %norm�����ɼ��㼸�ֲ�ͬ���͵ľ�����,����p�Ĳ�ͬ�ɵõ���ͬ�ķ���
        distance=norm(test_data_reduced(i,:)-train_data_reduced(j,:))*norm(test_data_reduced(i,:)-train_data_reduced(j,:));
        if min>distance
            min=distance;
            %ŷ�Ͼ�����̵��Ǹ�
            position=j;
        end
    end
    
    position;
    labelMat(1,position);
    letter=read_letter(position);
    word=[word letter];
end
word
% size(test_data)

fclose(fid);