function f = analytical_sho(x1, x2, t)
% Analytical solution for simple harmonic oscillator, includes passed
% parameters for the initial conditions
    f =  x2 * sin(t) + x1 * cos(t);
end