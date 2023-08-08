%plot the trajectory
Da=0.099903;

np=30;
x=linspace(0, 0.5, np);
y=zeros(1, np);
for j=1:1:np
    y(j)=y_trajectory(x(j), Da);
end

plot(x, y);
    
