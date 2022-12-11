function f = diffusion_exact(mx, my, x, y, t)
    f =  exp(-(mx^2 + my^2) * pi^2 * t) * sin(mx * pi * x)' * sin(mx * pi * y);
end