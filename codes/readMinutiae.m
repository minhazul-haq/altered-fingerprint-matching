


function minutiaeStruct = readMinutiae(fileName,probableAlteredArea)

    %read all 4 columns from minutiae files
    matrixFromFile = dlmread( fileName );

    totalMinutiae = size(matrixFromFile,1);
    
    if (probableAlteredArea==0) %natural
        for i=1:totalMinutiae
            minutiaeStruct(i).x = matrixFromFile(i,1);
            minutiaeStruct(i).y = matrixFromFile(i,2);
            minutiaeStruct(i).theta = matrixFromFile(i,3);
            minutiaeStruct(i).quality = matrixFromFile(i,4);
        end
    else %altered
        j=1;
        for i=1:totalMinutiae
            if ( probableAlteredArea(480-matrixFromFile(i,2),matrixFromFile(i,1))==0 )
                minutiaeStruct(j).x = matrixFromFile(i,1);
                minutiaeStruct(j).y = matrixFromFile(i,2);
                minutiaeStruct(j).theta = matrixFromFile(i,3);
                minutiaeStruct(j).quality = matrixFromFile(i,4);
                j = j + 1;
            end
        end
    end
    
end