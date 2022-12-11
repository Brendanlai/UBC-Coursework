% tdiff_1d_ftcs.m: Driver for diff_1d_ftcs ... Solution of 1d diffusion
% equation using O(dt, dx^2) explicit scheme.
more off;

format long;

% idtype = 0   ->  sine initial data (exact solution known)
% idtype = 1   ->  gaussian initial data

idtype = 0;

tmax = 0.2;
x0 = 0.5;
delta = 0.05;
omega = 2 * pi;

minlevel = 6;
maxlevel = 9;

% alpha = dt / dx^2
% Von Neumann stability restriction is alpha <= 1/2
alpha = 0.49;

% Enable for MATLAB surface plots. 
plotit = 0;
if plotit
   close all
end

% Perform computation at various levels of discretization, store
% results in cell arrays.
for l = minlevel : maxlevel
   tstart = tic;
   [x{l}, t{l}, u{l}] = diff_1d_ftcs(tmax, l, alpha, omega, ...
												 x0, delta, idtype, 1);
   telapsed = toc(tstart)
   [nt{l}, nx{l}] = size(u{l});
   stride{l} = round(((nt{l} - 1) / (nx{l} - 1)) * 2^(l - minlevel));
   
   % If possible, compute exact solution.
   if idtype == 0
      uxct{l} = zeros(nt{l}, nx{l});
      for n = 1 : nt{l}
         uxct{l}(n,:) = exp(-4 * pi^2 * t{l}(n)) * sin(2 * pi * x{l});
      end
   end

	if plotit
      for it = 1 : nt{l}
			figure(l);
         plot(x{l},u{l}(it,:));
         xlim([0, 1]);
         ylim([-1, 1]);
         drawnow;
		end
	end

   if idtype == 0
		uerr = u{l}(1:stride{l}:end, :) - uxct{l}(1:stride{l}:end, :);
		fprintf('Level: %d  alpha: %g  ||error||: %25.16e\n', ...
         l, alpha, sqrt(sum(sum((uerr .* uerr))) / prod(size(uerr))));
   end

end
