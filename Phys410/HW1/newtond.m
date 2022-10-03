function x = newtond(f, jac, x0, tol)
%
%
%  jac:  Function which is of the form jac(x) where x is a length-d vector, and
%        which returns the d x d matrix of Jacobian matrix elements.
%  x0:   Initial estimate for iteration (length-d column vector).
%  tol:  Convergence criterion: routine returns when relative magnitude
%        of update from iteration to iteration is <= tol.
    x = x0'
    res = f(x) % residual
    dx = jac(x) \ res
    while rms(dx) > tol
        res = f(x)
        dx = jac(x) \ res
        x = x - dx
    end
end