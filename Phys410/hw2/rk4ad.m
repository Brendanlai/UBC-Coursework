function [tout, yout] = rk4ad(fcn, tspan, reltol, y0)
% Inputs
%   fcn:    Function handle for right hand sides of ODEs (returns
%           length-n column vector)
%   tspan:  Vector of output times (length nout vector).
%   reltol: Relative tolerance parameter.
%   y0:     Initial values (length-n column vector).
% Outputs
%   tout:   Output times (length-nout column vector, elements identical to tspan).
%   yout:   Output values (nout x n array. The ith column of yout
%           contains the nout values of the ith dependent variable).
    tout = tspan;
    yout = y0;

    floor = 1.0e-4;

    y_temp = y0; % used as the current value for y
    t_temp = tspan(1); % used as current value for t 
    dt = tspan(2) - tspan(1); % initial guess for dt

    t_index = 1;

    while t_index < length(tspan)
        is_not_tol = true; % flag for when reltol is achieved
        while is_not_tol
            % Compute the full dt step (coarse step)
            y_c = rk4step(fcn, t_temp, dt, y_temp);
            
            % Compute 2 half dt steps (fine step)
            y_f1 = rk4step(fcn, t_temp, dt/2, y_temp);
            y_f2 = rk4step(fcn, t_temp + dt/2, dt/2, y_f1);
            
            % Compute caluclated error
            ec = 16/15 * norm(y_c - y_f2);

            % Relative tolerance error
            etol = reltol * norm(y_f2);
            error_factor = abs(ec/etol);

            dt = dt / error_factor^0.2; 
            
            % If the time step has exceeded the next data point reduce dt
            if t_temp + dt >= tspan(t_index + 1)
                dt = tspan(t_index + 1) - t_temp;
                y_temp = rk4step(fcn, t_temp, dt, y_temp);
                t_temp = tspan(t_index + 1);
                is_not_tol = false; % reltol achieved
            elseif dt < floor % Make sure dt isn't too small
                dt = floor; % set dt to floor as min
                y_temp = rk4step(fcn, t_temp, dt, y_temp);
                t_temp = t_temp + dt; % set new t0
            else
                % calculate new values for next iteration of error analysis
                y_temp = rk4step(fcn, t_temp, dt, y_temp);
                t_temp = t_temp + dt;
            end
        end

        % add values for the next tspan having met error criterion
        yout = [yout, y_f2];
        t_index = t_index + 1;
    end

end