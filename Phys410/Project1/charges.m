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

        % Compute FDA - Breakdown terms for simplicity 
        divisor = (2 * dt + gamma * dt^2)^-1;
 
        term1 = 2 * dt * (2 * r(:, :, ts) - r(:, :, ts - 1));
        term2 = - dt^3 * 2 * summation;
        term3 = gamma * dt^2 * r(:, :, ts - 1);
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

        v(ts + 1) = potential;
        
        % update t 
        t(ts) = ts;

    end

    % Equivalence Class 
    
    dij = zeros(nc, nc);
    % Compute dij matrix (all charge distances)
    for i = 1: nc
        for j = 1: nc % If looking at the same charge assign dummy 1 and skip
            vec = r(j, :, end) - r(i, :, end);
            dij(i,j) = sqrt(vec(1)^2 + vec(2)^2 + vec(3)^2);
        end
        dij(i,:) = sort(dij(i,:));
    end

    % computing 
    count = 1;
    index = 1;
    v_ec = [];
    indices = [];
    i2 = 1;
    
    for i = 1: nc
        if ismember(i, indices)
            continue
        end
        for j = 1: nc
            if i == j || ismember(j,indices)
                continue
            end
            if abs(dij(i,:) - dij(j, :)) <= epsec
                count = count + 1;
                indices(i2) = j;
                i2 = i2 + 1;
            end
        end
        v_ec(index) = count;
        index = index + 1;
        count = 1;
    end

    v_ec = sort(v_ec,'descend');

end