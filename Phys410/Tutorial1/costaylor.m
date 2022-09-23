
val = costaylor1(1, 0.003, 102)
% another function definition
% x: value of x at which the approximation is to be computed
% tol: tolerance for the computation -> function returns the approximation
%      when the magnitude of the current term being summed is less than this
%      value
% 
% kmax: maximum number of terms that will be summed
function val = costaylor1(x, tol, kmax)
    val = 0;
    for k =  0:kmax
        term = (-1)^k*x^(2*k)/factorial(2*k);
        if abs(term) < tol
            break
        else
            val = val + term;
        end
    end
        
end