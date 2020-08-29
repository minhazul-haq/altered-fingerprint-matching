
function dist = neighborDistance(A, xDiff, yDiff, aDiff, B)
    
    x = A.x-xDiff;
    y = A.y-yDiff;
    
    xx = x*cos(-aDiff*pi/180) - y*sin(-aDiff*pi/180);
    yy = x*sin(-aDiff*pi/180) + y*cos(-aDiff*pi/180);
    
    dist = sqrt( ( xx-B.x )^2 + ( yy-B.y )^2 );
end
