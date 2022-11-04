clear; clc;

global a b omega
% Initial conditions
a = 5;
b = 0;
omega = 0;

x1_0 = 1;
x2_0 = -6;
x0 = [x1_0; x2_0]; 
t0 = [0; 0];

% Simulation parameters
tmax = 100;
level = 12;
dt = 2^(-level) * tmax;
t = 0:dt:tmax;

% Run RK4 method
[tout , xout] = rk4(@fcn_vdp, t, x0);

% Plotting the position versus time
fig1 = figure(1);
hold on
plot(t, xout(1,:), '-r');
xlabel("Time (t)")
ylabel("Position x(t)")
title("van der Pol oscillator, a=5, b=0, omega=0")
hold off

% Plotting the Phase space
fig2 = figure(2);
hold on

% Plot as scatter to avoid potential issues with array sychronization
scatter(xout(1,:), xout(2,:)); 
xlabel("x(t)")
ylabel("dx(t)/dt")
title("van der Pol oscillator Phase Space Diagram, a=5, b=0, omega=0")
hold off
