function [ ellipseParams, x, y ] = MakeEllipse( stokes, t )
%UNTITLED5 Summary of this function goes here
%   Detailed explanation goes here

L = stokes(2) + 1i*stokes(3);

A = sqrt(0.5*(stokes(1) + abs(L)));
B = sqrt(0.5*(stokes(1) - abs(L)));
theta = 0.5*angle(L);
h = sign(stokes(4));

%t = linspace(0,2*pi, 1000);

%that's right, a mix of degrees and radians! woop!
x = A.*cosd(t).*cos(theta) - B.*sind(t).*sin(theta);
y = A.*cosd(t).*sin(theta) + B.*sind(t).*cos(theta);

ellipseParams = [A, B, theta, h];

end

