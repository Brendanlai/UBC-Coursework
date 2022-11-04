clear; clc;
global a b omega
% Initial conditions
a = 5;
b = 0;
omega = 0;

x1_0 = 1;
x2_0 = -6;
x0 = [x1_0; x2_0];

% Simulation parameters
tmax = 100;
level = 12;
dt = tmax/(2^level + 1);
t = 0:dt:tmax;
reltol = 1.0e-10;

% Run RK4 method
[tout , xout] = rk4ad(@fcn_vdp, t, reltol, x0);

% Plotting the position versus time
fig1 = figure(1);
hold on
plot(t, xout(1,:), '-r');
xlabel("Time (t)")
ylabel("Position x(t)")
title("Adaptive RK4 Van der Pol oscillator, a=5, b=0, \omega=0")
hold off

% Plotting the Phase space
fig2 = figure(2);
hold on
scatter(xout(1,:), xout(2,:));
xlabel("x(t)")
ylabel("dx(t)/dt")
title("Adaptive RK4 Van der Pol oscillator Phase Space Diagram, a=5, b=0, \omega=0")
hold off
