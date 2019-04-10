clear;
clc;

path = './foreman.yuv';
yuvx=352;
yuvy=288;

anchor_frame = loadFileYuv(path,yuvx,yuvy,1);
target_frame = loadFileYuv(path,yuvx,yuvy,3);
anchor_frame = rgb2gray(anchor_frame);
target_frame = rgb2gray(target_frame);

est_frame = zeros(size(target_frame));

frame_width = size(anchor_frame,2);
frame_height = size(anchor_frame,1);

block_x = 16;
block_y = 16;
R_x = 40;
R_y = 40;

block_width = frame_width/block_x;
block_height = frame_height/block_y;

block_target = zeros(block_y,block_x);
block_anchor = zeros(block_y,block_x);

% record the motions 
motion_estimation = zeros(block_height*block_width, 4);

min = 10000000;

% start
count = 1;
for i=1:block_height
    for j=1:block_width
        block_anchor = anchor_frame((i-1)*block_y+1:i*block_y,(j-1)*block_x+1:j*block_x);
        anchor_px = (j-0.5)*block_x+1;
        anchor_py = (i-0.5)*block_y+1;
        % matching in anchor frame
        for ii=(i-1)*block_y+1-R_y:(i-1)*block_y+1+R_y
            for jj=(j-1)*block_x+1-R_x:(j-1)*block_x+1+R_x
                if (ii>=1) && (ii<=(frame_height+1-block_y)) && (jj>=1) && (jj<=frame_width+1-block_x)
                    block_target = target_frame(ii:ii+block_y-1,jj:jj+block_x-1);
                    temp = sum(sum(abs(block_target-block_anchor)));
                    if min > temp
                        min = temp;
                        block_min = block_target;
                        target_px = jj + block_x*0.5;
                        target_py = ii + block_y*0.5;
                    end
                end
            end
        end
        count = count + 1;
        est_frame((i-1)*block_y+1:i*block_y,(j-1)*block_x+1:j*block_x)=block_min;
        motion_estimation(count,:) = [anchor_px, anchor_py, target_px-anchor_px,target_py-anchor_py];
        min=10000000;
    end
end
subplot(2,2,1);
imshow(anchor_frame);
title('Anchor Frame');
subplot(2,2,2);
imshow(target_frame);
title('Target Frame');
subplot(2,2,3);
imshow(est_frame);
title('Estimation Frame');
subplot(2,2,4);
hold on;
imshow(target_frame);
hold off;
hold on;
quiver(motion_estimation(:,1),motion_estimation(:,2),motion_estimation(:,3),motion_estimation(:,4));
hold off;
title('Motion Estimation');