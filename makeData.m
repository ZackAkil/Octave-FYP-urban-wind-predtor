function [data] = makeData(directions, widths)
%MAKEDATA generate new data set base of parameters 
%   directions = set of road angles, range from 0 - 180
%   widths = set of road widths, range from 0 - 10
%   gWind = global wind, 2xn matrix of global wind data.
% gwind(n,1) - wind speed, gwind(n,2) - wind direction



windSpeed = [0:0.13889:50]';
windDir = [0:359]';

[p,q] = meshgrid(windSpeed, windDir);
pairs = [p(:) q(:)];

gw = pairs;


nRows = size(gw,1); % number of rows
nSample = 1000; % number of samples

rndIDX = randperm(nRows); 

newSample = gw(rndIDX(1:nSample), :); 

gw = newSample;

%gw = [windSpeed,windDir];

data = zeros(size(gw,1),size(directions,2)*2);

for i = 1:size(directions,2)

temp1 = makeSpeedData(directions(i),(widths(i)*10)+50,gw);

temp2 = makeDirData(directions(i),0.14-(widths(i)*0.01),gw);

data(:,(i*2)-1) = temp1;
data(:,i*2) = temp2;

endfor


end
