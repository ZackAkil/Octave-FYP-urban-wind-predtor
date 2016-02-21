clear ; close all; clc



%generate random zone data

numOfZones = 4;

streetDirs = rand(1,numOfZones)*360;

streetWidths = rand(1,numOfZones)*10;

   %streetDirs = [284.8755,281.5558];     
  % streetWidths = [9.9580,3.4044];

disp([streetDirs',streetWidths']);

data = makeData(streetDirs, streetWidths);



% figure (2);
% scatter3(data(:,3),data(:,4),data(:,1));

X = data(:,1:(numOfZones*2)-2);

% scale data of X to be within the range fo 0 and 1
X = [X(:,1)./50,X(:,2)./360,X(:,3)./50,X(:,4)./360];

% add polynomial features to X
X = [X, X.^2, X.^3,X.^4];

y = data(:,(numOfZones*2)-1);

% scale output of y to be between 0 adn 1
y = y./50;

figure (1);
scatter3(X(:,1),X(:,2),y.*50);

xlabel('Zone A wind speed (m/s)');     
ylabel('Zone A wind direction (°)');
zlabel('Zone B wind speed (m/s)');
title('Plot of a zones wind speed and direction against another zones wind speed');

%X = mapFeature(X(:,1),X(:,2));



%  Setup the data matrix appropriately, and add ones for the intercept term
[m, n] = size(X);

% % Add intercept term to x and X_test
X = [ones(m, 1) X];

% Initialize fitting parameters
initial_theta = zeros(n+1, 1);

%  Set options for fminunc
options = optimset('GradObj', 'on', 'MaxIter', 400);

%  Run fminunc to obtain the optimal theta
%  This function will return theta and the cost 
[theta, cost] = fminunc(@(t)(costFunction(t, X, y)), initial_theta, options);

% Print theta to screen
fprintf('Cost at theta found by fminunc: %f\n', cost);
fprintf('theta: \n');
%fprintf(' %f \n', theta);

p = (predict(theta, X)).*50;
y = y.*50;

figure (2);
scatter3(X(:,2),X(:,3),p);
xlabel('Zone A wind speed (m/s)');     
ylabel('Zone A wind direction (°)');
zlabel('Zone B wind speed (m/s)');
title('Plot of a zones wind speed and direction against prediction of another zones wind speed');


%disp(predict(theta))