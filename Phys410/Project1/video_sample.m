format long

% Initialize parameters
nc = 12;
tmax = 200;
level = 10;
gamma = 1;
epsec = 10^-5;

r0 = 2 * rand(nc,3) - 1;

% Normalize r0
for i = 1: nc
    vec = r0(i, :);
    r0(i, :) = vec / norm(vec);
end

% Run simulation 
[t, r, v, ~] = charges(r0, tmax, level, gamma, epsec);

% Create video
charges_video(t, r)
