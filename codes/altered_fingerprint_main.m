%{
Paper source: Altered Fingerprint Analysis_jain,feng,woon

Implementation: Mohammad Minhazul Haq
%}


%clear all variables
clear all;
close all;


fileName = 'test data set 1/a4';


%read fingerprint image
grayScaleImage = mat2gray(imread(strcat(fileName,'.bmp')));
grayScaleImage = grayScaleImage * 255;


%caluclate & show estimated orientation field
blockSize = 8;
estimatedOrientationAngle = orientation_field_estimation( grayScaleImage, blockSize );
%figure;
%show_orientation_field(estimatedOrientationAngle, blockSize, 1);
%title('Estimated Orientation field');


% calculate & show approximate orientation field using least square method
approximatedOrientationAngle = least_square_regression(estimatedOrientationAngle, blockSize);
%figure;
%show_orientation_field(approximatedOrientationAngle, blockSize, 1);
%title('Approximated Orientation field');


% calculate & show error map
errorMapMatrix = error_map( estimatedOrientationAngle, approximatedOrientationAngle, blockSize ); 
resizedErrorMapMatrix = errorMapMatrix( [1:60] , [3:62] );
   

%calculate & show minutiae density map
densityMapMatrix = minutiae_density_map( fileName ); 


% 1X189 feature vector from errorMap and densityMap
combinedFeatureVector = histogram_feature( resizedErrorMapMatrix, densityMapMatrix );


%test using livsvm
test_label = [1]; %altered
test_data = combinedFeatureVector;
predicted_label = test_altered_natural( test_label, test_data );


if predicted_label(1,1)==1 %altered        
    probableAlteredArea = altered_area_detection( fileName, errorMapMatrix, densityMapMatrix );
    showMinutiae(fileName, probableAlteredArea);
    disp('--> Altered fingerprint');
    baselineMatching(fileName,probableAlteredArea);
else %natural
    disp('--> Natural fingerprint');
    baselineMatching(fileName,0);    
end

