I = imread('image4.PPM');
D = imread('depth4.PGM');
output = imread('output4.PPM');

figure(1);

subplot(2,2,3);
imshow(D);

subplot(2,2,1);
imshow(output);


%% Canny

Ddiff = edge(D,'Canny',[0.05 0.2]);
subplot(2,2,2);
imshow(Ddiff);


% Idiff = edge(rgb2gray(I),'Canny',[0.05 0.1]);
% subplot(2,2,3);
% imshow(Idiff);

%% Segmentation
[H W Channel]= size(I);

Seg = csvread('universe.dat');

mask = zeros(H, W);

% Build component index list
index = [];
for y = 1:H
    for x = 1:W
        if sum(index == Seg(y, x)) == 0
            index = [index, Seg(y, x)];
        end
    end
end

for i = 1:length(index)
    BW = Seg == index(i);
    if BW == zeros(H,W)
        continue;
    end
    % boundary check
    [B, L] = bwboundaries(BW,'noholes');
    boundary = B{1};
    edgeCount = 0;
    for k = 1:length(boundary)
        y = boundary(k,1);
        x = boundary(k,2);
        if y <= 5 || x <= 5 || H - y <= 5 || W - x <= 5
            continue;
        end
        neighborRegion = Ddiff(y-5:y+5, x-5:x+5);
        if sum(neighborRegion(:)) > 0
            edgeCount = edgeCount + 1;
        end
    end
    % depth check
    regionDepth = D(BW);
    area = length(regionDepth);
    avgDepth = sum(regionDepth)/length(regionDepth);
    
   if(edgeCount > length(boundary) / 3 && avgDepth < 170)
   % if(edgeCount > length(boundary) / 3)
        mask = mask + BW;
        fprintf('Component:%d; Boundary match count: %d; Average Depth: %f\n', index(i), edgeCount, avgDepth);
    end
end

subplot(2,2,4);
imshow(mask);


% subplot(2,2,3);
% imshow(BW);

%% Show superimposed result

temp = uint8(zeros(H,W,3));
temp(:,:,3) = 255*mask;
blend = imfuse(I, temp, 'blend');
figure(2);imshow(blend);
