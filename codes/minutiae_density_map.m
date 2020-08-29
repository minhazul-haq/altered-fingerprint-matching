


function minutiae_map = minutiae_density_map( fileName )

    %read all 4 columns from minutiae files
    matrixFromTable = dlmread(strcat(fileName,'.xyt'));

    %keep only first 2 columns: x coordinate of minutiae, y coordinate of minutiae 
    minutiaeTable = matrixFromTable(:,1:2);

    %now calculate minutiae density map using this minutiaeTable & compare the
    %result with page-10 of anil-k-jain's paper

    %disp(minutiaeTable);

    minutiae_map = zeros(512,480);

    min_length = length(minutiaeTable);


    % step#1 : applying kernel function
    for i=1:min_length
        minutiae_x = matrixFromTable(i,1);
        minutiae_y = matrixFromTable(i,2);

        for j=1:512
            for k=1:480
                distance_x = minutiae_x - j;
                distance_y = minutiae_y - k;

                if distance_x>=-40 && distance_x<=40
                    if distance_y>=-40 && distance_y<=40
                        distance = sqrt(distance_x * distance_x + distance_y * distance_y);
                        if distance<=40
                            minutiae_map(j,k) = minutiae_map(j,k) + 0.5;
                        end
                    end
                end

            end
        end
        %minutiae_map(minutiae_x,minutiae_y) = 1;
    end

 %   figure;imshow(mat2gray(minutiae_map)), title('Kernel Function');


    %step#2 : applying gaussian filter
    G = fspecial('gaussian',[30 30], 10);
    minutiae_map = imfilter(minutiae_map,G,'same');


    %step#3 : normalization step
    [max_val,I] = max(minutiae_map(:));
    max_val = max_val * 0.85;

    for i=1:512
        for j=1:480

            kk_val = minutiae_map(i,j);
            if kk_val > max_val
                minutiae_map(i,j) = 1;
            else
                minutiae_map(i,j) = kk_val / max_val;
            end
        end
    end

    minutiae_map_2 = imrotate(minutiae_map,90);
    %figure;
    %imshow(minutiae_map_2),title('Minutiae density map');

end

