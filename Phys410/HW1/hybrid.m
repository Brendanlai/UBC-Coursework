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
%     function fx = f(x)
%        fx = cos(x)^2;
%     end
% 
%     function val = caller(some_fcn, x)
%        val = some_fcn(x);
%     end
    a = xmin
    b = xmax
    midpoint = (a + b) / 2 
    while f(midpoint) < tol1
        if f(midpoint) < 0 && f(a) < 0
            a = midpoint
        else
            b = midpoint
        end
        midpoint = (a + b) / 2
    end
    estimate = midpoint

    dfdx = diff(f)

    iterate(1) = f(estimate) % Initial estimate

    for i=1:1000 %it should be stopped when tolerance is reached
        iterate(i+1) = iterate(i) - f(iterate(i))/dfdx(iterate(i));
        if( abs(f(iterate(i+1))) < tol2)   % tolerance
            disp(double(iterate(i+1)));
            x = iterate(i+1)
            break;
       end
    end
end

