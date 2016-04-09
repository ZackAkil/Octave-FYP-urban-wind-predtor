clear ; close all; clc



%generate random zone data

numOfZones = 3;

%rand ("seed", 20); %teleport artefact break 6,20

%rand ("seed", 5); % teleport aretfact were system works


%streetDirs = rand(1,numOfZones)*360;

%streetWidths = rand(1,numOfZones)*10;

  streetDirs = [45,130,15];     
  streetWidths = [3,7,8];

disp([streetDirs',streetWidths']);

data = makeData(streetDirs, streetWidths);


% parse out zone that will try to predict
X = data(:,1:(numOfZones*2)-2);

% scale data of X to be within the range fo 0 and 1
% X = [X(:,1)./50,X(:,2)./360 ,X(:,3)./50,X(:,4)./360];
X = [X(:,2)./360 ,X(:,4)./360];

% add polynomial features to X
X = [X, X.^2, X.^3,X.^4];

%y = data(:,(numOfZones*2)-1);

% y = data(:,(numOfZones*2)-1);
y = data(:,(numOfZones*2));

% scale output of y to be between 0 adn 1
% y = y./50;
y = y./360;

figure (1);
scatter3(X(:,4).*360,X(:,2).*360,y.*360);

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
options = optimset('GradObj', 'on', 'MaxIter', 4000);

%  Run fminunc to obtain the optimal theta
%  This function will return theta and the cost 


[theta, cost] = fminunc(@(t)(costFunction(t, X, y)), initial_theta, options);

% Print theta to screen
fprintf('Cost at theta found by fminunc: %f\n', cost);
fprintf('theta: \n');
%fprintf(' %f \n', theta);

p = (predict(theta, X)).*360;
y = y.*50;

figure (2);
scatter3(X(:,2),X(:,3),p);

xlabel('Zone A wind speed (m/s)');     
ylabel('Zone A wind direction (°)');
zlabel('Zone B wind speed (m/s)');
title('Plot of a zones wind speed and direction against prediction of another zones wind speed');

%draw mesh of hypothesis

meshX = meshY = [0:0.05:1];

[gM,qM] = meshgrid(meshX,meshY);

pairs = [gM(:) qM(:)];

transPairs = [pairs, pairs.^2, pairs.^3,pairs.^4];

transPairs = [ones(size(transPairs,1), 1) transPairs];

predictPairs = (predict(theta, transPairs));

zz = reshape(predictPairs,size(meshX,2),size(meshX,2));

figure(3);

mesh(meshX,meshY,zz);



%disp(predict(theta))