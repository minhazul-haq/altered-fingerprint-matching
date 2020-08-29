%{
least square multivariate polynomial regression
Paper source: Altered Fingerprint Analysis_jain,feng,woon
%}

function approximatedOrientationReshaped = least_square_regression(estimatedOrientation, blockSize)

    [totalRow totalCol] = size(estimatedOrientation);

    index = 0;
    
    for i=1:totalRow
        for j=1:totalCol
            
            if (isfinite(estimatedOrientation(i,j))) %only finite values
               
                index = index + 1;
                
                xyPoints(index,1) = i; %row no.
                xyPoints(index,2) = j; %col no.
            
                knownCos2theta(index,1) = cosd(2*estimatedOrientation(i,j));
                knownSin2theta(index,1) = sind(2*estimatedOrientation(i,j));
           
            end
                        
        end
    end
    
    
    % multivariate polynomial regression of order 6
    pFitCos = polyfitn( xyPoints, knownCos2theta, 6 );    
    pFitSin = polyfitn( xyPoints, knownSin2theta, 6 );
    
    
    %find out the approximated orientation using polynomial model
    approximatedCos2theta =  polyvaln( pFitCos, xyPoints );
    approximatedSin2theta =  polyvaln( pFitSin, xyPoints );
        
    
    for m=1:index
        doubledDegree = atand( approximatedSin2theta(m) / approximatedCos2theta(m) );
    
        if ((approximatedCos2theta(m) < 0) && (approximatedSin2theta(m) >= 0)) 
            doubledDegree = doubledDegree + 180;
        elseif ((approximatedCos2theta(m) <= 0) && (approximatedSin2theta(m) < 0)) 
            doubledDegree = doubledDegree + 180;
        elseif ((approximatedCos2theta(m) > 0) && (approximatedSin2theta(m) < 0)) 
            doubledDegree = doubledDegree + 360;
        end
                
        approximatedOrientation(m,1) = 0.5 * doubledDegree;        
    end
    
    
    approximatedOrientationReshaped = NaN(totalRow, totalCol);
    
    
    for n=1:index
        approximatedOrientationReshaped( xyPoints(n,1), xyPoints(n,2) ) = approximatedOrientation(n,1);
    end
    
end