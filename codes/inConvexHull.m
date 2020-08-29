


function isInHull = inConvexHull(A, xDiff, yDiff, aDiff, minutiaeSet, index)

    x = A.x-xDiff;
    y = A.y-yDiff;
    
    xx = x*cos(-aDiff*pi/180) - y*sin(-aDiff*pi/180);
    yy = x*sin(-aDiff*pi/180) + y*cos(-aDiff*pi/180);
    
    isInHull = inpolygon(xx,yy,[minutiaeSet(index).x],[minutiaeSet(index).y]);

end