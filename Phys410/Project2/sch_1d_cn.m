function [x, t, psi, psire, psiim, psimod, prob, v] = ...
    sch_1d_cn(tmax, level, lambda, idtype, idpar, vtype, vpar)
% Inputs 
%     tmax:    Maximum integration time
%     level:   Discretization level
%     lambda:  dt/dx
%     idtype:  Selects initial data type
%     idpar:   Vector of initial data parameters
%     vtype:   Selects potential type
%     vpar:    Vector of potential parameters
% Outputs
%     x:       Vector of x coordinates [nx]
%     t:       Vector of t coordinates [nt]
%     psi:     Array of computed psi values [nt x nx]
%     psire:   Array of computed psi_re values [nt x nx]
%     psiim:   Array of computed psi_im values [nt x nx]
%     psimod:  Array of computed sqrt(psi psi*) values [nt x nx]
%     prob:    Array of computed running integral values [nt x nx]
%     v:       Array of potential values [nx]
   nx = 2^level + 1;
   x = linspace(0.0, 1.0, nx);
   dx = 2^-level;
   dt = lambda * dx;
   nt = round(tmax / dt) + 1;
   t = [0 : nt-1] * dt;

   % Initialize solution, and set initial data ...
   psi = zeros(nt, nx);

   if idtype == 0
      m = idpar(1);
      psi(1, :) = sin(m * pi * x);
      % Boundary conditions already set to zero 

   elseif idtype == 1
      x0 = idpar(1);
      delta = idpar(2);
      p = idpar(3);

      psi(1, :) = exp(1i * p * x) .* exp(-((x - x0) ./ delta) .^ 2);
      % Boundary conditions already set to zero 

   else
      fprintf('sch_1d_cn: Invalid idtype=%d\n', idtype);
      return
   end
   
   v = zeros(nx, 1);

   if vtype == 0
      v = zeros(nx, 1);

   elseif vtype == 1
       x_min_index = round(length(x) * vpar(1));
       x_max_index = round(length(x) * vpar(2));
       V_c = vpar(3);
       
       v(x_min_index: x_max_index) = V_c;
   else
      fprintf('sch_1d_cn: Invalid vtype=%d\n', vtype);
      return
   end

   % Initialize storage for sparse matrix and RHS ...
   dl = zeros(nx,1);
   d  = zeros(nx,1);
   du = zeros(nx,1);
   rhs  = zeros(nx,1);

   % Set up tridiagonal system ...
   % Update lower, main, upper diag given by derivation from scheme
   dl = ones(nx, 1) * (2 * dx^2)^-1;
   d  = (1i / dt - dx^-2 - v/2);
   du = dl;

   % Homogenous boundary conditions
   d(1) = 1.0;
   du(2) = 0.0;
   dl(nx-1) = 0.0;
   d(nx) = 1.0;

   % Define sparse matrix 
   A = spdiags([dl d du], -1:1, nx, nx);

   % Compute solution using implicit scheme 
   for n = 1: nt - 1
      % Define RHS of linear system
      rhs(2: nx-1) = -(2*dx^2)^-1 .* psi(n, 3:nx)...
          + (1i/dt + dx^-2 + 1/2 * v(2:nx-1)') .* psi(n, 2:nx-1)...
          - (2*dx^2)^-1 .* psi(n, 1:nx-2);
      rhs(1) = 0.0;
      rhs(nx) = 0.0;

      % Solve system, thus updating approximation to next time step using 
      % left division
      psi(n+1, :) = A \ rhs;
   end
    
   % Assign the arrays for the different psi components
   psire = real(psi);
   psiim = imag(psi);
   psimod = abs(psi);
   
   prob = zeros(nt, nx);

   % Calculate the probability matrix using the trapezoidal rule for
   % integral approximation
   for i = 2: nx
       prob(:, i) = prob(:, i-1) + 1/2*(psi(:,i).*conj(psi(:,i)) + psi(:,i-1).*conj(psi(:,i-1)))*(x(i) - x(i-1));
   end
end