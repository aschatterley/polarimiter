function [ outputStokes ] = Retarder( inputStokes, retardation, theta )
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here

c2t = cosd(2*theta);
s2t = sind(2*theta);

cd = cosd(retardation);
sd = sind(retardation);

muellMat = [
    1,      0,                  0,                      0;
    0,      c2t^2+cd*s2t^2,     c2t*s2t-c2t*s2t*cd,     s2t*sd;
    0,      c2t*s2t-c2t*s2t*cd, c2t^2*cd+s2t^2,         -c2t*sd;
    0,      -s2t*sd,            c2t*sd,                 cd];

outputStokes = muellMat*inputStokes;

end

