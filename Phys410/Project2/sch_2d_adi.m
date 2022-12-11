function [x, y, t, psi, psire, psiim, psimod, v] = ...
         sch_2d_adi(tmax, level, lambda, idtype, idpar, vtype, vpar)
% Inputs 
%     tmax:     Maximum integration time
%     level:    Discretization level
%     lambda:   dt/dx
%     idtype:   Selects initial data type
%     idpar:    Vector of initial data parameters
%     vtype:    Selects potential type
%     vpar:     Vector of potential parameters
% Outputs
%     x:        Vector of x coodrinates [nx]
%     y:        Vector of y coordinates [ny]
%     t:        Vector of t coordinates [nt]
%     psi:      Array of computed psi values [nt x nx x ny]
%     psire:    Array of computed psi_re values [nt x nx x ny]
%     psiim:    Array of computed psi_im values [nt x nx x ny]
%     psimod:   Array of computed sqrt(psi psi*) values [nt x nx x ny]
%     v:        Array of potential values [nx x ny]

    nx = 2^level + 1;    
    ny = nx;
    dx = 2^-level;
    dy = dx;
    dt = lambda * dx;
    nt = round(tmax / dt) + 1;
    
    x = linspace(0, 1, nx);
    y = linspace(0, 1, ny);
    t = [0 : nt-1] * dt;
    
    % Initialize solution, and set initial data
    psi = zeros(nt, nx, ny);
    
    if idtype == 0
        mx = idpar(1);
        my = idpar(2);

        % Initial solution
        psi(1, :, :) = sin(mx * pi * x).' * sin(my * pi * y);

        % Boundary conditions
        psi(:,1,:) = 0;
        psi(:,:,1) = 0;
        psi(:,end,:) = 0;
        psi(:,:,end) = 0;
        
    elseif idtype == 1
        x0 = idpar(1);
        y0 = idpar(2);
        del_x = idpar(3);
        del_y = idpar(4);
        px = idpar(5);
        py = idpar(6);
        
        % Initial solution
        psi(1, :, :) = exp(1i*px*x).' * exp(1i*py*y) .*...
            exp(-(((x-x0).'/del_x).^2+((y-y0)/del_y).^2));

        % Boundary conditions
        psi(1,1,:) = 0;
        psi(1,:,1) = 0;
        psi(1,end,:) = 0;
        psi(1,:,end) = 0;
    else
        fprintf("Invalid idtype\n")
        return
    end

    % Potential types
    v = zeros(nx,ny); % Set initial v array
    if vtype == 0
        v = zeros(nx,ny);
    elseif vtype == 1
        x_min_index = round(nx * vpar(1));
        x_max_index = round(nx * vpar(2));
        y_min_index = round(nx * vpar(3));
        y_max_index = round(nx * vpar(4));
        V_c = vpar(5);
        
        % Set values to V_c in the range of x/y_min to x/y_max
        v(x_min_index:x_max_index, y_min_index:y_max_index) = V_c;

    elseif vtype == 2
        V_c = vpar(5);
        x1_index = round(nx * vpar(1));
        x2_index = round(nx * vpar(2));
        x3_index = round(nx * vpar(3));
        x4_index = round(nx * vpar(4));

        jp = (ny - 1)/4 + 1;
        v(1:x1_index, jp: jp+1) = V_c;
        v(x2_index: x3_index, jp: jp+1) = V_c;
        v(x4_index: nx, jp: jp+1) = V_c;
    else
        fprintf("Invalid vtype\n")
        return
    end
    
    % Initialize storage for sparse matrix and RHS ...
    dl = zeros(nx,1);
    d  = zeros(nx,1);
    du = zeros(nx,1);
    
    % Set up tridiagonal system ...
    % Update lower, main, upper diag given by derivation from scheme
    % Set up tridiagonal vectors for step 1
    dl = -(1i*dt)/(2*dx^2) * ones(nx,1);
    d = (1 + 1i*dt/(dx^2)) * ones(nx,1);
    du = dl;
    
    % Homogenous fixed boundary conditions
    d(1) = 1.0;
    du(2) = 0.0;
    dl(nx-1) = 0.0;
    d(nx) = 1.0;

    A = spdiags([dl d du], -1:1, nx, nx);

    % Compute solution using ADI scheme 
    for n = 1: nx-1
        
        % Caluclate temporary psi_value 
        % Equivalent to resulting scheme of dyy of psi
        psi_i_jp1 = squeeze(psi(n, 2:nx-1, 3:ny));
        psi_i_jm1 = squeeze(psi(n, 2:nx-1, 1:ny-2));
        psi_i_j = squeeze(psi(n, 2:nx-1, 2:ny-1));
        
        psi_temp = zeros(nx, ny);
        psi_temp(2:nx-1, 2:ny-1) = 1i*dt/(2*dy^2) * (psi_i_jp1 + psi_i_jm1)...
            + (1 - 1i*dt/dy^2 - (1i * dt/2) * v(2:nx-1, 2:ny-1)) .* psi_i_j;

        % Use psi_temp to calculate complete rhs of ADI scheme
        psi_t_ip1_j = psi_temp(1:nx-2, 2:ny-1);
        psi_t_im1_j = psi_temp(3:nx, 2:ny-1);
        psi_t_i_j = psi_temp(2:nx-1, 2:ny-1);

        rhs  = zeros(nx,ny);

        rhs(2:nx-1,2:ny-1) = 1i*dt/(2*dx^2) * (psi_t_ip1_j + psi_t_im1_j)...
            + (1 - 1i * dt/(dx^2)) * psi_t_i_j;

        % Calculate psi_half using rhs
        psi_half = A \ rhs;


        for i = 2: nx - 1
            % Set up tridiagonal vectors for step 2
            dl = -ones(nx,1) * (1i*dt/(2*dy^2));
            du = dl;
            d = 1 + 1i*dt/dy^2 + (1i*dt/2) * v(i,:).';
            % Fix boundary conditions

            d(1) = 1.0;
            du(2) = 0.0;
            dl(nx-1) = 0.0;
            d(nx) = 1.0;
            
            A2 = spdiags([dl d du], -1:1, nx, nx);

            psi(n+1, i, :)= A2 \ psi_half(i, :).';
        end   
    end
    
    % extract real, imaginary, and modulus of psi to return in func output
    psire = real(psi);
    psiim = imag(psi);
    psimod = abs(psi);
end