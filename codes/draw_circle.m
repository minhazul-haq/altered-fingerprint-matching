
function [xp yp] = draw_circle(x,y,r)
    ang=0:0.1:(2*pi)+0.1; 
    xp = x + r*cos(ang);
    yp= y + r*sin(ang);
    plot( xp, yp);
end