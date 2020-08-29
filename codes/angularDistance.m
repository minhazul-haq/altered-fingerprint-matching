
function angle = angularDistance(A,B)
    diff = A.theta - B.theta;
    diff = abs(diff);
    angle = min( diff, 360-diff );
end