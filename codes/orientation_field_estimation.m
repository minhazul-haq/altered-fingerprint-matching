%{
Paper source: Systematic Methods for the Computation of the Directional Fields and 
              Singular Points of Fingerprints by Bazen & Gerez

Implementation: Mohammad Minhazul Haq
%}


function orientationAngle = orientation_field_estimation( grayScaleImage, blockSize )


    %total row and column
    [totalRow, totalCol] = size(grayScaleImage);


    % apply sobel X operator
    sobelX = fspecial('sobel');
    Gx = filter2(sobelX,grayScaleImage); % imfilter??


    % apply sobel Y operator
    sobelY = transpose(sobelX);
    Gy = filter2(sobelY,grayScaleImage);


    for i=1:totalRow
        for j=1:totalCol
            if sign(Gx(i,j))==-1 
                Gx(i,j) = -Gx(i,j); 
                Gy(i,j) = -Gy(i,j);
            end
        end
    end

    thresholdValue = 50;

    % thresholding Gx and Gy
    for i=1:totalRow
        for j=1:totalCol
            if abs(Gx(i,j)) + abs(Gy(i,j)) <= thresholdValue 
                Gx(i,j) = 0;
                Gy(i,j) = 0; 
            end
        end
    end
   

    Gsx = ( Gx .* Gx ) - ( Gy .* Gy );
    Gsy = 2 .* Gx .* Gy;


    %smoothing orientation field by 15X15 averaging filter
    filterSize = 15;
    averagingFilter = ones( filterSize, filterSize ) / (filterSize*filterSize);
    Gsx = filter2(averagingFilter, Gsx);
    Gsy = filter2(averagingFilter, Gsy);

    %average each block (8X8 pixels area)
    totalBlockRow = floor(totalRow / blockSize);
    totalBlockCol = floor(totalCol / blockSize);

    orientationAngle = NaN(totalBlockRow,totalBlockCol);


    for m=1:totalBlockRow
        for n=1:totalBlockCol
            sumX = 0;
            sumY = 0;

            for p = ((m-1)*blockSize)+1 : (m*blockSize)
                for q = ((n-1)*blockSize)+1 : (n*blockSize)
                    sumX = sumX + Gsx(p,q);
                    sumY = sumY + Gsy(p,q);
                end
            end

            sumY = sumY / (blockSize*blockSize);
            sumX = sumX / (blockSize*blockSize);

            avgGsy_by_avgGsx = sumY / sumX;        


            if (sumX>=0)
                gradientAngle = atand(avgGsy_by_avgGsx);
            elseif (sumX<0) && (sumY>=0) 
                gradientAngle = atand(avgGsy_by_avgGsx) + 180;
            elseif (sumX<0) && (sumY<0) 
                gradientAngle = atand(avgGsy_by_avgGsx) - 180;
            end


            gradientAngle = 0.5 * gradientAngle;


            if (gradientAngle<=0)
                orientationAngle(m,n) = gradientAngle + 90;
            elseif (gradientAngle>0)
                orientationAngle(m,n) = gradientAngle - 90;    
            end

            if (orientationAngle(m,n)<0)
                orientationAngle(m,n) = orientationAngle(m,n) + 180;
            end

        end
    end


end
