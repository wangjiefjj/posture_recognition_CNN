function [picture, hog_feature, my_hsg_feature] = get_samples(file_dir, N, R, C, CellSize, BlockSize, NumBins, sR, sC)
    picture = zeros(R, C, N, 'uint8');
%     hog_feature = zeros(floor(R/8) * floor(C/8) * 9, N);
    file_list = dir(file_dir);
    file_list = file_list(3:size(file_list, 1));
    for k=1:N
        img = imread([file_dir, '/', file_list(floor(mod(k, size(file_list, 1)))+1, 1).name]);
        % ת�ɻҶ�ͼ
        img_y = uint8(0.257*img(:, :, 1) + 0.504*img(:, :, 2) + 0.098*img(:, :, 3) + 16);
        % ��ȡ���� ��������������������ʵ������ƫ����
%         up = floor(size(img_y, 1)/2 - R/2) + floor(sR*randn());
%         left = floor(size(img_y, 2)/2 - C/2) + floor(sC*randn());
        up = floor(size(img_y, 1)/2 - R/2) + floor(randi([-sR, sR]));
        left = floor(size(img_y, 2)/2 - C/2) + floor(randi([-sC, sC]));
        % ��Ҫ������ȡλ��
        if up<1
            up = 1;
        elseif up>size(img_y, 1)-R -1
            up = size(img_y, 1)-R -1;
        end
        if left<1
            left = 1;
        elseif left>size(img_y, 2)-C -1
            left = size(img_y, 2)-C -1;
        end
        % ��ȡ
        picture(:, :, k) = img_y(up:up+R-1, left:left+C-1);
        % ����HOG����
        hog_feature(:, k) = extractHOGFeatures(picture(:, :, k), 'CellSize', CellSize, 'BlockSize', BlockSize, 'BlockOverlap', BlockSize-1, 'NumBins', NumBins);
        % �ĳ�HSG
        for t=1:floor(size(hog_feature, 1)/NumBins)
            hog_feature(NumBins*(t-1)+1:NumBins*t, k) = sign(hog_feature(NumBins*(t-1)+1:NumBins*t, k)-sum(hog_feature(NumBins*(t-1)+1:NumBins*t, k))/(2^floor(log2(NumBins))))/2 + 1/2;
        end
        % �Լ���
        my_hsg_feature(:, k) = my_extractHOGFeatures(picture(:, :, k), CellSize, BlockSize, BlockSize-1, NumBins);
    end
end