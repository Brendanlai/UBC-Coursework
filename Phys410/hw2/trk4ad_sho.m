clear; clc;

% Initial conditions and parameters
tspan = linspace(0, 3.0 * pi, 65);
x1_0 = 0;
x2_0 = 1;
x0 = [x1_0; x2_0]; 
reltol = [1.0e-5, 1.0e-7, 1.0e-9, 1.0e-11];

figure(1)
hold on
xlabel("Time (t)")
ylabel("Errors")
title("Adaptive RK4 Errors For Varying Relative Tolerances")

% Calculate rk4 adaptive for each different rel tol and plot the error
for i = 1: length(reltol)
    [tout, yout] = rk4ad(@fcn_sho, tspan, reltol(i), x0);
    y_analytical = analytical_sho(x1_0, x2_0, tspan);
    err = y_analytical - yout(1,:);
    plot(tspan, err)
end

legend("reltol=1.0e-5", "reltol=1.0e-7", "reltol=1.0e-9", "reltol=1.0e-11");
