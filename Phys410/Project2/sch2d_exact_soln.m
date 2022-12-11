function f = sch2d_exact_soln(mx, my, x, y, t)
    f =  exp(-1i * (mx^2 + my^2) * pi^2 * t).' * sin(mx*pi*x) .* sin(my*pi*y);
end