


fid = fopen('bufen.txt');
row=42;
column=24;
train_data=zeros(64,row*column);%预分配数据可以加速数据读取
tline = fgetl(fid);
i=1;
% train_num=3446;
labelMat=ones(1,64);
while ischar(tline)
%     disp(tline(12:13));
    img=OCR_feature(tline);
    labelMat(1,i)=str2num(tline(12:13));
%     labelMat(1,4)
    img_data=img(1:row*column);%将读取的数据转成一个行向量
    train_data(i,:)=img_data;
    i=i+1;
   
    tline = fgetl(fid);
end
% size(train_data)
% labelMat(1,3410)

%进行主成份分析，返回的结果为
%   COEFF：每列为特征向量
%   latent：特征值，按由大到小的顺序排列
%当数据的维度大于数据个数时，通过在函数后面添加参数‘econ’可以加速计算
%princomp会首先将每一列减去该列均值
[COEFF,~,latent] = princomp(train_data,'econ');

%保存的维度（特征值）个数使图像保存的能量大于95%
dimension_left=0;
%matlab中cumsum函数通常用于计算一个数组各行的累加值
cum_percent=cumsum(latent)/sum(latent);%累计贡献率
for i=1:length(cum_percent)
    %使图像保存的能量大于0.95
    if cum_percent(i)>=0.95
        dimension_left=i;
        break;
    end
end
%将训练数据集（整个矩阵）进行降维。特征向量都为行向量？
train_data_reduced=train_data*COEFF(:,1:dimension_left);

%读取测试数据集
test_data=zeros(20,row*column);%预分配数据可以加速数据读取
word=[ ];
for i=1:20
    name=num2str(i);
    file_name1=strcat(name,'.jpg');
    file_name=strcat('extra/',file_name1);
    %读取文件（）矩阵形式
    img_data=imread(file_name);
    img_data=img_data(1:row*column);%将读取的数据转成一个行向量
    test_data(i,:)=img_data;%将该行向量添加到训练集中
end
%将测试数据集进行降维
test_data_reduced=test_data*COEFF(:,1:dimension_left);
result=zeros(1,20);
for i=1:20
    %通过计算向量二阶范数的方法计算欧式距离
    min=norm(test_data_reduced(i,:)-train_data_reduced(1,:))*norm(test_data_reduced(i,:)-train_data_reduced(1,:));
    %欧氏距离最短的那个
    position=1;
    for j=2:65
        %norm函数可计算几种不同类型的矩阵范数,根据p的不同可得到不同的范数
        distance=norm(test_data_reduced(i,:)-train_data_reduced(j,:))*norm(test_data_reduced(i,:)-train_data_reduced(j,:));
        if min>distance
            min=distance;
            %欧氏距离最短的那个
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
