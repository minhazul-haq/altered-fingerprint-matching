

%function for generating altered area detection matrix
function intersectedMatrix = altered_area_detection( fileName, errorMap, densityMapMatrix )

    maxVal = max( errorMap(:) );

    binarizedMatrix = im2bw( errorMap, 0.6*maxVal );    

    %figure;
    %title('Shrink matrix');
    
    %hold on;
    A = double( ones(8,8) );
    zoomedMatrix = kron( binarizedMatrix, A );
    shrinkMatrix = bwmorph( zoomedMatrix,'shrink',Inf );
    %imshow(shrinkMatrix);
    %xlim([1,512]);
    %ylim([1,480]);
    %hold off;
   
    
    [r c] = find(shrinkMatrix);
    hullIndices =  convhull( r,c );
    
    %hold on;
    %plot(c(hullIndices),r(hullIndices));
    %hold off;
    
    zer = zeros(480,512);
    matrixB = roipoly( zer, c(hullIndices),r(hullIndices));
    
    %hold on;
    %imshow(matrixB);
    %hold off;


    
    
    
    %five circles
    densityMap = imrotate(densityMapMatrix,90);
    %figure;
    %xlim([1,512]);
    %ylim([1,480]);
    matrixA =zer;
    
    for loop=1:5
        %altered area detection
        [maxVal index] = max(densityMap(:));
        [MAXi MAXj] = ind2sub( size(densityMap),index );

        %hold on;
        [xp yp] = draw_circle(MAXj,MAXi,60);
        matrixC = roipoly( zer, xp, yp );
        %hold off;

        for ii=1:size(densityMap,1)
            for jj=1:size(densityMap,2)
                if (densityMap(ii,jj)==maxVal)
                    densityMap(ii,jj)=0;
                end
            end
        end
        
        matrixA = matrixA | matrixC;
        loop = loop + 1;
    end
    
    %hold on;
    %imshow(matrixA);
    %hold off;
    
    intersectedMatrix = matrixA & matrixB;
    %figure;
    %xlim([1,512]);
    %ylim([1,480]);
    %grayScaleImage = mat2gray(imread(strcat(fileName,'.bmp')));
    %imshow(grayScaleImage.*intersectedMatrix);
    %error();
end
