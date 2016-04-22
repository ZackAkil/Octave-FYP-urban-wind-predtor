function [windSpeed] = makeSpeedData(direction, width, gWind)
%   generate new wind speed data set based on parameters 
%   direction = angle of road, range from 0 - 180
%   width = width of road, range from 50 - 150
%   gWind = global wind, 2xn matrix of global wind data.
% 	gwind(n,1) - wind speed, gwind(n,2) - wind direction


m = size(gWind,1);

windSpeed = zeros(m,1);

%gaussian functions
windMulti1 =  2.^-(((gWind(:,2)-direction)./width).^2);
windMulti2 =  2.^-(((gWind(:,2)-direction+180)./width).^2);
windMulti3 =  2.^-(((gWind(:,2)-direction-180)./width).^2);
windMulti4 =  2.^-(((gWind(:,2)-direction-360)./width).^2);

windMulti = [windMulti1, windMulti2, windMulti3, windMulti4];

windMulti = max(windMulti')';

windSpeed = windMulti.*(gWind(:,1));

end
