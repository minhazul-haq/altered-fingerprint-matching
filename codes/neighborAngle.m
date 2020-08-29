
function angle = angularDistance(A, theta, B)
    diff = A.theta - theta - B.theta;
    angle = abs(diff);
end