%show orientation field

function show_orientation_field(orientationAngle, blockSize, showWhiteBackground)

    %show orientation
    [totalRow totalCol] = size(orientationAngle);
    
    startingLocationX = blockSize;
    startingLocationY = blockSize;
    
    [X,Y] = meshgrid( startingLocationX : blockSize : blockSize*totalCol, startingLocationY : blockSize : blockSize*totalRow);

    X = X - ( (blockSize/2) * cosd(90-orientationAngle) );
    Y = Y - ( (blockSize/2) * sind(90-orientationAngle) );

    orientationX = cosd( 90 - orientationAngle );
    orientationY = sind( 90 - orientationAngle );

    if showWhiteBackground
        whiteMatrix = ones(totalRow*blockSize, totalCol*blockSize);    
        imshow(whiteMatrix);
    end
    
    %show it in quiver
    hold on;
    QV = quiver(X, Y, orientationX, orientationY, 0.6);
    set(QV,'ShowArrowHead','off');
    set(QV,'linewidth',3);
    set(QV,'color',[0,0,0]);
    hold off;

end