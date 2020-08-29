%{
4.1.2 feature extraction_error map
Paper source: Altered Fingerprint Analysis_jain,feng,woon
%}

function errorMapPixelMatrix = error_map( estimatedOrientation, approximatedOrientation, blockSize )
 
    %errorMapPixelMatrix : 60 X 64 pixels 
    %errorMapBlockMatrix : (60X8) X (64X8) pixels
    
    [totalRow totalCol] = size(estimatedOrientation);

    for m=1:totalRow
        for n=1:totalCol

            absDiff = abs( estimatedOrientation(m,n) - approximatedOrientation(m,n) );
            errorAmount = min(absDiff , 180-absDiff) / 90;
            
            if (isnan(errorAmount)==1) 
                errorAmount = 0; 
            end
            
            errorMapPixelMatrix(m,n) = errorAmount; 

            for p = ((m-1)*blockSize)+1 : (m*blockSize)
                for q = ((n-1)*blockSize)+1 : (n*blockSize)
                    errorMapBlockMatrix(p,q) = errorAmount;
                end
            end
        end
    end
    
    %figure;
    %imshow(errorMapBlockMatrix);
    %title('Error map');
    
end