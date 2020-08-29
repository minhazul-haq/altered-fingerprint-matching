%clear all variables
%clear all;
%close all;

function showMinutiae(fileName,probableAlteredArea)

    %read fingerprint image
    image = mat2gray(imread( strcat(fileName,'.bmp') ));

    %figure;
    %imshow(image.*probableAlteredArea);


    %read all 4 columns from minutiae files
    matrixFromTable = dlmread( strcat(fileName,'.xyt') );

    %keep only first 2 columns: x coordinate of minutiae, y coordinate of minutiae 
    minutiaeTable = matrixFromTable(:,1:2);

    
    index = 1;
    disp(size(minutiaeTable,1));
    
    for i=1:size(minutiaeTable,1)
        if ( probableAlteredArea(480-minutiaeTable(i,2),minutiaeTable(i,1))==0 )
            filteredMinutiae(index,1) = minutiaeTable(i,1);
            filteredMinutiae(index,2) = minutiaeTable(i,2);  
            index = index + 1;
        end        
    end
    
    %disp(index);
    %show these minutiae
    %hold on;
    %plot(minutiaeTable(:,1),480-minutiaeTable(:,2),'o','MarkerFaceColor','r','MarkerSize',8);
    %plot(filteredMinutiae(:,1),480-filteredMinutiae(:,2),'o','MarkerFaceColor','g','MarkerSize',8);

    %xlim([1,512]);
    %ylim([1,480]);

    %hold off;


    %k = convhull(minutiaeTable(:,1),minutiaeTable(:,2));

    %hold on;
    %plot(minutiaeTable(k,1),480-minutiaeTable(k,2));
    %hold off;

    %isInHull = inpolygon(100 ,100,minutiaeTable(k,1),minutiaeTable(k,2));

end

