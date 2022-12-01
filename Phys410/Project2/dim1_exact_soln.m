function f = dim1_exact_soln(m, x, t)
    f =  exp(1i * m^2 * pi^2 * t)' * sin(m * pi * x);
end