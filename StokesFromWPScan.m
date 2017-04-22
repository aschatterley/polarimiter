function [ S ] = StokesFromWPScan( intensity, angle, retardance )
%StokesFromWPScan Retreive stokes from QWP scan
%   Detailed explanation goes here

fftI = fft(intensity);

a =    real(fftI(1)) / length(angle);
b =  2*imag(fftI(3)) / length(angle);
c =  2*real(fftI(5)) / length(angle);
d = -2*imag(fftI(5)) / length(angle);

S = [];
S(1) = a-c/(tand(360*retardance/2)^2);
S(2) = 2*c/(2*sind(360*retardance/2)^2);
S(3) = 2*d/(2*sind(360*retardance/2)^2);
S(4) = b/sind(360*retardance);

S = S./S(1);
end

