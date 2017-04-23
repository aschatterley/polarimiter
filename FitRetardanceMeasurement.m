function [retardance, opticAxis] = FitRetardanceMeasurement(theta, intensity)

fftI = fft(intensity);
opticAxis = -angle(fftI(5))*90/(pi);
B = abs(fftI(1))/length(intensity);
A = 2*abs(fftI(5))/length(intensity);

I45FT = (B-A) / (B+A);
retardance = acosd(2*I45FT-1)/360;

figure;
plot(theta, intensity, 'o'); hold on

fftCalc = zeros(size(fftI));
fftCalc(1) = abs(fftI(1));
fftCalc(5) = fftI(5);
fftCalc(end-3) = fftI(end-3);
plot(theta, real(ifft(fftCalc)));
grid on;

end

