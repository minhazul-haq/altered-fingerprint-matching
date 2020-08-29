

file1 = '102_6';

%read fingerprint image
grayScaleImage1 = mat2gray(imread(strcat('test data/',file1,'.bmp')));


file2 = '102_7_scar';

%read fingerprint image
grayScaleImage2 = mat2gray(imread(strcat('test data/',file2,'.bmp')));

sub = grayScaleImage2 - grayScaleImage1;
imshow(sub);

