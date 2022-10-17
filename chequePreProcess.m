function readyCheque = chequePreProcess(im)
    
    % Gaussian
    imgauss = imgaussfilt(im, 1.2);
    figure, imshowpair(im, imgauss, "montage");
    title('To remove the noisy pixels which are visible on right side of the image '); 
    
    % Grayscale and Binarize
    imgray = rgb2gray(imgauss);
    imbw = im2bw(imgray);
    figure, imshowpair(imgauss, imbw, "montage");
    title('To make finding the border coordinates of the cheque easily');
          
    % Resizing to Reduce Overall Processing Afterwards
    imcropcheque = imbw;
    imcropcheque = imresize(imcropcheque,[3000,4000]);
    % Resizing to reduce the resources needed for processing as it still
    % maintains the required information clearly even after resizing it
    
    % Bwareaopen - To remove additional Noise after Gaussian  
    imcropcheque = bwareaopen(imcropcheque,20);
    
    % Cropping the Image to just Extract the Cheque
    measurements = regionprops(imcropcheque,'BoundingBox','Area');
    area = cat(1,measurements.Area);
    [~,maxAreaIdx] = max(area);
    margins = round(measurements(maxAreaIdx).BoundingBox);
    
    croppedCheque = imcropcheque(margins(2):margins(2)+margins(4),margins(1):margins(1)+margins(3),:);
    figure, imshow(croppedCheque)
    title('PreProcessed Ready for OCR Cheque');

    readyCheque = croppedCheque;

end

%% MORE PREPROCESSING

% edgeDetected = edge(croppedCheque,'canny');
% figure, imshow(edgeDetected)
% title('Edge Detected using canny method');
% 
% edgeDetected = edge(croppedCheque,'log');
% figure, imshow(edgeDetected)
% title('Edge Detected using LoG method');
% 
% edgeDetected = edge(croppedCheque,'sobel');
% figure, imshow(edgeDetected)
% title('Edge Detected using sobel method');
% 
% [rows,cols]=size(edgeDetected);
% 
% im=imread('49ercheque.jpg');
% im2 = rgb2gray(im);
% 
% gaussian1 = fspecial('Gaussian', 21, 10);
% gaussian2 = fspecial('Gaussian', 21, 13);
% dog = gaussian1 - gaussian2;
% dogFilterImage = conv2(double(im2), dog, 'same');
% 
% figure, imshow(dogFilterImage)
% title('DoG');
% 
% edgeDetected = edge(croppedCheque,'roberts');
% figure, imshow(edgeDetected)
% title('Edge Detected using Roberts method');


%% MSER 

% mserMask = false(size(croppedCheque));
% ind = sub2ind(size(mserMask), mseRegpix(:,2), mseRegpix(:,1));
% mserMask(ind) = true;
% 
% edgemask = edge(croppedCheque,"canny");
% 
% edgeInter = edgemask & mserMask;
% figure, imshowpair(edgemask, edgeInter, 'montage');
% title("MSER");