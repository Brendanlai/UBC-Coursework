clear; clc;

% Initial conditions
x1_0 = 0;
x2_0 = 1;
x0 = [x1_0; x2_0]; 
t0 = [0; 0];

% Simulation parameters
tmax = 3 * pi;
levels = [6,7,8];
scale = [1, (2^4)^1,(2^4)^2];

hold on
figure(1)
xlabel("Time")
ylabel("Scaled Error")
title("Simple Harmonic Oscillator Scaled Position Error (O(\Deltat^4))")

% Plotting the scaled errors
for i = 1: length(levels)
    nt = 2^levels(i) + 1;
    t = linspace(0, tmax, nt);
    
    [t, x_rk4] = rk4(@fcn_sho, t, x0);
    x_analytical = analytical_sho(x1_0, x2_0, t);
    err = x_analytical(1,:) - x_rk4(1,:);

    plot(t,err * scale(i))
end
hold off

% Plotting the non scaled errors (done as extra to verify)
figure(2)
hold on
xlabel("Time")
ylabel("Error")
title("Simple Harmonic Oscillator Position Error")

for i = 1: length(levels)
    nt = 2^levels(i) + 1;
    t = linspace(0, tmax, nt);
    
    [t, x_rk4] = rk4(@fcn_sho, t, x0);
    x_analytical = analytical_sho(x1_0, x2_0, t);
    err = x_analytical(1,:) - x_rk4(1,:);
    
    plot(t,err)
end
