

%function for 1X189 feature vector from errorMap and densityMap
function concatenatedFeatureVector = histogram_feature( errorMapMatrix, densityMapMatrix ) 
    
    %find features from errorMapMatrix
    A = ones(8,8);
    A = double(A);

    zoomedErrorMapMatrix = kron( errorMapMatrix , A );

    % calculate 9 cells each of 20X20 blocks or 160X160 pixels
    error_cell_1 = zoomedErrorMapMatrix( [1:160], [1:160] );
    error_cell_2 = zoomedErrorMapMatrix( [1:160], [161:320] );
    error_cell_3 = zoomedErrorMapMatrix( [1:160], [321:480] );
    
    error_cell_4 = zoomedErrorMapMatrix( [161:320], [1:160] );
    error_cell_5 = zoomedErrorMapMatrix( [161:320], [161:320] );
    error_cell_6 = zoomedErrorMapMatrix( [161:320], [321:480] );
    
    error_cell_7 = zoomedErrorMapMatrix( [321:480], [1:160] );
    error_cell_8 = zoomedErrorMapMatrix( [321:480], [161:320] );
    error_cell_9 = zoomedErrorMapMatrix( [321:480], [321:480] );

    
    %calculate histogram for each cell
    min_value = 0;
    max_value = 1;
    number_of_bins = 21;
    
    bin_range = double(max_value - min_value) / double(number_of_bins);
    half_of_bin_range = double(bin_range/2);
    
    bin_mid_points = min_value + half_of_bin_range : bin_range : max_value - half_of_bin_range;
    
    
    errorMapFeatureVector(1:21) = hist(error_cell_1(:), bin_mid_points);    
    errorMapFeatureVector(22:42) = hist(error_cell_2(:), bin_mid_points);
    errorMapFeatureVector(43:63) = hist(error_cell_3(:), bin_mid_points);
    
    errorMapFeatureVector(64:84) = hist(error_cell_4(:), bin_mid_points);
    errorMapFeatureVector(85:105) = hist(error_cell_5(:), bin_mid_points);
    errorMapFeatureVector(106:126) = hist(error_cell_6(:), bin_mid_points);
    
    errorMapFeatureVector(127:147) = hist(error_cell_7(:), bin_mid_points);
    errorMapFeatureVector(148:168) = hist(error_cell_8(:), bin_mid_points);
    errorMapFeatureVector(169:189) = hist(error_cell_9(:), bin_mid_points);    
    

    
    %histogram normalization kora hoy nai
    
    %now find features from densityMapMatrix
    % calculate 9 cells each of 20X20 blocks or 160X160 pixels
    density_cell_1 = densityMapMatrix( [1:160], [1:160] );
    density_cell_2 = densityMapMatrix( [1:160], [161:320] );
    density_cell_3 = densityMapMatrix( [1:160], [321:480] );
    
    density_cell_4 = densityMapMatrix( [161:320], [1:160] );
    density_cell_5 = densityMapMatrix( [161:320], [161:320] );
    density_cell_6 = densityMapMatrix( [161:320], [321:480] );
    
    density_cell_7 = densityMapMatrix( [321:480], [1:160] );
    density_cell_8 = densityMapMatrix( [321:480], [161:320] );
    density_cell_9 = densityMapMatrix( [321:480], [321:480] );

    
    %calculate histogram for each cell
    densityMapFeatureVector(1:21) = hist(density_cell_1(:), bin_mid_points);    
    densityMapFeatureVector(22:42) = hist(density_cell_2(:), bin_mid_points);
    densityMapFeatureVector(43:63) = hist(density_cell_3(:), bin_mid_points);
    
    densityMapFeatureVector(64:84) = hist(density_cell_4(:), bin_mid_points);
    densityMapFeatureVector(85:105) = hist(density_cell_5(:), bin_mid_points);
    densityMapFeatureVector(106:126) = hist(density_cell_6(:), bin_mid_points);
    
    densityMapFeatureVector(127:147) = hist(density_cell_7(:), bin_mid_points);
    densityMapFeatureVector(148:168) = hist(density_cell_8(:), bin_mid_points);
    densityMapFeatureVector(169:189) = hist(density_cell_9(:), bin_mid_points);
    
    
    concatenatedFeatureVector = errorMapFeatureVector + densityMapFeatureVector;
end