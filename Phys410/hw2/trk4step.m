clear; clc;
steps = 4; % Number of steps for per step error ratio to find

% Initial conditions
y1_0 = 3;x
y2_0 = 1;
y0 = [y1_0; y2_0]; 

% Level 13 parameter
level = 13;
tmax = 20*pi;
dt = tmax / (2^level + 1);
t = 0:dt:tmax;
y_rk4 = y0;

e_l13 = zeros(steps,1);
% Calculate first "steps" steps of the solution and associated error
for i = 1:steps
    y = rk4step(@fcn_sho, t(i), dt, y_rk4(:,i));
    y_rk4 = [y_rk4, y];
    e_l13(i) = y_rk4(1, i+1) - analytical_sho(y1_0, y2_0, t(i+1));
end

% Repeat for level 14 (double the mesh points)
level = 14;
dt = tmax / (2^level + 1);
t = 0:dt:tmax;
y_rk4 = y0;

e_l14 = zeros(steps,1);
for i = 1:steps
    y = rk4step(@fcn_sho, t(i), dt, y_rk4(:,i));
    y_rk4 = [y_rk4, y];
    e_l14(i) = y_rk4(1, i+1) - analytical_sho(y1_0, y2_0, t(i+1));
end

fprintf("The ratio of the local errors (we expect 2^5 = 32)\n")
disp(e_l13 ./ e_l14)
