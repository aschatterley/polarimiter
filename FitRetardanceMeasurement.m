function [retardance, opticAxis] = FitRetardanceMeasurement(theta, intensity)


%% Fit: 'untitled fit 5'.
[xData, yData] = prepareCurveData( theta, intensity );

% Set up fittype and options.
ft = fittype( 'A*cosd((x-phase)*4)+B', 'independent', 'x', 'dependent', 'y' );
opts = fitoptions( 'Method', 'NonlinearLeastSquares' );
opts.Display = 'Off';
opts.StartPoint = [0.75 0.25 0];

% Fit model to data.
[fitresult, gof] = fit( xData, yData, ft, opts );

% Plot fit with data.
figure;
h = plot( fitresult, xData, yData );

I45 = (fitresult.B-fitresult.A) / (fitresult.B+fitresult.A);
retardance = acosd(2*I45-1)/360;
opticAxis = fitresult.phase*2;
% Label axes
%xlabel x
%ylabel y
grid on

end

