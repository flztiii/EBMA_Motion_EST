% function mov = loadFileYuv(fileName, width, height, idxFrame) 
 
function imgRgb = loadFileYuv(fileName, width, height, idxFrame) 
% load RGB movie [0, 255] from YUV 4:2:0 file 
 
fileId = fopen(fileName, 'r'); 
 
subSampleMat = [1, 1; 1, 1]; 
 
% search fileId position 
sizeFrame = 1.5 * width * height; 
fseek(fileId, (idxFrame - 1) * sizeFrame, 'bof'); 

% read Y component 
buf = fread(fileId, width * height, 'uchar'); 
imgYuv(:, :, 1) = reshape(buf, width, height).'; % reshape 

% read U component 
buf = fread(fileId, width / 2 * height / 2, 'uchar'); 
imgYuv(:, :, 2) = kron(reshape(buf, width / 2, height / 2).', subSampleMat); % reshape and upsample 

% read V component 
buf = fread(fileId, width / 2 * height / 2, 'uchar'); 
imgYuv(:, :, 3) = kron(reshape(buf, width / 2, height / 2).', subSampleMat); % reshape and upsample 

Y = imgYuv(:, :, 1);
U = imgYuv(:, :, 2);
V = imgYuv(:, :, 3);

imgRgb = zeros(size(imgYuv));
imgRgb(:,:,1) = Y + (360 * (V - 127)/255);
imgRgb(:,:,2) = Y - (( ( 88 * (U - 127)  + 184 * (V - 127)) )/255) ;
imgRgb(:,:,3) = Y +((455 * (U - 127))/255);
imgRgb = imgRgb/255;
% normalize YUV values 
% imgYuv = imgYuv / 255; 

% convert YUV to RGB 
% imgRgb = ycbcr2rgb(imgYuv); 
%imwrite(imgRgb,'ActualBackground.bmp','bmp'); 
% 	mov(f).cdata = uint8(imgRgb); 
% 	mov(f).colormap =  []; 
%     imwrite(imgRgb,'ActualBackground.bmp','bmp'); 

%figure, imshow(imgRgb); 
%name = 'ActualBackground.bmp'; 
%Image = imread(name, 'bmp'); 
%figure, imshow(Image); 
fclose(fileId);
end 


 