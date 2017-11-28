fid = fopen('all.txt');

tline = fgetl(fid);
i=1;
% train_num=3446;

while ischar(tline)
%     disp(tline(12:13));
    img=OCR_feature(tline);
   
    i=i+1;
    name1=num2str(i);
    name= strcat(name1,'.png');
    imwrite(img,name);
    tline = fgetl(fid);
end

fclose(fid);
