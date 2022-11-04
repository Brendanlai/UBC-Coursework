function [tout, yout] = rk4(fcn, tspan, y0)
% Inputs
%     fcn: Function handle for right hand sides of ODEs (returns
%     tspan: Vector of output times (length nout).length-n column vector)
%     y0: Initial values (length-n column vector).
% Outputs
%     tout: Vector of output times.
%     yout: Output values (nout x n array. The ith column of yout contains the nout values of the ith dependent variable).
    yout = y0;
    tout = tspan;
    dt = tspan(2) - tspan(1); % dt equivalent throughout tspan
    
    % calculate rk4 steps for each step in tspan, store results to yout
    for i = 1: length(tspan) - 1
        y = rk4step(fcn, tspan(i), dt, yout(:, i));
        yout = [yout, y];
    end
end