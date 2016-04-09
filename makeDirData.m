function [windDir] = makeDirData(direction, width, gWind)
%MAKEDATA generate new data set base of parameters 
%   direction = angle of road, range from 0 - 180
%   width = width of road, range from 0.04 - 0.14
%   gWind = global wind, 2xn matrix of global wind data.
% gwind(n,1) - wind speed, gwind(n,2) - wind direction


m = size(gWind,1);

windDir = zeros(m,1);

%calculate sigmoid functions
windDir1 =  (1./(1+e.^(-(gWind(:,2)-direction+90).*width))).*180;
windDir2 =  (1./(1+e.^(-(gWind(:,2)-direction-90).*width))).*180;
windDir3 =  (1./(1+e.^(-(gWind(:,2)-direction-270).*width))).*180;

%sum sigmoids and loop resut beteween 0 - 360
windDir = mod((windDir1 + windDir2 + windDir3 - 180 + direction),360);


disp(max(windDir))
disp(min(windDir))

end
