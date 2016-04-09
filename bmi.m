
height = rand(200,1);

weight = ((height.* 2.5)+ normrnd(0,0.7,200,1));

scatter((height)+5, ((weight./3) .*40)+60);

xlabel('Height (feet)','fontsize', 16);     
ylabel('Weight (kg)','fontsize', 16);

title('Plot of peoples weight against their height','fontsize', 16);

xheight = [5,6];
yweight = (xheight.*30)-95;



hold on;

% plot(xheight,yweight);

set(gca, 'fontsize', 16);

hold off;