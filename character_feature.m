function img_r=OCR_feature(image_path)

warning off %#ok<WNOFF>

% Clear all
% clc, close all

imagen=imread(image_path);
img_r=imagen;

if size(imagen,3)==3 %RGB image
    imagen=rgb2gray(imagen);
end

threshold = graythresh(imagen);
imagen =~im2bw(imagen,threshold);

imagen = bwareaopen(imagen,30);

re=imagen;

while 1
    %Fcn 'lines' separate lines in text
    [fl re]=lines(re);
    imgn=fl;
    
    [L Ne] = bwlabel(imgn);  
%     i = 1 ;
    for n=1:Ne
        [r,c] = find(L==n);
        % Extract letter
        n1=imgn(min(r):max(r),min(c):max(c));  
        % Resize letter (same size of template)
        img_r=imresize(n1,[42 24]);

    end
 
    if isempty(re)  %See variable 're' in Fcn 'lines'
        break
    end    
end

end
