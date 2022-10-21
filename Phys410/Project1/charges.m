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

    v = zeros(1, nt); % To implement the potential for IC (1st and 2nd)
    v(1) = Potential(r, nc, 1); % compute the potentials for 1 and 2 given IC
    v(2) = Potential(r,nc, 2);

    t = linspace(0, tmax, nt)';
   
    for ts = 2: nt - 1

        summation = zeros(nc, 3);        
        % Summation calculation SUM(SUM (rij / rij^3))
        for i = 1: nc
            ri = r(i, :, ts);
            rjMatrix = r(:, :, ts); 
            rjMatrix(i, :) = [];

            rij = rjMatrix - ri; 

            % using vecnorm computes 2 norm of each row
            rijCubed = vecnorm(rij, 2, 2).^3; 
            rij = rij ./ rijCubed;
            summation(i,:) = sum(rij);
        end

        % Compute FDA - Breakdown terms for simplicity 
        divisor = (2 * dt + gamma * dt^2)^-1;
 
        term1 = 2 * dt * (2 * r(:, :, ts) - r(:, :, ts - 1));
        term2 = - dt^3 * 2 * summation;
        term3 = gamma * dt^2 * r(:, :, ts - 1);
        r(:, :, ts + 1) = divisor * (term1 + term2 + term3);
        
        % Normalize the postion of the charges
        for i = 1: nc
            r(i, :, ts + 1) = r(i, :, ts + 1)/norm(r(i, :, ts + 1));
        end

        % Calculating potentials
        v(ts + 1) = Potential(r, nc, ts + 1);
    end

    % Equivalence Class Start
    dij = zeros(nc, nc);

    % Compute dij matrix (all charge distances from charge in question)
    for i = 1: nc
        for j = 1: nc
            vec = r(j, :, end) - r(i, :, end);
            dij(i,j) = norm(vec);
        end
        dij(i,:) = sort(dij(i,:));
    end

    % Computing the equivalence classes
    count = 1; % counting instances of equivalence class
    index = 1;  % v_ec index pointer
    v_ec = [];
    indices = []; % array storing indices pre assigned a class (to skip_
    i2 = 1; % indices pointer

    for i = 1: nc
        if ismember(i, indices)
            continue % If charge already classified skip past it
        end

        for j = 1: nc
            if i == j || ismember(j,indices)
                continue % If charge already classified skip past it
            end
            if abs(dij(i,:) - dij(j, :)) <= epsec
                count = count + 1; % Increment if we know charge is in eq class
                indices(i2) = j;
                i2 = i2 + 1;
            end
        end

        v_ec(index) = count; % Assign the number of charges in eq. class
        index = index + 1;
        count = 1; % Reset count for checking of the next class
    end

    v_ec = sort(v_ec,'descend');

end