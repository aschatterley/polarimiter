function [ S, calculatedI ] = StokesFromWPScan( intensity, angle, retardance )
%StokesFromWPScan Retreive stokes from QWP scan.
%   intensity: intensity transmitted through polarizer
%   angle: angles of waveplate
%   retardance: retardance of WP in waves
%   Returns the stokes vector in S, and the calcualted trace in calc.

fftI = fft(intensity);

%delete all other frequencies
fftICalc = zeros(size(fftI));
fftICalc(1) = real(fftI(1));
fftICalc(3) = 1i*imag(fftI(3));
fftICalc(5) = fftI(5);
fftICalc(end-1) = 1i*imag(fftI(end-1));
fftICalc(end-3) = fftI(end-3);


calculatedI = real(ifft(fftICalc));


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

