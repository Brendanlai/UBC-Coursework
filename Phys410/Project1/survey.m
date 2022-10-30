format long
tic

% Initialize parameters
tmax = 3000;
level = 17;
gamma = 1;
epsec = 10^-5;

% Open files to write to
vsurvey = fopen('vsurvey.dat','w');
ecsurvey = fopen('ecsurvey.dat','w');

% loop for survey ncharges 2 to 60 
for nc = 2 : 60
    % Initialize r0 and normalize
    r0 = 2 * rand(nc,3) - 1; 
    for j = 1: nc
        r0(j, :) = r0(j, :) / norm(r0(j, :));
    end

    [t, r, v, v_ec] = charges(r0, tmax, level, gamma, epsec);

    % write to vsurvey.dat
    fprintf(vsurvey, '%3d %16.10f\n', nc, v(end));

    % write to ecsurvey.dat
    fprintf(ecsurvey, '%3d ', nc);
    fprintf(ecsurvey, '%d ', v_ec);
    fprintf(ecsurvey, '\n');
end

fclose('all');
