% JUST FOR TESTING DIFFUSIONS

function [x, y, t, u] = ...
         diffusion_test(tmax, level, lambda, idtype, idpar)
    
    nx = 2^level + 1;    
    ny = nx;
    dx = 2^ - level;
    dy = dx;
    dt = lambda * dx;
    nt = round(tmax / dt) + 1;
    
    x = linspace(0, 1, nx);
    y = linspace(0, 1, ny);
    t = [0 : nt-1] * dt;
    
    % Initialize solution, and set initial data ...
    u = zeros(nt, nx, ny);
    u_half = zeros(nx,ny);
    
    if idtype == 0
        mx = idpar(1);
        my = idpar(2);
        u(1, :, :) = sin(mx * pi * x)' * sin(my * pi * y);
    elseif idtype == 1
        return % Place holder
    else
        fprintf("Invalid idtype\n")
        return
    end
    
    % Initialize storage for sparse matrix and RHS ...
    dl = zeros(nx,1);
    d  = zeros(nx,1);
    du = zeros(nx,1);
    rhs  = zeros(nx,1);
    
    % Set up tridiagonal system ...
    % Update lower, main, upper diag given by derivation from scheme
    dl = -dt/(2 * dx^2) * ones(nx, 1);
    d  = (1 + dt/dx^2) * ones(nx,1);
    du = dl;
    
    % Homogenous boundary conditions
    d(1) = 1.0;
    du(2) = 0.0;
    dl(nx-1) = 0.0;
    d(nx) = 1.0;
    
    % Define sparse matrix 
    A = spdiags([dl d du], -1:1, nx, ny);
    
    % Compute solution using implicit scheme 
    for n = 1: nt - 1


        rhs(2:nx-1,2:ny-1) = ...
            (1 - dt/dx^2 -dt/dy^2 + dt^2/(dx^2*dy^2))*u(n,2:nx-1,2:ny-1)...
            + (dt/(2*dx^2))*(u(n,3:nx, 2:ny-1) + u(n,1:nx-2, 2:ny-1))...
            + (dt/(2*dy^2))*(u(n,2:nx-1, 3:ny) + u(n,2:nx-1, 1:ny-2))...
            + (dt^2/(4*dx^2*dy^2)) * (...
            u(n,3:nx, 3:ny) + u(n,3:nx, 1:ny-2) + u(n,1:nx-2, 1:ny-2) + u(n,1:nx-2, 3:ny))...
            + (-2*dt^2/(4*dx^2*dy^2)) * (u(n,3:nx, 2:ny-1) + u(n,1:nx-2, 2:ny-1) + u(n,2:nx-1, 3:ny) + u(n,2:nx-1, 1:ny-2));

        
        for j = 2: ny - 1
            u_half(:, j) = A \ rhs(:, j);
        end
        
        for i = 2: nx - 1
            u(n+1, i, :)= A \ u_half(i, :)';
        end
    
    end

end