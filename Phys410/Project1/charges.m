%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% charges: Top-level function for solution of charges-on-a-sphere
% problem.
%
% Input arguments
%
% r0: Initial positions (nc x 3 array, where nc is the number of
% charges)
% tmax: Maximum simulation time
% level: Discretization level
% gamma: Dissipation coefficient
% epsec: Tolerance for equivalence class analysis
%
% Output arguments
%
% t: Vector of simulation times (length nt row vector)
% r: Positions of charges (nc x 3 x nt array)
% v: Potential vector (length nt row vector)
% v_ec: Equivalence class counts (row vector with length determined
% by equivalence class analysis)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [t, r, v, v_ec] = charges(r0, tmax, level, gamma, epsec)

    dt = tmax / (2^level);
    nt = 2^level + 1;

    [nc,~] = size(r0);

    r = zeros(nc, 3, nt);
    r(:,:,1) = r0;
    r(:,:,2) = r0;

    v = zeros(1, nt);
    t = zeros(1, nt);
    v_ec = 0;

    
    for ts = 2: nt - 1

        summation = zeros(nc, 3);
        % Summation
        for i = 1: nc
            for j = 1: nc
                if i == j
                    continue
                end
                rij = r(j,:,ts) - r(i,:,ts);
                norm = sqrt(rij(1)^2 + rij(2)^2 + rij(3)^2);
                summation(i,:) = summation(i,:) + rij / norm^3;
    
            end
        end
        fprintf("Summation")
        disp(summation)
        disp(r(:,:,ts))

        % Compute FDA - Breakdown terms for simplicity 
        b = r(:, :, ts);
        c = r(:, :, ts - 1);
        
        divisor = (2 * dt + gamma * dt^2)^-1;
 
        term1 = 2 * dt * (2 * b - c);
        term2 = - dt^3 * 2 * summation;
        term3 = gamma * dt^2 * c;
        r(:, :, ts + 1) = divisor * (term1 + term2 + term3);
      
        % Normalize the postion of the charges
        for i = 1: nc
            vec = r(i, :, ts + 1);
            r(i, :, ts + 1) = vec / (sqrt(vec(1)^2 + vec(2)^2 + vec(3)^2));
        end

        % Calculating potentials
        potential = 0;
        for i = 2: nc
            for j = 1: i - 1
                vec = r(i, :, ts) - r(j, : , ts);
                potential = potential + 1 / sqrt(vec(1)^2 + vec(2)^2 + vec(3)^2);
            end
        end
        fprintf("Potential: ")
        display(potential)
        v(ts + 1) = potential;
        
        % update t 
        t(ts) = ts;

    end

    % Equivalence Class thing

    
end