function [ I0, outputStokes ] = Polarizer( inputStokes )
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here

muellMat = 0.5 * [
    1 1 0 0;
    1 1 0 0;
    0 0 0 0;
    0 0 0 0;
    ];

outputStokes = muellMat*inputStokes;
I0 = outputStokes(1);
end

