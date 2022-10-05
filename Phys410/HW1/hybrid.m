function x = hybrid(f, dfdx, xmin, xmax, tol1, tol2)
% Hybrid algorithm implementing bisection and newton's method to calculate
% roots
% Input Arguments:
%     f:    Function whose root is sought.
%     dfdx: Derivative function.
%     xmin: Initial bracket minimum.
%     xmax: Initial bracket maximum.
%     tol1: Relative convergence criterion for bisection.
%     tol2: Relative convergence criterion for Newton iteration.
% Output Argument 
%     x:    Estimate of root.
    a = xmin;
    b = xmax;
    midpoint = (a + b) / 2; % Calculate Midpoint

    % Continuously compute new midpoints until we have converged on a root 
    while abs(f(midpoint)) > tol1 
        if f(midpoint)*f(a) < 0
            b = midpoint;
        else
            a = midpoint;
        end
        midpoint = (a + b) / 2;
    end

    xn = midpoint; % estimate from bisection method
    err = 1;
    i = 1;
    
    % Newton's method
    % Implement formula while error is less than tolerance and less than 50
    % iterations have been completed.
    while err > tol2 && i <= 50
        xnp1 = xn - f(xn)/dfdx(xn);
        err = abs(xnp1 - xn);
        xn = xnp1;
        i = i + 1;
    end

    x = xnp1; % Final root estimate
end