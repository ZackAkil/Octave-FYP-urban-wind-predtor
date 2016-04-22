clear ; close all; clc



%generate random zone data

numOfZones = 3;

%rand ("seed", 20); %teleport artefact break 6,20

%rand ("seed", 5); % teleport aretfact were system works


streetDirs = rand(1,numOfZones)*360;

streetWidths = rand(1,numOfZones)*10;

% streetDirs = [130,45,150];     
% streetWidths = [6,7,2];

disp([streetDirs',streetWidths']);

data = makeData(streetDirs, streetWidths);


% parse out zone that will try to predict
X = data(:,1:(numOfZones*2)-2);

% scale data of X to be within the range fo 0 and 1
% X = [X(:,1)./50,X(:,2)./360 ,X(:,3)./50,X(:,4)./360];
X = [sinVal(X(:,2)) ,sinVal(X(:,4)),cosVal(X(:,2)) ,cosVal(X(:,4))];

% add polynomial features to X
X = [X, X.^2];


y = sinVal(data(:,6));

y2 = cosVal(data(:,6));

figure (1);
 scatter3(X(:,1),X(:,2),data(:,6));
 % scatter3(X(:,1),X(:,2),y2);

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

[theta2, cost] = fminunc(@(t)(costFunction(t, X, y2)), initial_theta, options);

% Print theta to screen
fprintf('Cost at theta found by fminunc: %f\n', cost);
fprintf('theta: \n');

p = predict(theta, X);
p2 = predict(theta2, X);

pDist = mod(atan2d((p-0.5).*2,(p2-0.5).*2),360);

absdiff = abs (data(:,6) - pDist);

fprintf('average error in degrees: %f\n', mean(absdiff));

figure (2);
 scatter3(X(:,2),X(:,3),pDist);
 % scatter3(X(:,2),X(:,3),p2);

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